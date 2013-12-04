//
//  GTSettingsViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTSettingsViewController.h"
#import "GTSettings.h"

@interface GTSettingsViewController ()

@end

@implementation GTSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
	// Do any additional setup after loading the view.
    GTSettings *settings = [GTSettings getInstance];
    
    // Initialize fields with previously stored values
    self.usernameLabel.text = settings.username;
    self.appkeyLabel.text = settings.appkey;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Will refresh this view everytime it shows up.
    [super viewWillAppear:animated];
    [self viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeOfflinemode:(id)sender
{
    
    UISwitch *offline = ((UISwitch *)sender);
    
    GTSettings *settings = [GTSettings getInstance];
    settings.isOffline = [offline isOn];
    
    NSLog(@"Now offline mode is %d", settings.isOffline);
    
}




@end
