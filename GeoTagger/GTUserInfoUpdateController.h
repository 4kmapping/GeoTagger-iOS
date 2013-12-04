//
//  GTUserInfoUpdateController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 12/3/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTUserInfoUpdateController : UIViewController <UITextFieldDelegate>



@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *appkeyField;
- (IBAction)updateInfo:(UIBarButtonItem *)sender;

@end
