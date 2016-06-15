//
//  XMPPController.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import <FacebookSDK/FacebookSDK.h>

@interface XMPPController : NSObject
{
    NSMutableArray *onlineFacebookFriends;
}
@property (nonatomic, retain) NSMutableArray *onlineFacebookFriends;
@property (readonly, nonatomic, strong) XMPPStream *xmppStream;
- (void)sendMessageToFacebook:(NSString*)textMessage withFriendFacebookID:(NSString*)friendID;
@end
