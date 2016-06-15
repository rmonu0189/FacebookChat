//
//  Facebook.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "Facebook.h"
#import "FacebookController.h"
#import "FriendData.h"

@implementation Facebook
@synthesize loginview;
@synthesize delegate;
@synthesize facebookFriends,onlineFacebookFriends;

- (id)init{
    self = [super init];
    if (self) {
        self.currentUser = [[FacebookUser alloc] init];
        self.loginview = [[FBLoginView alloc] init];
        //self.loginview.readPermissions = [NSArray arrayWithObjects:@"user_birthday",@"friends_birthday", nil];
        self.loginview.delegate = self;
        self.queue = [[NSOperationQueue alloc] init];
        self.facebookFriends = [[NSMutableArray alloc] init];
        self.onlineFacebookFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addFacebookLoginButton:(UIView*)aView posX:(CGFloat)x posY:(CGFloat)y{
    self.loginview.frame = CGRectMake(x, y, 150, 40);
    [aView addSubview:self.loginview];
    [self.loginview sizeToFit];
}

- (void)getFacebookCoverPhoto{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=cover",self.currentUser.profileID]]] queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error = nil;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"%@",jsonResponse);
            if (jsonResponse) {
                id cover = [jsonResponse objectForKey:@"cover"];
                if (cover) {
                    NSString *source = (NSString*)[cover objectForKey:@"source"];
                    if ([source length]>0) {
                        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:source]
                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                timeoutInterval:REQUEST_TIME_OUT];
                        [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                            if (!connectionError) {
                                self.currentUser.coverImage = [UIImage imageWithData:data];
                                if ([self.delegate respondsToSelector:@selector(facebookCoverPhoto:)]) {
                                    [self.delegate facebookCoverPhoto:self.currentUser.coverImage];
                                }
                            }
                        }];
                    }
                }
            }
        }
    }];
}

- (void)fetchFacebookFriends{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?fields=picture,email,name,birthday&access_token=%@",[FBSession activeSession].accessTokenData.accessToken]]] queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            [self parseFriendsList:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
        }
        else{
            NSLog(@"%@",connectionError);
        }
    }];
}

- (void)parseFriendsList:(NSDictionary*)jsonDict{
    @synchronized(self){
        [self.facebookFriends removeAllObjects];
        if (jsonDict!=nil) {
            //NSLog(@"%@",jsonDict);
            id data = [jsonDict valueForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (int i=0; i<[data count]; i++) {
                    FriendData *friend = [[FriendData alloc] init];
                    friend.friendID = (NSString*)[[data objectAtIndex:i] valueForKey:@"id"];
                    friend.name = (NSString*)[[data objectAtIndex:i] valueForKey:@"name"];
                    
                    id picture = [[data objectAtIndex:i] valueForKey:@"picture"];
                    if (picture!=nil) {
                        id pictureData = [picture valueForKey:@"data"];
                        if (pictureData!=nil) {
                            friend.imageURL = [pictureData valueForKey:@"url"];
                        }
                    }
                    friend.presence = [NSString stringWithFormat:@"%d",UNAVAILABLE];
                    [self.facebookFriends addObject:friend];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookReceiveFriendsList object:nil];
            }
        }
    }
}

- (void)facebookLogout{
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [self.facebookFriends removeAllObjects];
    [[FacebookController sharedInstance].xmppController.onlineFacebookFriends removeAllObjects];
}

#pragma mark - FBLoginViewDelegate methods
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    NSLog(@"Logged in success. Access Token : %@",[FBSession activeSession].accessTokenData.accessToken);
    NSError *error = nil;
    [self.loginview removeFromSuperview];
    [[[FacebookController sharedInstance] xmppController].xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    [[AppDelegate sharedInstance] openHomePage];
    [self getFacebookCoverPhoto];
    [self fetchFacebookFriends];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"User info.");
    self.currentUser.loggedInUser = user;
    self.currentUser.firstName = user.first_name;
    self.currentUser.lastName = user.last_name;
    self.currentUser.fullName = [NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
    self.currentUser.profileID = user.objectID;
    self.currentUser.profilePic.profileID = user.objectID;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"You are not Login, Please login first.");
    self.currentUser.loggedInUser = nil;
    self.currentUser.firstName = nil;
    self.currentUser.lastName = nil;
    self.currentUser.profileID = nil;
    self.currentUser.profilePic.profileID = nil;
    [[[FacebookController sharedInstance] xmppController].xmppStream disconnect];
    [[AppDelegate sharedInstance] openLoginView];
}

@end
