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
@class GTDataController;
@class GTData;

@interface GeoTaggerViewController : UIViewController
    <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;

}

@property (strong, nonatomic) GTDataController *dataController;
@property (nonatomic) NSManagedObject *currLocation;

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






