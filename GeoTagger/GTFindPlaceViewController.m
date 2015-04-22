//
//  GTFindPlaceViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 4/21/15.
//  Copyright (c) 2015 msk. All rights reserved.
//

#import "GTFindPlaceViewController.h"
#import "GTDataManager.h"


@interface GTFindPlaceViewController ()

@property (strong, nonatomic) IBOutlet UITextField *placeField;
@property (strong, nonatomic) IBOutlet UITextField *countryField;

@end

@implementation GTFindPlaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)findPlace:(id)sender
{
    // Get place name and country code
    NSString *placeName = [self.placeField text];
    NSString *countryCode = [self.countryField text];
    
    // Check if place name is empty.
    if ([placeName length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing input"
                                                        message:@"You must type a place name to search"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Get a places list from Factual API
        GTDataManager *dataManager = [GTDataManager getInstance];
        NSMutableArray *responseArray = [dataManager getPlaceCandidateListWithPlaceName:placeName
                                                                countryName:countryCode];
        // NSLog(@"Factual API Reponse: %@", responseArray);
        
    }
        
    
    // Talk to a server to get a place candidates list
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
