//
//  GTListViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 10/2/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTListViewController.h"
#import "GTDataManager.h"
#import "GTFormViewController.h"


@interface GTListViewController ()

@end
 
@implementation GTListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataManager = [GTDataManager getInstance];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
     */
}


/***
 This method is called whenever this tableView appears.
 Refresh location data with new ones.
 */
- (void)viewWillAppear:(BOOL)animated
{
    //GTDataManager *dataManager = [GTDataManager getInstance];
    // Refresh location info
    locationArray = [dataManager getAllLocationsWithDescendingDateSorting];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LocationListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSManagedObject *location = [locationArray objectAtIndex:[indexPath row]];
    
    // Set a title of each cell with description (or timestamp)
    NSString *loc_desc = [location valueForKey:@"desc"];
    if ([loc_desc length] == 0) // if desc is empty, use timestamp instead
    {
        
        NSMutableString *timeStr = [NSMutableString stringWithString:[location valueForKey:@"created"]];
        [timeStr deleteCharactersInRange:[timeStr rangeOfString:@"+0000"]];
        cell.textLabel.text = timeStr;
    }
    else
    {
        cell.textLabel.text = [location valueForKey:@"desc"];
    }
    
    return cell;
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ViewDataFromListSegue"])
    {
        GTFormViewController *formController = [segue destinationViewController];
        
        NSInteger rowIndex = [[self.tableView indexPathForSelectedRow] row];
        NSLog(@"selected row: %d", rowIndex);
        NSManagedObject *location = [locationArray objectAtIndex:rowIndex];
        
        [formController setLocationToDisplay:location];
        
        [formController setEditMode:FALSE];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end










