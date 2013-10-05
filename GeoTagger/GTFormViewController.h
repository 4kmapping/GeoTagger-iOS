//
//  GTFormViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class GTData;

@interface GTFormViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *descInput;
@property (strong, nonatomic) GTData *gtData;
@property (strong, nonatomic) NSManagedObject *currLocation;
@property (nonatomic, copy) CLLocation *location;


@end
