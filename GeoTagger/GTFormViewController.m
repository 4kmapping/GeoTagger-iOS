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
#import <CoreLocation/CLLocation.h>

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    
    [self.scrollView setDelegate:self];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    // Set text view boundary color with a line.
    self.descField.layer.borderWidth = 0.0f;
    self.descField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.tagsField.layer.borderWidth = 0.0f;
    self.tagsField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // Set delegate for text fields
    [self.descField setDelegate:self];
    [self.tagsField setDelegate:self];
    [self.contactEmail setDelegate:self];
    [self.contactPhone setDelegate:self];
    [self.contactWebsite setDelegate:self];
    

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


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Keyboard Interaction 

// If Keyboard hides a text field, the text field will move up above keyboard
// *******

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    UITextView *textview = (UITextView *)activeField;
    if([textview isEqual:self.descField])
    {
        if (!CGRectContainsPoint(aRect, textview.frame.origin) )
        {
            [self.scrollView scrollRectToVisible:textview.frame animated:YES];
        }
    }
    else
    {
        UITextField *textfield = (UITextField *)activeField;
        if (!CGRectContainsPoint(aRect, textfield.frame.origin) )
        {
            [self.scrollView scrollRectToVisible:textfield.frame animated:YES];
        }
        
    }

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    activeField = nil;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


// End of Keyboard Interaction


/*
    To hide keyboard when a return key in text field is pressed
 */
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
//    if (sender == self.tagsField | sender == self.contactEmail | sender == self.)
//    {
//        [sender resignFirstResponder];
//    }
    NSLog(@"return key hit");
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
    double timestamp = [[NSDate date] timeIntervalSince1970];
    
    
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
    
    // Create a new location object to save
    //
    GTDataManager *dataManager = [GTDataManager getInstance];
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    // Create a new managed object
    NSManagedObject *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                                 inManagedObjectContext:context];
    
    // Save location info.
    CLLocationCoordinate2D coordinate = [[self location] coordinate];
    
    NSLog(@"latitude: %f", coordinate.latitude);
    
    [newLocation setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
    [newLocation setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
    
    // Save timestamp
    [newLocation setValue:[NSNumber numberWithDouble:timestamp] forKey:@"created"];
    
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
        NSString *photoid = [NSString stringWithFormat:@"%f.png", timestamp];
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:photoid];
        
        [pngData writeToFile:filePath atomically:YES]; //Write the file
        
        [newLocation setValue:photoid forKey:@"photoId"];
   
    }

    
    // Save checklist and other text fields.
    
    [newLocation setValue:[NSNumber numberWithBool:[[self evanType] isOn]] forKey:@"evanType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self trainType] isOn]] forKey:@"trainType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self mercyType] isOn]] forKey:@"mercyType"];
    
    [newLocation setValue:[NSNumber numberWithBool:[[self youthType] isOn]] forKey:@"youthType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self campusType] isOn]] forKey:@"campusType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self indigenousType] isOn]] forKey:@"indigenousType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self prisonType] isOn]] forKey:@"prisonType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self prostitutesType] isOn]] forKey:@"prostitutesType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self orphansType] isOn]] forKey:@"orphansType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self womenType] isOn]] forKey:@"womenType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self urbanType] isOn]] forKey:@"urbanType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self hospitalType] isOn]] forKey:@"hospitalType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self mediaType] isOn]] forKey:@"mediaType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self communityDevType] isOn]] forKey:@"communityDevType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self bibleStudyType] isOn]] forKey:@"bibleStudyType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self churchPlantingType] isOn]] forKey:@"churchPlantingType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self artsType] isOn]] forKey:@"artsType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self counselingType] isOn]] forKey:@"counselingType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self healthcareType] isOn]] forKey:@"healthcareType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self constructionType] isOn]] forKey:@"constructionType"];
    [newLocation setValue:[NSNumber numberWithBool:[[self researchType] isOn]] forKey:@"researchType"];
    
    [newLocation setValue:[[self descField] text] forKey:@"desc"];
    [newLocation setValue:[[self tagsField] text] forKey:@"tags"];
    
    
    
    // Save the object to persistent store.
    //
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
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





















