//
//  GTDetailViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/29/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTData;

@interface GTDetailViewController : UITableViewController

@property (strong, nonatomic) GTData *data;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;

@end
