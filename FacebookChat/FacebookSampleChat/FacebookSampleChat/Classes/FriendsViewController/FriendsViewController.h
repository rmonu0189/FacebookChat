//
//  FriendsViewController.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController
{
    NSMutableArray *arrFriends;
}
@property (weak, nonatomic) IBOutlet UITableView *tblFriends;
@property (nonatomic, retain) NSMutableArray *arrFriends;
@end
