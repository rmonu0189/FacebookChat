//
//  ChatViewController.h
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendData.h"

@interface ChatViewController : UIViewController<UITableViewDataSource>
{
    FriendData *friendDetails;
    NSMutableArray *arrMessage;
}
@property (nonatomic, retain) NSMutableArray *arrMessage;
@property (nonatomic, retain) FriendData *friendDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)clickedBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgPresence;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITableView *tblChatBubble;
@property (weak, nonatomic) IBOutlet UIView *viewTextBox;

@end
