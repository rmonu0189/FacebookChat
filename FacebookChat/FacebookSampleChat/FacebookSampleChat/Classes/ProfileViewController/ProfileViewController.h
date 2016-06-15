//
//  ProfileViewController.h
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookController.h"

@interface ProfileViewController : UIViewController<FacebookDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoverPic;
- (IBAction)clickedLogout:(id)sender;

@end
