//
//  GTFormViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTFormViewController.h"
#import "GTData.h"
#import "GTDataManager.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface GTFormViewController ()

@end

@implementation GTFormViewController

/* SPECIFIED IN Canvas
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.scrollView setDelegate:self];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    // Set text view boundary color with a line.
    self.descField.layer.borderWidth = 0.0f;
    self.descField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.tagsField.layer.borderWidth = 0.0f;
    self.tagsField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // Set delegate
    [self.descField setDelegate:self];
    [self.tagsField setDelegate:self];

    // Check if a mobile device has a camera capability and if not, inform a user with a warning.
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                               message:@"Your device does not have a camera"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        
        [myAlertView show];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
    To hide keyboard when a return key in text field is pressed
 */
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    NSLog(@"return key...");
    if (sender == self.tagsField)
    {
        [sender resignFirstResponder];
    }
    
    [sender resignFirstResponder];
    
    return YES;
}

/*
    To hide keyboard when a return key in text area is pressed
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}


- (IBAction)cancel:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)save:(id)sender
{
    NSLog(@"User hit the save button.");
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
    
    
    // Store a photo
    if(self.imageView.image)
    {
        
        // Save the selected (taken) image to a file and folder
        NSData *pngData = UIImagePNGRepresentation(self.imageView.image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        
        // Set folder path for photo. If no photo folder existing yet, create one.
        NSString *folderPath = [documentsPath stringByAppendingPathComponent:@"/photo"]; //Add the file name
        NSError *error = [[NSError alloc] init];
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:&error]; //Create folder
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:@"imagefile.png"];
        
        [pngData writeToFile:filePath atomically:YES]; //Write the file
   
    }
    
}


 #pragma mark - Navigation
 
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if ([self.descField.text length])
        {
            GTDataManager *dataManager = [GTDataManager getInstance];
            
            self.currLocation = [dataManager saveDesc:self.descField.text
                          withLat:self.location.coordinate.latitude
                          withLon:self.location.coordinate.longitude
                  withCreatedTime:self.location.timestamp];
            
        }
        
    }
}
 
#pragma mark - Photo

- (IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //picker.showsCameraControls = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.imageView setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}





@end





















