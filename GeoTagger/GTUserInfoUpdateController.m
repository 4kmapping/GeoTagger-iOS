//
//  GTUserInfoUpdateController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 12/3/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTUserInfoUpdateController.h"
#import "GTSettings.h"

@interface GTUserInfoUpdateController ()

@end

@implementation GTUserInfoUpdateController

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
    
    [self.usernameField setDelegate:self];
    [self.appkeyField setDelegate:self];
    
	// Do any additional setup after loading the view.
    GTSettings *settings = [GTSettings getInstance];
    
    // Initialize fields with previously stored values
    self.usernameField.text = settings.username;
    self.appkeyField.text = settings.appkey;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateInfo:(UIBarButtonItem *)sender
{
    NSLog(@"updateInfo clicked");
    GTSettings *settings = [GTSettings getInstance];
    
    [settings setUsername:[[self usernameField] text]];
    [settings setAppkey:[[self appkeyField] text]];
    
    [settings save];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
    
    return YES;
}





@end
