//
//  ChatTableViewCell.h
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
{
    UITextView *messageTextView;
    UIImageView *imgBubble;
}
@property (nonatomic, retain) UIImageView *imgBubble;
@property (nonatomic, retain) UITextView *messageTextView;
- (void)createBubbleWithMessage:(NSString *)message isReceive:(BOOL)isReceive;
- (void)createBlankBubble;
@end
