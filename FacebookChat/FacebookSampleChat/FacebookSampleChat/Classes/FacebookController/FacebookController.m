//
//  FacebookController.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "FacebookController.h"

@interface FacebookController ()
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) XMPPController *xmppController;
@end

@implementation FacebookController

SINGLETON_GCD(FacebookController);

- (Facebook *)facebook {
    if (!_facebook) {
        _facebook = [Facebook new];
    }
    return _facebook;
}

- (XMPPController *)xmppController {
    if (!_xmppController) {
        _xmppController = [XMPPController new];
    }
    return _xmppController;
}

@end
