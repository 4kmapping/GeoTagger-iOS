//
//  GeoTaggerViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/26/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GeoTaggerViewController.h"
#import "GTMapPoint.h"
#import "GTFormViewController.h"
#import "GTDataController.h"
#import "GTDetailViewController.h"
#import "GTData.h"

@interface GeoTaggerViewController ()

@end

@implementation GeoTaggerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // ***
    // Set a map type to Satellite view.
    //[worldView setMapType:MKMapTypeSatellite];
    [worldView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// When using Storyboard, use awakeFromNib in the main view controller for initialization.
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
        
        self.dataController = [[GTDataController alloc] init];
    }

}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
/*
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManager will return the last found location of the device first,
    // you don't want that data in this case. If this location was created more
    // than 3 minutes ago, ignore it
    if (t< -180)
    {
        // This is cached data, I don't want it
        return;
    }
    
    [self foundLocation:newLocation];
*/
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [[userLocation location] coordinate];
    // Using a MapKit function
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 3000,3000);
    
    [worldView setRegion:region animated:YES];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
}

/* TODO DELETE LATER: now for reference.
 ---------------------------------------
- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Create an instance of GTMapPoint with the current location
    GTMapPoint *mp = [[GTMapPoint alloc] initWithCoordinate:coord
                                            title:[locationTitleField text]];
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);
    [worldView setRegion:region animated:YES];
    
    // Reset UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];

}
*/

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {

        GTFormViewController *formController = [segue sourceViewController];
        NSManagedObject *currLocation = formController.currLocation;
        if (currLocation)
        {
            // Create an annotation on a map.
            CLLocationCoordinate2D point= CLLocationCoordinate2DMake([[currLocation valueForKey:@"latitude"] doubleValue],[[currLocation valueForKey:@"longitude"] doubleValue]);

            GTMapPoint *mp = [[GTMapPoint alloc] initWithCoordinate:point
                                                              title:[currLocation valueForKey:@"desc"]
                                                           indexNum:1];
            // Add the annotation to the map
            [worldView addAnnotation:mp];
            // Zoom the region to this location
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point, 3000, 3000);
            [worldView setRegion:region animated:YES];
            // Start updating location
            [locationManager startUpdatingLocation];
        }
        
        
    }
}




- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddDataButton"])
    {
        // Stop updating location
        [locationManager stopUpdatingLocation];
        
        // Pass location info to GTFormViewcontroller
        // ***
        // Get current location and send it with segue
        UINavigationController *navController = [segue destinationViewController];
        GTFormViewController *formController = [navController.viewControllers objectAtIndex:0];
        // Register location into destination view controller
        
        //CLLocation *location = [[worldView userLocation] location];
        CLLocation *currLoc = [locationManager location];
        
        if (!currLoc)
        {
            currLoc = [[CLLocation alloc] initWithLatitude:20.22 longitude:120.33];
        }
        formController.location = currLoc;
    }
    
    if ([[segue identifier] isEqualToString:@"DetailViewSegue"])
    {
        GTDetailViewController *detailController = [segue destinationViewController];
        GTData *currData = [self.dataController.dataCollection objectAtIndex:self.currDataIndex];
        [detailController setData:currData];
    }
}


/*
    For showing annotations.

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView *aView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:@"MyAnnotatonView"]];
    aView.centerOffset = CGPointMake(10,-20);
}
*/



- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[GTMapPoint class]])
    {
        // Set the annotation as the current data.
        [self setCurrDataIndex:[(GTMapPoint *)annotation indexNum]];
        
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView
            dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotation"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Go to detail view
    /*
    ViewController *detailViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
    NSLog(@"detail view button was hit.");
    
    [self performSegueWithIdentifier:@"DetailViewSegue" sender:self];
}




@end


















