//
//  FriendData.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "FriendData.h"

@implementation FriendData
@synthesize name,friendID,imageURL,presence;

- (id)copyWithZone:(NSZone *)zone{
    FriendData *data = [[FriendData allocWithZone:zone] init];
    data.name = [self.name copy];
    data.friendID = [self.friendID copy];
    data.imageURL = [self.imageURL copy];
    data.presence = [self.presence copy];
    return data;
}

@end
