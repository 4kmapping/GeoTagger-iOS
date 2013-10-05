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
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.descInput)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}


 #pragma mark - Navigation
 
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if ([self.descInput.text length])
        {
            GTDataManager *dataManager = [GTDataManager getInstance];
            
            self.currLocation = [dataManager saveDesc:self.descInput.text
                          withLat:self.location.coordinate.latitude
                          withLon:self.location.coordinate.longitude
                  withCreatedTime:self.location.timestamp];
            
        }
        
    }
}
 


@end








