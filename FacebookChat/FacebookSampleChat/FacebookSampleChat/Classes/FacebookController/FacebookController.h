//
//  FacebookController.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookUser.h"
#import "Facebook.h"
#import "XMPPController.h"

@interface FacebookController : NSObject
@property (readonly , nonatomic, strong) Facebook *facebook;
@property (readonly , nonatomic, strong) XMPPController *xmppController;

+ (FacebookController *)sharedInstance;

@end
