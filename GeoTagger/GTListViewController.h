//
//  GTListViewController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 10/2/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTDataManager;

@interface GTListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    GTDataManager *dataManager;
    NSMutableArray *locationArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
