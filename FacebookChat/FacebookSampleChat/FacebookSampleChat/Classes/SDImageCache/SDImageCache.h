
#import <Foundation/Foundation.h>
#import "SDImageCacheDelegate.h"

@interface SDImageCache : NSObject
{
    NSMutableDictionary *memCache, *storeDataQueue;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
     NSMutableArray *data;
}

+ (SDImageCache *)sharedImageCache;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image imageData:(NSData *)datas forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (UIImage *)imageFromKey:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)queryDiskCacheForKey:(NSString *)key delegate:(id <SDImageCacheDelegate>)delegate userInfo:(NSDictionary *)info;

- (void)removeImageForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;

@end
