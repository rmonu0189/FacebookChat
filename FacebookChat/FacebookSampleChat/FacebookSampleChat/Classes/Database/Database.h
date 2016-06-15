//
//  Database.h
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject
+ (Database *)sharedInstance;
- (void)storeMessage:(NSString *)message messageHeight:(CGFloat)height isReceive:(BOOL)receive UserID:(NSString *)userID;
- (NSMutableArray *)getMessageForUser:(NSString *)userID;
@end
