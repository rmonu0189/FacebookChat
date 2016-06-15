//
//  Facebook.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookUser.h"

@protocol FacebookDelegate <NSObject>

- (void)facebookCoverPhoto:(UIImage*)coverPhoto;

@end

@interface Facebook : NSObject<FBLoginViewDelegate>
{
    id<FacebookDelegate> delegate;
    NSMutableArray *facebookFriends,*onlineFacebookFriends;
}
@property (nonatomic, retain) NSMutableArray *facebookFriends,*onlineFacebookFriends;
@property id<FacebookDelegate> delegate;
@property (nonatomic, retain) FacebookUser *currentUser;
@property (nonatomic, retain) FBLoginView *loginview;
@property (nonatomic, retain) NSOperationQueue *queue;
- (void)addFacebookLoginButton:(UIView*)aView posX:(CGFloat)x posY:(CGFloat)y;
- (void)facebookLogout;
@end
