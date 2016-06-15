//
//  XMPPController.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "XMPPController.h"
#import "Database.h"
#import "XMLReader.h"

@implementation XMPPController
@synthesize onlineFacebookFriends;

- (id)init
{
    if (self = [super init]) {
        self.onlineFacebookFriends = [[NSMutableArray alloc] init];
        _xmppStream = [[XMPPStream alloc] initWithFacebookAppId:FACEBOOK_APP_ID];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

#pragma mark XMPPStream Delegate methods
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    if (![self.xmppStream isSecure])
    {
        NSLog(@"XMPP STARTTLS...");
        NSError *error = nil;
        BOOL result = [self.xmppStream secureConnection:&error];
        if (result == NO)
        {
            NSLog(@"XMPP STARTTLS failed");
        }
    }
    else
    {
        NSLog(@"XMPP X-FACEBOOK-PLATFORM SASL...");
        NSError *error = nil;
        BOOL result = [self.xmppStream authenticateWithFacebookAccessToken:[FBSession activeSession].accessTokenData.accessToken error:&error];
        if (result == NO)
        {
            NSLog(@"XMPP authentication failed");
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	
	if (NO)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (NO)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		NSString *expectedCertName = [sender hostName];
		if (expectedCertName == nil)
		{
			expectedCertName = [[sender myJID] domain];
		}
        
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    NSLog(@"XMPP STARTTLS...");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"XMPP authenticated");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"XMPP authentication failed");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"XMPP disconnected");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"XMPP didReceiveMessage");
    [self parseMessage:[XMLReader dictionaryForXMLString:[NSString stringWithFormat:@"%@",message] error:nil]];
}

- (void)parseMessage:(NSDictionary *)messageDict{
    if (messageDict!=nil) {
        id message = [messageDict valueForKey:@"message"];
        if (message!=nil) {
            NSString *from = [message valueForKey:@"from"];
            NSString *msg = [message valueForKey:@"body"];
            if ([msg length]>0) {
                int numberOfLines;
                CGSize size = [msg sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:13.0f] }];
                if (size.width >= 260.0f) {
                     numberOfLines = ((int)size.width/(260-25))+1;
                }
                [[Database sharedInstance] storeMessage:msg messageHeight:(13*numberOfLines)+50 isReceive:YES UserID:from];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookReceiveMessageNotification object:message];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookUserTypingNotification object:message];
            }
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *buddyPresence = [presence type];  //available/unavailable/subscribe
    //NSString *buddyID = [[[presence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0];
	//NSString *myUserName = [[sender myJID] user];
	NSString *buddyName = [[presence from] user];
    //NSString *buddyType = [[[[buddyID componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
    if ([buddyPresence isEqualToString:@"available"]) {
        NSLog(@"Receive Available presence : %@",buddyName);
        BOOL isMatch = NO;
        for (NSString *friendID in self.onlineFacebookFriends) {
                if ([friendID isEqualToString:buddyName]) {
                    isMatch = YES;
                    break;
                }
        }
        if (isMatch==NO) {
            [self.onlineFacebookFriends addObject:buddyName];
        }
    }
    else if([buddyPresence isEqualToString:@"unavailable"]){
        NSLog(@"Receive Unavailable presence : %@",buddyName);
        BOOL isMatch = NO;
        int index = -1;
        for (NSString *friendID in self.onlineFacebookFriends) {
            index++;
            if ([friendID isEqualToString:buddyName]) {
                isMatch = YES;
                break;
            }
        }
        if (isMatch==YES) {
            [self.onlineFacebookFriends removeObjectAtIndex:index];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookReceivePresenceNotification object:buddyName];
}

#pragma mark send message to Facebook.
- (void)sendMessageToFacebook:(NSString*)textMessage withFriendFacebookID:(NSString*)friendID
{
    if([textMessage length] > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:textMessage];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        //[message addAttributeWithName:@"xmlns" stringValue:@"http://www.facebook.com/xmpp/messages"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"-%@@chat.facebook.com",friendID]];
        [message addChild:body];
        [self.xmppStream sendElement:message];
    }
}

@end
