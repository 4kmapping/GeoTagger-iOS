//
//  GTFindPlaceViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 4/21/15.
//  Copyright (c) 2015 msk. All rights reserved.
//

#import "GTFindPlaceViewController.h"
#import "GTDataManager.h"
#import "PlaceCandidate.h"
#import "GeoTaggerViewController.h"


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
        placeCandidates = [dataManager getPlaceCandidateListWithPlaceName:placeName
                                                                countryName:countryCode];
        //NSLog(@"Factual API Reponse: %@", responseArray);
        
        [self.placeCandidatesTable reloadData];
        
    }
    
    // Talk to a server to get a place candidates list
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [placeCandidates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeCell"];
    
    
    // If place search has not been made yet, show empty cell
    if (placeCandidates != nil)
    {
        PlaceCandidate *curr = placeCandidates[[indexPath row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.text = [curr contextname];
    }
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"selectedPlaceSegue" sender:tableView];
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowIndex = [indexPath row];
    PlaceCandidate *selectedOne = [placeCandidates objectAtIndex:rowIndex];
    [self.gtvController setSelectedPlace:selectedOne];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"selectedPlaceSegue"])
    {
        GeoTaggerViewController *destination = [segue destinationViewController];
        // Get a selected place info
        NSInteger rowIndex = [[self.placeCandidatesTable indexPathForSelectedRow] row];
        PlaceCandidate *selectedOne = [placeCandidates objectAtIndex:rowIndex];
        [destination setSelectedPlace: selectedOne];
        
        NSLog(@"inside of GTFindPlaceViewController: prepareForSegue");
    }
    
}
*/

@end
