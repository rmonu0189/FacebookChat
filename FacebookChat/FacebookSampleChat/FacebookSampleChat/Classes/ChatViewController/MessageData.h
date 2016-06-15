//
//  MessageData.h
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject
{
    NSString *message;
    CGFloat height;
    BOOL isReceive;
}
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isReceive;
@end
