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

- (void)setData:(GTData *) newData
{
    if (_data != newData)
    {
        _data = newData;
        
        // update the view
        [self configureView];
    }
}

- (void)configureView
{
    GTData *theData = self.data;
    
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    if (theData)
    {
        NSString *desc = [theData desc];
        self.descLabel.text = [theData desc];
        self.latLabel.text = [NSString stringWithFormat:@"%.6f", theData.latitude];
        self.longLabel.text = [NSString stringWithFormat:@"%.6f", theData.longitude];;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

@end
