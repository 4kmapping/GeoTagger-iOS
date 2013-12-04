//
//  GTSettingsViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSettingsViewController : UIViewController
{
}


@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *appkeyLabel;
@property (strong, nonatomic) IBOutlet UILabel *syncLabel;

@property (strong, nonatomic) NSMutableArray *dataToSync;
@property (strong, nonatomic) NSMutableArray *photoToSync;


- (IBAction)changeOfflinemode:(id)sender;
- (IBAction)syncAllData:(id)sender;

- (int) numDataToSync;


@end
