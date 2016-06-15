//
//  LoginViewController.m
//  FacebookSampleChat
//
//  Created by HSC on 5/30/14.
//  Copyright (c) 2014 hsc. All rights reserved.
//

#import "LoginViewController.h"
#import "FacebookController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [[[FacebookController sharedInstance] facebook] addFacebookLoginButton:self.view posX:50 posY:150];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
