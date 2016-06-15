//
//  FriendTableViewCell.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell
@synthesize imgUserPic,imgPresence,lblName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 40)];
        [self.lblName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.lblName];
        
        self.imgUserPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        self.imgUserPic.layer.masksToBounds = YES;
        self.imgUserPic.layer.cornerRadius = 3.0f;
        [self addSubview:self.imgUserPic];
        
        self.imgPresence = [[UIImageView alloc] initWithFrame:CGRectMake(295, 15, 15, 15)];
        [self addSubview:self.imgPresence];
        
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)setUserProfileImage:(NSString *)strURl{
    [self.imgUserPic setImageWithURL:[NSURL URLWithString:strURl] placeholderImage:nil];
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

@end
