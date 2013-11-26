//
//  GeoTaggerViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/26/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface GeoTaggerViewController : UIViewController
    <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;

}


@property (nonatomic) NSManagedObject *currLocation;

// Indicator that tells if previous choice was offline mode.
// If this vlaue is not NULL, the previous choice was offline mode.
// It itself is a pointer to UserLocationMap and will be used to put the view
//   back to view controller.
@property (strong, nonatomic) UIView *removedUserMapView;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)findLocation;

// actions for a button
- (IBAction)updateLocation:(id)sender;

// unwind actions for form view controller
- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end






