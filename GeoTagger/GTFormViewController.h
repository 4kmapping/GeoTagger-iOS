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
    <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    //UITextField *activeField;
    id activeField;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


# pragma mark - Ministry Type List
@property (strong, nonatomic) IBOutlet UISwitch *evanType;
@property (strong, nonatomic) IBOutlet UISwitch *trainType;
@property (strong, nonatomic) IBOutlet UISwitch *mercyType;


# pragma mark - Ministry Subtype List
@property (strong, nonatomic) IBOutlet UISwitch *youthType;
@property (strong, nonatomic) IBOutlet UISwitch *campusType;
@property (strong, nonatomic) IBOutlet UISwitch *indigenousType;
@property (strong, nonatomic) IBOutlet UISwitch *prisonType;
@property (strong, nonatomic) IBOutlet UISwitch *prostitutesType;
@property (strong, nonatomic) IBOutlet UISwitch *orphansType;
@property (strong, nonatomic) IBOutlet UISwitch *womenType;
@property (strong, nonatomic) IBOutlet UISwitch *urbanType;
@property (strong, nonatomic) IBOutlet UISwitch *hospitalType;
@property (strong, nonatomic) IBOutlet UISwitch *mediaType;
@property (strong, nonatomic) IBOutlet UISwitch *communityDevType;
@property (strong, nonatomic) IBOutlet UISwitch *bibleStudyType;
@property (strong, nonatomic) IBOutlet UISwitch *churchPlantingType;
@property (strong, nonatomic) IBOutlet UISwitch *artsType;
@property (strong, nonatomic) IBOutlet UISwitch *counselingType;
@property (strong, nonatomic) IBOutlet UISwitch *healthcareType;
@property (strong, nonatomic) IBOutlet UISwitch *constructionType;
@property (strong, nonatomic) IBOutlet UISwitch *researchType;


@property (strong, nonatomic) IBOutlet UITextView *descField;
@property (strong, nonatomic) IBOutlet UITextField *tagsField;

# pragma mark contact
@property (strong, nonatomic) IBOutlet UISwitch *contactConfirmed;
@property (strong, nonatomic) IBOutlet UITextField *contactEmail;
@property (strong, nonatomic) IBOutlet UITextField *contactPhone;
@property (strong, nonatomic) IBOutlet UITextField *contactWebsite;

@property (nonatomic, copy) CLLocation *location;

// Mode indicates the purpose of displaying a form.
// Values can be view-only (for already existing data).
@property BOOL editMode;

// For detail view, spectific existing data id that needs to be displayed.
@property (nonatomic, strong) NSManagedObject *locationToDisplay;


//- (IBAction)textFieldShouldReturn:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;





@end
