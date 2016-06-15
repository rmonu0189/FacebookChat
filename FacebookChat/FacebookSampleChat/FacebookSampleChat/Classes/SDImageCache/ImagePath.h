//
//  ImagePath.h


#import <Foundation/Foundation.h>

@interface ImagePath : NSObject
{
    NSString *ImagePath;
    NSDate *ImageDate;
    int FileSize;
}
@property(nonatomic,retain) NSString *ImagePath;
@property(nonatomic,retain) NSDate *ImageDate;
@property(nonatomic,assign) int FileSize;
@end
