//
//  ProfileViewController.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FacebookController sharedInstance] facebook].delegate = self;
    
    self.lblFullName.text = [[FacebookController sharedInstance] facebook].currentUser.fullName;
    FBProfilePictureView *profilePic = [[FBProfilePictureView alloc]initWithFrame:CGRectMake(15, 187, 60, 60)];
    profilePic.profileID = [[FacebookController sharedInstance] facebook].currentUser.profileID;
    profilePic.layer.masksToBounds = YES;
    profilePic.layer.cornerRadius = 5.0f;
    [self.view addSubview:profilePic];
    // Do any additional setup after loading the view from its nib.
}

- (void)facebookCoverPhoto:(UIImage *)coverPhoto{
    self.imgCoverPic.image = coverPhoto;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedLogout:(id)sender {
    [[[FacebookController sharedInstance] facebook] facebookLogout];
}
@end
