//
//  FacebookUser.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookUser : NSObject
{
    NSString *firstName,*lastName,*fullName,*profileID;
    id<FBGraphUser> loggedInUser;
    FBProfilePictureView *profilePic;
    UIImage *coverImage;
}
@property (nonatomic, retain) UIImage *coverImage;
@property (nonatomic, copy) NSString *firstName,*lastName,*fullName,*profileID;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (strong, nonatomic) FBProfilePictureView *profilePic;
@end
