//
//  ChatTableViewCell.m
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell
@synthesize messageTextView;
@synthesize imgBubble;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imgBubble = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:self.imgBubble];
        
        self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.messageTextView.editable = NO;
        self.messageTextView.scrollEnabled = NO;
        self.messageTextView.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
        self.messageTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageTextView];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createBlankBubble{
    self.messageTextView.text = @"";
    self.imgBubble.image = nil;
}

- (void)createBubbleWithMessage:(NSString *)message isReceive:(BOOL)isReceive{
    [self.imgBubble setContentMode:UIViewContentModeScaleToFill];
    [self.imgBubble setBackgroundColor:[UIColor clearColor]];
    if (isReceive) {
        self.imgBubble.image = [[UIImage imageNamed:@"chatBubbleReceiveMessage.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25];
    }
    else{
        self.imgBubble.image = [[UIImage imageNamed:@"chatBubbleSendMessage.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25];
    }
    CGRect rect;
    CGSize size = [message sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:13.0f] }];
    if (size.width >= maxBubbleWidth) {
        int numberOfLines = ((int)size.width/(maxBubbleWidth-25))+1;
        rect = CGRectMake(0, 0, maxBubbleWidth, 13*numberOfLines);
    }
    else{
        rect = CGRectMake(0, 0, size.width, 13);
    }
    self.messageTextView.frame = CGRectMake(25, 5, rect.size.width+20, rect.size.height+25);;
    self.messageTextView.text = message;
    self.imgBubble.frame = CGRectMake(0, 0, rect.size.width+50, rect.size.height+32);
}

@end
