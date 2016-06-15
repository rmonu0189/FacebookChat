

#import <Foundation/Foundation.h>
#import "SDWebImageDownloaderDelegate.h"

@interface SDWebImageDownloader : NSObject
{
    @private
    NSURL *url;
    id<SDWebImageDownloaderDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *imageData;
}

@property (nonatomic, retain) NSURL *url;
@property id<SDWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *imageData;

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;

// This method is now no-op and is deprecated
+ (void)setMaxConcurrentDownloads:(NSUInteger)max __attribute__((deprecated));

@end
