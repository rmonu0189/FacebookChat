//
//  FriendTableViewCell.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
{
    UILabel *lblName;
    UIImageView *imgPresence;
    UIImageView *imgUserPic;
    NSOperationQueue *queue;
}
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) UIImageView *imgPresence;
@property (nonatomic, retain) UIImageView *imgUserPic;
- (void)setUserProfileImage:(NSString *)strURl;
@end
