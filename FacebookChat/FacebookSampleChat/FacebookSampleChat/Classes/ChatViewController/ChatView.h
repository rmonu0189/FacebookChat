//
//  ChatView.h
//  Knuz
//
//  Created by Monu Rathor on 18/02/13.
//  Copyright (c) 2013 HWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bubble.h"

@interface ChatView : UIViewController<UITextViewDelegate>
{
    IBOutlet UIScrollView *bubbleScrollView;
    IBOutlet UIView *controlView;
    IBOutlet UIImageView *imageViewTextAndButton;
    IBOutlet UIButton *buttonSend;
    IBOutlet UITextView *textViewMessage;
    BOOL isKyeboardShow;
    CGFloat offsetY;
    UIImage *myImage,*buddyImage;
    BOOL isGroup;
}
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, retain) UIImage *myImage,*buddyImage;
@property (nonatomic, retain) IBOutlet UIScrollView *bubbleScrollView;
@property (nonatomic, retain) IBOutlet UIView *controlView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewTextAndButton;
@property (nonatomic, retain) IBOutlet UIButton *buttonSend;
@property (nonatomic, retain) IBOutlet UITextView *textViewMessage;
- (void)receiveMessageWithMessage:(NSString *)message;
@end
