//
//  GTDetailViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/29/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDetailViewController.h"
#import "GTData.h"

@implementation GTDetailViewController


- (void)configureView
{
    NSManagedObject *location = self.location;
    
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    if (location)
    {
        self.descLabel.text = [location valueForKey:@"desc"];
        // One way to convert double id to string
        self.latLabel.text = [[location valueForKey:@"latitude"] description];
        // The other way to convert double id to string
        self.longLabel.text = [NSString stringWithFormat:@"%@",[location valueForKey:@"longitude"]];
        //NSLog(@"created is: %@", [[location valueForKey:@"created"] description]);
        self.createdLabel.text = [[location valueForKey:@"created"] description];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

@end
