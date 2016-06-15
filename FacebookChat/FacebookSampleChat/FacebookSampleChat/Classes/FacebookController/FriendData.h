//
//  FriendData.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendData : NSObject
{
    NSString *friendID,*name,*imageURL,*presence;
}
@property (nonatomic, copy) NSString *friendID,*name,*imageURL,*presence;
@end
