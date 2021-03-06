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
#import "GTFindPlaceViewController.h"
#import "GTDataManager.h"
#import "GTSettings.h"

// To check if the current device is after iOS7
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface GeoTaggerViewController ()

@end

@implementation GeoTaggerViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewDidLoad];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // ***
    // Set a map type to Satellite view.
    //[worldView setMapType:MKMapTypeSatellite];
    
    GTSettings *settings = [GTSettings getInstance];
    
    if (settings.isOffline)
    {
        [worldView setShowsUserLocation:NO];
        
        for ( id view in self.view.subviews)
        {
            if ([((UIView *)view).restorationIdentifier isEqualToString:@"UserLocationMap"] )
            {
                // Disable MapView
                self.removedUserMapView = view;
                
                [((UIView *)view) removeFromSuperview];
                
                // Display offline mode message.
                UILabel *mssgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,100,self.view.frame.size.width-40,200)];
                mssgLabel.textAlignment = NSTextAlignmentCenter;
                mssgLabel.textColor = [UIColor redColor];
                mssgLabel.backgroundColor = [UIColor whiteColor];
                mssgLabel.numberOfLines = 5;
                mssgLabel.adjustsFontSizeToFitWidth = YES;
                mssgLabel.text = @"You are in offline mode.\n No map will be displayed. \n \n ";
                mssgLabel.text = [mssgLabel.text stringByAppendingString:@"Still You CAN add new data.\n Click Add button above."];
                
                [self.view addSubview:mssgLabel];
                
            }
        }
        
    }
    else
    {
        // If a user is using GPS to get the current location
        if (self.selectedPlace == nil)
        {
            // If a user is using GPS
            [worldView setShowsUserLocation:YES];
        }
        else // If a user selected a place of interest without using GPS
        {
            NSLog(@"inside of GeoTaggerViewController: setting selected place into a map");
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            CLLocationCoordinate2D coord;
            
            coord.latitude = [[self.selectedPlace latitude] doubleValue];
            coord.longitude = [[self.selectedPlace longitude] doubleValue];
            annotation.coordinate = coord;
            NSLog(@"selected coordinate: %f, %f", coord.latitude, coord.longitude);
            // Add annotation
            [worldView setShowsUserLocation:NO];
            [worldView addAnnotation:annotation];
            // Set a region to zoom (or pan) into the selected place
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 50000,50000);
            [worldView setRegion:region animated:TRUE];
            [worldView regionThatFits:region];
        }

        // If no UserLocationMap exists in subview array, put it back to display the map view.
        if (self.removedUserMapView != NULL)
        {
            [self.view addSubview:worldView];
            [self setRemovedUserMapView:NULL];
        }
        
    }
    
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
        
        // If devide is >= iOS 8, you need these.
        if(IS_OS_8_OR_LATER)
        {
            [locationManager requestWhenInUseAuthorization];
        }
        
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];

    }

}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"new location: %@", newLocation);
    [locationManager stopUpdatingLocation];
    [activityIndicator stopAnimating];

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
    
    // Center map to the current location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 3000, 3000);
    [worldView setRegion:region animated:YES];

    
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
    NSLog(@"Inside of mapView didUpdateUserLocation");
    // Disable default "Current Locaton" callout bubble.
    userLocation.title = nil;
    userLocation.subtitle = nil;
    
    CLLocationCoordinate2D loc = [[userLocation location] coordinate];
    // Using a MapKit function
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 50000,50000);
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

- (IBAction)updateLocation:(id)sender
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
        self.currLocation = [formController location];
        if (self.currLocation)
        {
            // Create an annotation on a map.
            CLLocationCoordinate2D point= CLLocationCoordinate2DMake([[self.currLocation valueForKey:@"latitude"]
                                                                      doubleValue],[[self.currLocation valueForKey:@"longitude"] doubleValue]);

            GTMapPoint *mp = [[GTMapPoint alloc] initWithCoordinate:point
                                                              title:[self.currLocation valueForKey:@"desc"]
                                                           indexNum:1];
            // Add the annotation to the map
            [worldView addAnnotation:mp];
            // Zoom the region to this location
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point, 3000, 3000);
            [worldView setRegion:region animated:YES];
            // Start updating location
            //[locationManager startUpdatingLocation];
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
        GTFormViewController *formController = [segue destinationViewController];
        
        CLLocation *selectedLoc;
        
        if(self.selectedPlace == nil)
        {
            // Register location into destination view controller
            selectedLoc = [locationManager location];
        }
        else
        {
            NSLog(@"Using a user's selected place, not GPS.");
            selectedLoc = [[CLLocation alloc] initWithLatitude:[[self.selectedPlace latitude] doubleValue]
                                                     longitude:[[self.selectedPlace longitude] doubleValue] ];
        }
        
        // Initialize for an initial map view. If currLoc is empty, set a default location
        // TODO: Handle this issue, like trying to get the current location or getting input from a user.
        if (!selectedLoc)
        {
            selectedLoc = [[CLLocation alloc] initWithLatitude:20.22 longitude:120.33];
        }
        
        [formController setLocation:selectedLoc];
        
        // Set conditions for a form.
        // For new data recording, Edit mode should be True and dataToDisplay should be none
        [formController setEditMode:TRUE];
        [formController setLocationToDisplay:NULL];
    }
    
    if ([[segue identifier] isEqualToString:@"findPlaceSegue"])
    {
        self.selectedPlace = nil;
        GTFindPlaceViewController *destination = [segue destinationViewController];
        [destination setGtvController:self];
    }
    
}

/* HERE
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        MKAnnotationView* annotationView = [mapView viewForAnnotation:annotation];
        annotationView.canShowCallout = NO;
        
        return nil;
    }
        
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[GTMapPoint class]])
    {        
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
*/

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
    calloutAccessoryControlTapped:(UIControl *)control
{
    // Go to detail view
    /*
    ViewController *detailViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
    NSLog(@"detail view button was hit.");
    
    [self performSegueWithIdentifier:@"DetailViewSegue" sender:self];
}




@end


















