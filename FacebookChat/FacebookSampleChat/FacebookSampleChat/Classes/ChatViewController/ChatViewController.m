//
//  ChatViewController.m
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "Database.h"
#import "MessageData.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize friendDetails,arrMessage;

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
    self.lblTitle.text = self.friendDetails.name;
    [self.imgUser setImageWithURL:[NSURL URLWithString:self.friendDetails.imageURL] placeholderImage:nil];
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = 3.0f;
    if ([self.friendDetails.presence isEqualToString:[NSString stringWithFormat:@"%d",UNAVAILABLE]]) {
        self.imgPresence.hidden = YES;
    }
    else{
        self.imgPresence.hidden = NO;
    }
    self.arrMessage = [[Database sharedInstance] getMessageForUser:friendDetails.friendID];
    MessageData *data = [[MessageData alloc] init];
    [self.arrMessage insertObject:data atIndex:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:kFacebookReceiveMessageNotification object:Nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)onKeyboardShow:(NSNotification *) notification{
    NSLog(@"onKeyboardShow");
    NSDictionary *info  = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGRect rect = self.tblChatBubble.frame;
    rect.size.height = rect.size.height-keyboardFrame.size.height;
    self.tblChatBubble.frame = rect;
    rect = self.viewTextBox.frame;
    rect.origin.y = rect.origin.y - keyboardFrame.size.height;
}

- (void)onKeyboardHide:(NSNotification *) notification{
    NSLog(@"onKeyboardHide");
    NSDictionary *info  = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGRect rect = self.tblChatBubble.frame;
    rect.size.height = rect.size.height+keyboardFrame.size.height;
    self.tblChatBubble.frame = rect;
    rect = self.viewTextBox.frame;
    rect.origin.y = rect.origin.y + keyboardFrame.size.height;
}

- (void)designFrameWhenKeyboardShow:(BOOL)isShow{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (isShow) {
        
    }
    else{
        
    }
}

- (void)didReceiveMessage:(NSNotification *) notification{
    NSDictionary *message = [notification object];
    if (message!=nil) {
        NSString *msg = [message valueForKey:@"body"];
        if ([msg length]>0) {
            int numberOfLines;
            CGSize size = [msg sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:13.0f] }];
            if (size.width >= 260.0f) {
                numberOfLines = ((int)size.width/(260-25))+1;
            }
            MessageData *data = [[MessageData alloc] init];
            data.message = msg;
            data.height = (14*numberOfLines)+50;
            data.isReceive = YES;
            [self.arrMessage addObject:data];
            [self.tblChatBubble reloadData];
            [self displayEndOfMessage];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate sharedInstance].tabBarViewController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self displayEndOfMessage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppDelegate sharedInstance].tabBarViewController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayEndOfMessage{
    CGFloat contentHeight = self.tblChatBubble.contentSize.height;
    if (contentHeight>self.tblChatBubble.frame.size.height) {
        [self.tblChatBubble setContentOffset:CGPointMake(0, contentHeight-self.tblChatBubble.frame.size.height) animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrMessage count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageData *message = [self.arrMessage objectAtIndex:indexPath.row];
    CGRect rect;
    CGSize size = [message.message sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:13.0f] }];
    if (size.width >= maxBubbleWidth) {
        int numberOfLines = ((int)size.width/(maxBubbleWidth-25))+1;
        rect = CGRectMake(0, 0, maxBubbleWidth, 13*numberOfLines);
    }
    else{
        rect = CGRectMake(0, 0, size.width, 13);
    }
    if (indexPath.row==0) {
        return 30;
    }
    else{
        return rect.size.height+35;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifire = @"cell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if(!cell){
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifire];
    }
    if (indexPath.row==0) {
        [cell createBlankBubble];
        return cell;
    }
    MessageData *message = [self.arrMessage objectAtIndex:indexPath.row];
    [cell createBubbleWithMessage:message.message isReceive:YES];
    return cell;
}

@end
