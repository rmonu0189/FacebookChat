//
//  ConfigManager.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)sharedInstance {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif

#define FACEBOOK_APP_ID @"124242144347927"

#define kFacebookReceiveMessageNotification @"FacebookReceiveMessageNotification"
#define kFacebookReceivePresenceNotification @"FacebookReceivePresenceNotification"
#define kFacebookReceiveFriendsList @"FacebookReceiveFriendsList"
#define kFacebookUserTypingNotification @"FacebookUserTypingNotification"

typedef enum _PresenceType
{
    UNAVAILABLE = 0,
    AVAILABLE,
    UNKNOWN
} PresenceType;

// define cash size on disk

#define cacheSizeMemory   10*1024*1024
#define cacheSizeDisk     10*1024*1024


// Get current size of folder

inline static unsigned long long int folderSize(NSString *folderPath)
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    return fileSize;
}


#define FIRST_DESCRIPTOR [[NSSortDescriptor alloc] initWithKey:@"presence" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]

#define SECOND_DESCRIPTOR [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]

#define REQUEST_TIME_OUT 20.0


#define minBubbleWidth 30.0f
#define maxBubbleWidth 260.0f


