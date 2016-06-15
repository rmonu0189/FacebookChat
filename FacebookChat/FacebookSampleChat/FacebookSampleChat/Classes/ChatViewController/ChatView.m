//
//  ChatView.m
//  Knuz
//
//  Created by Monu Rathor on 18/02/13.
//  Copyright (c) 2013 HWS. All rights reserved.
//

#import "ChatView.h"

@implementation ChatView

@synthesize bubbleScrollView;
@synthesize imageViewTextAndButton;
@synthesize buttonSend;
@synthesize controlView;
@synthesize textViewMessage;
@synthesize myImage,buddyImage;
@synthesize isGroup;

UIImage *myImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)setBubbleScrollAnimation{
    CGFloat height;
    CGPoint point;
    if(isKyeboardShow == YES){
        height = 140;
        point = CGPointMake(0, bubbleScrollView.contentSize.height - 150);
    }
    else{
        height = 320;
        point = CGPointMake(0, bubbleScrollView.contentSize.height- self.view.frame.size.height+60);
    }
    if(bubbleScrollView.contentSize.height>=height){
        [UIView beginAnimations:@"newViewId" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        bubbleScrollView.contentOffset = point;
        [UIView commitAnimations];
    }
}

- (void)frameNormalSize{
    CGFloat originY = controlView.frame.origin.y;
    if(textViewMessage.frame.size.height > 30){
        originY = originY + 10;
    }
    controlView.frame = CGRectMake(0, originY, 320, 50);
    textViewMessage.frame = CGRectMake(12, 10, 232, 30);
    imageViewTextAndButton.frame = CGRectMake(10, 10, 230, 35);
    buttonSend.frame = CGRectMake(250, 12, 60, 30);
    bubbleScrollView.frame = CGRectMake(0, 0, 320, controlView.frame.origin.y-1);
}

- (void)frameBigSize{
    controlView.frame = CGRectMake(0, 140, 320, 60);
    textViewMessage.frame = CGRectMake(12, 10, 230, 40);
    imageViewTextAndButton.frame = CGRectMake(10, 3 , 232, 55);
    buttonSend.frame = CGRectMake(250, 22, 60, 30);
    bubbleScrollView.frame = CGRectMake(0, 0, 320, controlView.frame.origin.y-1);
}


- (void)createBubbleMessage:(NSString *)message DisplayImage:(UIImage *)image IsReceive:(BOOL)receive{
    Bubble *textBubble = [[Bubble alloc] initWithTextMessage:message isRecieved:receive UserImage:image];
    offsetY = bubbleScrollView.contentSize.height;
    CGRect bubbleFrame = textBubble.frame;
    bubbleFrame.origin = CGPointMake(0, offsetY);
    [bubbleScrollView addSubview:textBubble];
    textBubble.frame = bubbleFrame;
    bubbleScrollView.contentSize = CGSizeMake(320, offsetY+bubbleFrame.size.height+10);
    textViewMessage.text = @"";
    if(UIKeyboardDidShowNotification){
        [self setBubbleScrollAnimation];
    }
    else{
        [self setBubbleScrollAnimation];
    }
    [self frameNormalSize];
}

- (void)receiveMessageWithMessage:(NSString *)message{
    
    [self createBubbleMessage:message DisplayImage:buddyImage IsReceive:YES];
}

- (void)clickSend{
   /* NSString *trimmedString = [textViewMessage.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedString length]==0) {
        textViewMessage.text=@"";
        [self frameNormalSize];
        return;
    }
    Message *message = [[Message alloc]init];
    message.messageBody = textViewMessage.text;
    message.type = @"send";
    message.from = [NSString stringWithFormat:@"%@%@",self.title,[Connection sharedConnection].idHostName];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    BuddyMessage *buddyMsg1 = [[BuddyMessage alloc]init];
    BOOL isMatch = NO;
    for(int i=0;i<[[Connection sharedConnection].chatBuddyMessageArray count];i++){
        buddyMsg1 = [[Connection sharedConnection].chatBuddyMessageArray objectAtIndex:i];
        if([buddyMsg1.buddyName isEqualToString:[Connection sharedConnection].currentChattingBuddy]){
            temp = buddyMsg1.messageArray;
            NSLog(@"\n@@@@@@@@@buddyMsg.buddyName:%@    buddyName:%@",buddyMsg1.buddyName,[Connection sharedConnection].currentChattingBuddy);
            [[Connection sharedConnection].chatBuddyMessageArray removeObject:buddyMsg1];
            isMatch = YES;
        }
    }
    BuddyMessage *buddyMsg = [[BuddyMessage alloc]init];
    buddyMsg.buddyName = [Connection sharedConnection].currentChattingBuddy;
    buddyMsg.buddyID = [NSString stringWithFormat:@"%@%@",self.title,[Connection sharedConnection].idHostName];
    buddyMsg.messageType = @"normal";
    if(isMatch == NO){
        buddyMsg.messageArray = [[NSMutableArray alloc]init];
    }
    else{
        buddyMsg.messageArray = temp;
    }
    [buddyMsg.messageArray addObject:message];
    [[Connection sharedConnection].chatBuddyMessageArray addObject:buddyMsg];
    NSLog(@"Chatting type:%@",[Connection sharedConnection].chattingType);
    if([[Connection sharedConnection].chattingType isEqualToString:@"group"]){
        [[Connection sharedConnection]sendGroupMessageWithGroupName:self.title Message:textViewMessage.text];
    }
    else{
        [[Connection sharedConnection] sendMessage:textViewMessage.text ToUser:self.title];
    }
    [self createBubbleMessage:textViewMessage.text DisplayImage:myImage IsReceive:NO];
    */
}

- (void)keyboardWillShow{
    isKyeboardShow = YES;
    controlView.frame = CGRectMake(0, 200 - controlView.frame.size.height, 320, controlView.frame.size.height);
    bubbleScrollView.frame = CGRectMake(0, 0, 320, controlView.frame.origin.y-1);
    [self setBubbleScrollAnimation];
}

- (void)keyboardWillHide{
    isKyeboardShow = NO;
    controlView.frame = CGRectMake(0, 416-controlView.frame.size.height, 320, controlView.frame.size.height);
    bubbleScrollView.frame = CGRectMake(0, 0, 320, controlView.frame.origin.y-1);
    [self setBubbleScrollAnimation];
}

- (void)textViewDidChange:(UITextView *)textView{
    CGSize textViewSize = [textViewMessage.text sizeWithFont:[UIFont fontWithName:@"Times New Roman" size:18]];
    if(textViewMessage.frame.size.height <= 30){
        if(textViewSize.width >= 210){
            [self frameBigSize];
        }
    }
    else if(textViewSize.width > 30){
        if(textViewSize.width < 210){
            [self frameNormalSize];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Image loading here.
    myImage = [UIImage imageNamed:@"25X25.png"];
    
    controlView = [[UIView alloc] initWithFrame:CGRectMake(0,366, 320, 50)];
    controlView.backgroundColor = [UIColor grayColor];
    
    imageViewTextAndButton = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 232, 35)];
    imageViewTextAndButton.backgroundColor = [UIColor grayColor];
    imageViewTextAndButton.image = [[UIImage imageNamed:@"TEXTFRAME.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:15];
    
    textViewMessage = [[UITextView alloc]initWithFrame:CGRectMake(12, 10, 230, 30)];
    textViewMessage.text = @"";
    textViewMessage.editable = YES;
    textViewMessage.backgroundColor = [UIColor clearColor];
    textViewMessage.font = [UIFont fontWithName:@"Times New Roman" size:18];
    textViewMessage.delegate = self;
    
    buttonSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonSend.frame = CGRectMake(250, 12, 60, 30);
    [buttonSend setTitle:@"Send" forState:UIControlStateNormal];
    [buttonSend addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
    
    bubbleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 365)];
	bubbleScrollView.contentSize = CGSizeMake(320, 10);
    bubbleScrollView.alwaysBounceVertical = YES;
    bubbleScrollView.delegate = self;
    bubbleScrollView.backgroundColor = [UIColor colorWithRed:(140/255.0) green:(204.0/255.0) blue:(255.0/255.0) alpha:0.2];
	
    [self.view addSubview:bubbleScrollView];
    [controlView addSubview:imageViewTextAndButton];
    [controlView addSubview:buttonSend];
    [controlView addSubview:textViewMessage];
    [self.view addSubview:controlView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[Connection sharedConnection].currentChattingBuddy = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setBubbleScrollView:nil];
    [self setImageViewTextAndButton:nil];
    [self setControlView:nil];
    [self setTextViewMessage:nil];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
    [Connection sharedConnection].alertDelegate = self.view;
    [Connection sharedConnection].chatViewDelegate = self;
    NSString *chatBuddy = [Connection sharedConnection].currentChattingBuddy;
    [self setTitle:chatBuddy];
    myImage = [UIImage imageNamed:@"defaultPerson.png"];
    buddyImage = [UIImage imageNamed:@"defaultPerson.png"];
    NSData *photoData = [[Connection sharedConnection] setPhotoWithID:self.title andRoomType:@"single"];
    if(photoData != Nil){
        buddyImage = [UIImage imageWithData:photoData];
    }
    else{
        buddyImage = [UIImage imageNamed:@"defaultPerson.png"];
    }
    
    for(int i=0;i<[[Connection sharedConnection].chatBuddyMessageArray count];i++){
        BuddyMessage *buddyMsg = [[BuddyMessage alloc]init];
        buddyMsg = [[Connection sharedConnection].chatBuddyMessageArray objectAtIndex:i];
        if([chatBuddy isEqualToString:buddyMsg.buddyName]){
            Message *message = [[Message alloc]init];
            for(int j=0;j<[buddyMsg.messageArray count];j++){
                message = [buddyMsg.messageArray objectAtIndex:j];
                BOOL isReceive;
                UIImage *chatImage = [[UIImage alloc]init];
                if([message.type isEqualToString:@"receive"]){
                    isReceive = YES;
                    chatImage = buddyImage;
                }
                else{
                    chatImage = myImage;
                    isReceive = NO;
                }
                [self createBubbleMessage:message.messageBody DisplayImage:chatImage IsReceive:isReceive];
            }
        }
    }*/
}

@end
