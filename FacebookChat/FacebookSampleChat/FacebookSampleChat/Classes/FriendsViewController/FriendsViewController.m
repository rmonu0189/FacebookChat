//
//  FriendsViewController.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "FriendsViewController.h"
#import "FacebookController.h"
#import "FriendTableViewCell.h"
#import "FriendData.h"
#import "ChatViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize arrFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePresence:) name:kFacebookReceivePresenceNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFriendsList:) name:kFacebookReceiveFriendsList object:Nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.arrFriends count]>0) {
        [self.arrFriends removeAllObjects];
    }
    self.arrFriends = [[[FacebookController sharedInstance] facebook].facebookFriends mutableCopy];
    [self reloadUpdatedFriendsList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadUpdatedFriendsList{
    for (FriendData *data in self.arrFriends) {
        data.presence = [NSString stringWithFormat:@"%d",UNAVAILABLE];
    }
    for (NSString *friendID in [[FacebookController sharedInstance] xmppController].onlineFacebookFriends) {
        NSString *matchStr = [[friendID componentsSeparatedByString:@"@"] objectAtIndex:0];
        for (FriendData *data in self.arrFriends) {
            if ([matchStr isEqualToString:[NSString stringWithFormat:@"-%@",data.friendID]]) {
                data.presence = [NSString stringWithFormat:@"%d",AVAILABLE];
                break;
            }
        }
    }
    
    if(self.arrFriends!=nil){
        NSArray * descriptors =
        [NSArray arrayWithObjects:FIRST_DESCRIPTOR,SECOND_DESCRIPTOR, nil];
        NSArray * sortedArray = [self.arrFriends sortedArrayUsingDescriptors:descriptors];
        NSMutableArray *tmpArr = [sortedArray mutableCopy];
        [self.arrFriends removeAllObjects];
        self.arrFriends = tmpArr;
    }
    [self.tblFriends performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveFriendsList:(NSNotification *) notification{
    self.arrFriends = [[[FacebookController sharedInstance] facebook].facebookFriends mutableCopy];
    [self reloadUpdatedFriendsList];
}

- (void)didReceivePresence:(NSNotification *) notification{
    //NSString *buddyName = (NSString*)[notification object];
    [self reloadUpdatedFriendsList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Online User (%lu)",(unsigned long)[[[FacebookController sharedInstance] xmppController].onlineFacebookFriends count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifire = @"cell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if(!cell){
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifire];
    }
    cell.imgUserPic.image = nil;
    FriendData *data = [self.arrFriends objectAtIndex:indexPath.row];
    cell.lblName.text = data.name;
    
    if ([data.presence isEqualToString:[NSString stringWithFormat:@"%d",AVAILABLE]]) {
        cell.imgPresence.image = [UIImage imageNamed:@"presense_green_32.png"];
    }
    else{
        cell.imgPresence.image = nil;
    }
    [cell setUserProfileImage:data.imageURL];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendData *data = [self.arrFriends objectAtIndex:indexPath.row];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.friendDetails = [data copy];
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
