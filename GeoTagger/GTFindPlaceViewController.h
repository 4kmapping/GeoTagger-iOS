//
//  GTFindPlaceViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 4/21/15.
//  Copyright (c) 2015 msk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoTaggerViewController.h"

@interface GTFindPlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *placeCandidates;
}

@property (strong, nonatomic) IBOutlet UITableView *placeCandidatesTable;
@property (weak, nonatomic) GeoTaggerViewController *gtvController;


@end
