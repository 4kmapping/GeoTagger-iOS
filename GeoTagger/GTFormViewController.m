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


- (void)viewDidLoad
{
    [super viewDidLoad];

    
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
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && self.editMode)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                               message:@"Your device does not have a camera"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        
        [myAlertView show];
        
    }
    
    
    // Loading text information and switch values for displaying an existing data
    if ([self locationToDisplay] != NULL)
    {
        
        [self.evanType setOn:[[[self locationToDisplay] valueForKey:@"evanType"] boolValue]];
        [self.evanType setEnabled:self.editMode] ;
        
        [self.trainType setOn:[[[self locationToDisplay] valueForKey:@"trainType"] boolValue]];
        [self.trainType setEnabled:self.editMode] ;
        
        [self.mercyType setOn:[[[self locationToDisplay] valueForKey:@"mercyType"] boolValue]];
        [self.mercyType setEnabled:self.editMode] ;

        
        [self.youthType setOn:[[[self locationToDisplay] valueForKey:@"youthType"] boolValue]];
        [self.youthType setEnabled:self.editMode];
        
        [self.campusType setOn:[[[self locationToDisplay] valueForKey:@"campusType"] boolValue]];
        [self.campusType setEnabled:self.editMode];
        
        [self.indigenousType setOn:[[[self locationToDisplay] valueForKey:@"indigenousType"] boolValue]];
        [self.indigenousType setEnabled:self.editMode];
    
        [self.prisonType setOn:[[[self locationToDisplay] valueForKey:@"prisonType"] boolValue]];
        [self.prisonType setEnabled:self.editMode];
        
        [self.prostitutesType setOn:[[[self locationToDisplay] valueForKey:@"prostitutesType"] boolValue]];
        [self.prostitutesType setEnabled:self.editMode];
        
        [self.orphansType setOn:[[[self locationToDisplay] valueForKey:@"orphansType"] boolValue]];
        [self.orphansType setEnabled:self.editMode];
        
        [self.womenType setOn:[[[self locationToDisplay] valueForKey:@"womenType"] boolValue]];
        [self.womenType setEnabled:self.editMode];
        
        [self.urbanType setOn:[[[self locationToDisplay] valueForKey:@"urbanType"] boolValue]];
        [self.urbanType setEnabled:self.editMode];
        
        [self.hospitalType setOn:[[[self locationToDisplay] valueForKey:@"hospitalType"] boolValue]];
        [self.hospitalType setEnabled:self.editMode];

        [self.mediaType setOn:[[[self locationToDisplay] valueForKey:@"mediaType"] boolValue]];
        [self.mediaType setEnabled:self.editMode];
        
        [self.communityDevType setOn:[[[self locationToDisplay] valueForKey:@"communityDevType"] boolValue]];
        [self.communityDevType setEnabled:self.editMode];
        
        [self.bibleStudyType setOn:[[[self locationToDisplay] valueForKey:@"bibleStudyType"] boolValue]];
        [self.bibleStudyType setEnabled:self.editMode];
        
        [self.churchPlantingType setOn:[[[self locationToDisplay] valueForKey:@"churchPlantingType"] boolValue]];
        [self.churchPlantingType setEnabled:self.editMode];
        
        [self.artsType setOn:[[[self locationToDisplay] valueForKey:@"artsType"] boolValue]];
        [self.artsType setEnabled:self.editMode];
        
        [self.counselingType setOn:[[[self locationToDisplay] valueForKey:@"counselingType"] boolValue]];
        [self.counselingType setEnabled:self.editMode];
        
        [self.healthcareType setOn:[[[self locationToDisplay] valueForKey:@"healthcareType"] boolValue]];
        [self.healthcareType setEnabled:self.editMode];
        
        [self.constructionType setOn:[[[self locationToDisplay] valueForKey:@"constructionType"] boolValue]];
        [self.constructionType setEnabled:self.editMode];
        
        [self.researchType setOn:[[[self locationToDisplay] valueForKey:@"researchType"] boolValue]];
        [self.researchType setEnabled:self.editMode];
        
        [self.descField setText:[[self locationToDisplay] valueForKey:@"desc"]];
        [self.descField setEditable:self.editMode];
        
        [self.tagsField setText:[[self locationToDisplay] valueForKey:@"tags"]];

        
        [self.contactConfirmed setOn:[[[self locationToDisplay] valueForKey:@"contactConfirmed"] boolValue]];
        [self.contactConfirmed setEnabled:self.editMode];
        
        [self.contactEmail setText:[[self locationToDisplay] valueForKey:@"contactEmail"]];
        [self.contactWebsite setText:[[self locationToDisplay] valueForKey:@"contactWebsite"]];
        [self.contactPhone setText:[[self locationToDisplay] valueForKey:@"contactPhone"]];

        // Load saved photo to display
        NSString *photoid = [[self locationToDisplay] valueForKey:@"photoId"];
        
        if([photoid length] > 0)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            // Set folder path for photo. If no photo folder existing yet, create one.
            NSString *folderPath = [documentsPath stringByAppendingPathComponent:@"/photo"]; //Add the file name
            NSString *filePath = [folderPath stringByAppendingPathComponent:photoid];
            
            NSLog(@"image file: %@", filePath);
            
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            [self.imageView setImage:img];
            
        }
    
        // Hide UIToolBar from UI
        //
        
        // First get the height of toolbar
        int toolbarHeight = 0;
        
        for ( id view in self.view.subviews)
        {
            if ([((UIView *)view).restorationIdentifier isEqualToString:@"FormToolbar"] )
            {
                UIToolbar *toolbar = (UIToolbar *) view;
                toolbarHeight = toolbar.frame.size.height;
                [toolbar removeFromSuperview];
                
                //NSLog(@"Toolbar height: %d", toolbarHeight);
            }
        }
        
        // Increase scroll view by height of toolbar.
        for ( id view in self.view.subviews)
        {

            if ([((UIView *)view).restorationIdentifier isEqualToString:@"FormScrollview"])
            {
                // increase scrollview height to cover hiden UIToolbar
                
                UIScrollView *scrollView = (UIScrollView *)view;
                
                CGSize oldSize = [scrollView contentSize];
                CGSize newSize = CGSizeMake(oldSize.width, oldSize.height + 44.0);
                [scrollView setContentSize:newSize];
                
                // NSLog(@"Second, toolbar height: %d", toolbarHeight);
                
                // Increase twice of toolbar height due to head toolbar and foot toolbar.
                scrollView.frame = CGRectMake(0,0, scrollView.frame.size.width,
                                              scrollView.frame.size.height + 2 *toolbarHeight);
            }
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return self.editMode;
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
    
    [newLocation setValue:[NSNumber numberWithBool:[[self contactConfirmed] isOn]] forKey:@"contactConfirmed"];
    [newLocation setValue:[[self contactEmail] text] forKey:@"contactEmail"];
    [newLocation setValue:[[self contactPhone] text] forKey:@"contactPhone"];
    [newLocation setValue:[[self contactWebsite] text] forKey:@"contactWebsite"];
    
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
/*        if ([self.descField.text length])
        {
            GTDataManager *dataManager = [GTDataManager getInstance];
            
            self.currLocation = [dataManager saveDesc:self.descField.text
                          withLat:self.location.coordinate.latitude
                          withLon:self.location.coordinate.longitude
                  withCreatedTime:self.location.timestamp];
            
        }
*/        
    }
}
 
#pragma mark - Photo

- (IBAction)takePhoto:(UIButton *)sender
{
    if (self.editMode)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //picker.showsCameraControls = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}


- (IBAction)selectPhoto:(UIButton *)sender
{
    if (self.editMode)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
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





















