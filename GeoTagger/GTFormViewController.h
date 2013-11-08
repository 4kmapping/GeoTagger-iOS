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

@interface GTFormViewController : UIViewController
    <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UISwitch *evanType;
@property (strong, nonatomic) IBOutlet UISwitch *trainType;
@property (strong, nonatomic) IBOutlet UISwitch *mercyType;
@property (strong, nonatomic) IBOutlet UITextView *descField;
@property (strong, nonatomic) IBOutlet UITextField *tagsField;

@property (strong, nonatomic) GTData *gtData;
@property (strong, nonatomic) NSManagedObject *currLocation;
@property (nonatomic, copy) CLLocation *location;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;


@end
