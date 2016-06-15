//
//  Database.m
//  FacebookSampleChat
//
//  Created by HSC on 6/3/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "Database.h"
#import "MessageData.h"

@implementation Database

SINGLETON_GCD(Database);

- (void)storeMessage:(NSString *)message messageHeight:(CGFloat)height isReceive:(BOOL)receive UserID:(NSString *)userID{
    AppDelegate *appDelegate = [AppDelegate sharedInstance];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    [newEmployee setValue: message forKey:@"message"];
    [newEmployee setValue:[NSString stringWithFormat:@"%d",receive] forKey:@"isReceive"];
    [newEmployee setValue:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
    [newEmployee setValue:userID forKey:@"userID"];
    NSError *error;
    [context save:&error];
}

- (NSMutableArray *)getMessageForUser:(NSString *)userID{
    NSMutableArray *arrMessage = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = [AppDelegate sharedInstance];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSString *uID = [NSString stringWithFormat:@"-%@@chat.facebook.com",userID];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(userID == %@)",uID];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] > 0) {
        for (NSManagedObject *matches in objects) {
            MessageData *data = [[MessageData alloc] init];
            data.message = [matches valueForKey:@"message"];
            data.isReceive = [[matches valueForKey:@"isReceive"] boolValue];
            data.height = [[matches valueForKey:@"height"] floatValue];
            NSString *userID = [matches valueForKey:@"userID"];
            [arrMessage addObject:data];
        }
    }
    return [arrMessage mutableCopy];
}

@end
