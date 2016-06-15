#import "SDImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "ImagePath.h"
static NSInteger cacheMaxCacheAge = 60*60*24*7; // 1 week
#define cacheSizeDisk     10*1024*1024
static SDImageCache *instance;
@implementation SDImageCache

#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        // Init the memory cache
        memCache = [[NSMutableDictionary alloc] init];

        // Init the disk cache
        storeDataQueue = [[NSMutableDictionary alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        data=[[NSMutableArray alloc] init];
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }

        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;

        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];

        #ifdef __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemory)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
        #endif
    }

    return self;
}

#pragma mark SDImageCache (class methods)

+ (SDImageCache *)sharedImageCache
{
    if (instance == nil)
    {
        instance = [[SDImageCache alloc] init];
    }

    return instance;
}

#pragma mark SDImageCache (private)

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

    return [diskCachePath stringByAppendingPathComponent:filename];
}
-(void)sortArray
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ImageDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [data sortUsingDescriptors:sortDescriptors];
    
}
-(void)FillData:(NSArray *)directoryContents Path:(NSString *)Path
{
    for (NSString *path in directoryContents) {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSString *fullPath = [Path stringByAppendingPathComponent:path];
        NSDictionary* attrs = [fm attributesOfItemAtPath:fullPath error:nil];
        if (attrs != nil) {
            NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];
            ImagePath *i=[[ImagePath alloc] init];
            i.ImagePath=fullPath;
            i.ImageDate=date;
            i.FileSize=[[attrs objectForKey:NSFileSize] intValue];
            [data addObject:i];
        }
        
        else {
        }
    }
}
-(void)RemovePath:(NSMutableArray *)PathArray
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *keys = [storeDataQueue allKeys];
    for (int i=0; i<[PathArray count]; i++) {
        id aKey = [keys objectAtIndex:i];
        NSString *path   =[PathArray objectAtIndex:i];
        [storeDataQueue removeObjectForKey:aKey];
        BOOL removeSuccess = [fileMgr removeItemAtPath:path error:&error];
        if (removeSuccess) 
        {
            
        }
    }
}
- (void) removeAllObjects:(NSString *)Path ImageSize:(int)Size
{
       [data removeAllObjects];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:Path error:&error];
        if (error == nil)
        {
            [self FillData:directoryContents Path:Path];
            [self sortArray];
            int ImageSize=0;
            NSMutableArray *PathArray=[[NSMutableArray alloc] init];
            for (ImagePath *obj in data) 
            {
                if (ImageSize<Size) {
                    [PathArray addObject:obj.ImagePath];
                    ImageSize=ImageSize+obj.FileSize;
                }
                else {
                    break;
                }
            }
            if ([PathArray count]>0) {
                [self RemovePath:PathArray];
            }
            [PathArray removeAllObjects];
            PathArray=nil;
        } 
        else
        {
            
        }
}
-(unsigned long long int)getsize
{
    return (unsigned long long int)cacheSizeDisk;
}
- (void)storeKeyToDisk:(NSString *)key
{
    // Can't use defaultManager another thread
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSData *datas = [storeDataQueue objectForKey:key];
    if (datas)
    {
        if (folderSize(diskCachePath)<[self getsize]) 
        {
             [fileManager createFileAtPath:[self cachePathForKey:key] contents:datas attributes:nil];    
        }
        else
        {
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:datas attributes:nil];    
            [self removeAllObjects:diskCachePath ImageSize:[datas length]];
        }
        @synchronized(storeDataQueue)
        {
            [storeDataQueue removeObjectForKey:key];
        }
    }
    else
    {
        // If no data representation given, convert the UIImage in JPEG and store it
        // This trick is more CPU/memory intensive and doesn't preserve alpha channel
        UIImage *image = [self imageFromKey:key fromDisk:YES]; // be thread safe with no lock
        if (image)
        {
            if (folderSize(diskCachePath)<[self getsize]) 
            {
                 [fileManager createFileAtPath:[self cachePathForKey:key] contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil]; 
            }
            else
            {
                NSData *datas=(UIImageJPEGRepresentation(image, (CGFloat)1.0));
                 [fileManager createFileAtPath:[self cachePathForKey:key] contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil];  
                [self removeAllObjects:diskCachePath ImageSize:datas.length];
            }
        }
    }

}

- (void)notifyDelegate:(NSDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    id <SDImageCacheDelegate> delegate = [arguments objectForKey:@"delegate"];
    NSDictionary *info = [arguments objectForKey:@"userInfo"];
    UIImage *image = [arguments objectForKey:@"image"];

    if (image)
    {
        [memCache setObject:image forKey:key];

        if ([delegate respondsToSelector:@selector(imageCache:didFindImage:forKey:userInfo:)])
        {
            [delegate imageCache:self didFindImage:image forKey:key userInfo:info];
        }
    }
    else
    {
        if ([delegate respondsToSelector:@selector(imageCache:didNotFindImageForKey:userInfo:)])
        {
            [delegate imageCache:self didNotFindImageForKey:key userInfo:info];
        }
    }
}

- (void)queryDiskCacheOperation:(NSDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    NSMutableDictionary *mutableArguments = [arguments mutableCopy];

    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self cachePathForKey:key]];
    if (image)
    {
        [mutableArguments setObject:image forKey:@"image"];
    }

    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:mutableArguments waitUntilDone:NO];
}

#pragma mark ImageCache

- (void)storeImage:(UIImage *)image imageData:(NSData *)datas forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!image || !key)
    {
        return;
    }

    if (toDisk && !datas)
    {
        return;
    }

    [memCache setObject:image forKey:key];

    if (toDisk)
    {
        [storeDataQueue setObject:datas forKey:key];
        [cacheInQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeKeyToDisk:) object:key]];
    }
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image imageData:nil forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeImage:image imageData:nil forKey:key toDisk:toDisk];
}


- (UIImage *)imageFromKey:(NSString *)key
{
    return [self imageFromKey:key fromDisk:YES];
}

- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil)
    {
        return nil;
    }

    UIImage *image = [memCache objectForKey:key];

    if (!image && fromDisk)
    {
        image = [[UIImage alloc] initWithContentsOfFile:[self cachePathForKey:key]];
        if (image)
        {
            [memCache setObject:image forKey:key];
        }
    }

    return image;
}

- (void)queryDiskCacheForKey:(NSString *)key delegate:(id <SDImageCacheDelegate>)delegate userInfo:(NSDictionary *)info
{
    if (!delegate)
    {
        return;
    }

    if (!key)
    {
        if ([delegate respondsToSelector:@selector(imageCache:didNotFindImageForKey:userInfo:)])
        {
            [delegate imageCache:self didNotFindImageForKey:key userInfo:info];
        }
        return;
    }

    // First check the in-memory cache...
    UIImage *image = [memCache objectForKey:key];
    if (image)
    {
        // ...notify delegate immediately, no need to go async
        if ([delegate respondsToSelector:@selector(imageCache:didFindImage:forKey:userInfo:)])
        {
            [delegate imageCache:self didFindImage:image forKey:key userInfo:info];
        }
        return;
    }

    NSMutableDictionary *arguments = [NSMutableDictionary dictionaryWithCapacity:3];
    [arguments setObject:key forKey:@"key"];
    [arguments setObject:delegate forKey:@"delegate"];
    if (info)
    {
        [arguments setObject:info forKey:@"userInfo"];
    }
    [cacheOutQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(queryDiskCacheOperation:) object:arguments]];
}

- (void)removeImageForKey:(NSString *)key
{
    if (key == nil)
    {
        return;
    }

    [memCache removeObjectForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
}

- (void)clearMemory
{
    [cacheInQueue cancelAllOperations]; // won't be able to complete
    [memCache removeAllObjects];
}

- (void)clearDisk
{
    [cacheInQueue cancelAllOperations];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

@end
