//
//  GTSettingsViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSettingsViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *hostName;


- (IBAction)changeOfflinemode:(id)sender;



@end
