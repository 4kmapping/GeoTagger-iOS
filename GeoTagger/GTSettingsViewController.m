//
//  GTSettingsViewController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTSettingsViewController.h"
#import "GTSettings.h"
#import "GTDataManager.h"
#import "Sync.h"

@interface GTSettingsViewController ()

@end

@implementation GTSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
	// Do any additional setup after loading the view.
    GTSettings *settings = [GTSettings getInstance];
    
    // Initialize fields with previously stored values
    self.usernameLabel.text = settings.username;
    self.appkeyLabel.text = settings.appkey;
    NSString *syncStr = [NSString stringWithFormat:@"You need to sync %i data.", [self numDataToSync]];
    self.syncLabel.text = syncStr ;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Will refresh this view everytime it shows up.
    [super viewWillAppear:animated];
    [self viewDidLoad];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeOfflinemode:(id)sender
{
    
    UISwitch *offline = ((UISwitch *)sender);
    
    GTSettings *settings = [GTSettings getInstance];
    settings.isOffline = [offline isOn];
    
    NSLog(@"Now offline mode is %d", settings.isOffline);
    
}

- (IBAction)syncAllData:(id)sender
{
    NSLog(@"SyncAllData clicked");
    
    // check if offline mode
    GTSettings *settings = [GTSettings getInstance];
    GTDataManager *dataManager = [GTDataManager getInstance];
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    if (!settings.isOffline)
    {
        
        // sync data
        int statusCode;
        NSMutableArray *dataList = [self dataToSync];
        
        for (NSManagedObject *location in dataList)
        {
            
            NSLog(@"Syncing data...");
            
            statusCode = [dataManager syncWithLocation:location];
            
            NSLog(@"sync data status code: %d", statusCode);
            
            if (statusCode >= 200 && statusCode < 300) // sync was successful.
            {
                
                
                NSString *dataId = [location valueForKey:@"dataId"];
                [request setEntity:[NSEntityDescription entityForName:@"Sync" inManagedObjectContext:context]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dataId = %@", dataId];
                [request setPredicate:predicate];
                
                NSError *error;
                
                NSArray *results = [context executeFetchRequest:request error:&error];
                
                // update sync info
                Sync *sync = (Sync *)[results objectAtIndex:0];
                
                sync.isDataSynced = @YES;
                
                error = nil;
                if (![context save:&error])
                {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
            
        }
        
        // sync photo
        NSMutableArray *photoList = [self photoToSync];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        
        // Set folder path for photo.
        NSString *folderPath = [documentsPath stringByAppendingPathComponent:@"/photo"]; //Add the file name
        NSString *filePath;
        
        for (NSString *photoId in photoList)
        {
            filePath = [folderPath stringByAppendingPathComponent:photoId];
            
            NSData *photoData = [NSData dataWithContentsOfFile:filePath];
            
            NSLog(@"filePath to photo: %@", filePath);
            
            statusCode = [dataManager syncWithLocPhoto:photoData photoId:photoId];
            
            if (statusCode >= 200 && statusCode < 300) // sync was successful.
            {
                
                [request setEntity:[NSEntityDescription entityForName:@"Sync" inManagedObjectContext:context]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"photoId = %@", photoId];

                NSError *error;
                NSArray *results = [context executeFetchRequest:request error:&error];
                
                Sync *sync = (Sync *)[results objectAtIndex:0];
                
                sync.isPhotoSynced = @YES;
                
                error = nil;
                if (![context save:&error])
                {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
                
            }
        }
        
        // Refresh settings page
        [self viewDidLoad];
        
    }

    
}


- (int) numDataToSync
{
    int num = 0;
    
    self.dataToSync = [[NSMutableArray alloc] init];
    self.photoToSync = [[NSMutableArray alloc] init];
    
    GTDataManager *dataManager = [GTDataManager getInstance];
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Sync" inManagedObjectContext:context]];
    
    NSError *error;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    Sync *syncItem;
    
    for (syncItem in results)
    {
        
        if ( (![syncItem isDataSynced]) || ( [syncItem isPhoto] && (![syncItem isPhotoSynced])) )
        {
            num++;
        }
        
        
        if (![syncItem isDataSynced])
        {
            NSString *dataId = [syncItem dataId];
            
            [request setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dataId = %@", dataId];
            [request setPredicate:predicate];
            
            NSArray *dataList = [context executeFetchRequest:request error:&error];
            
            
            NSManagedObject *currData = [dataList objectAtIndex:0];

            [[self dataToSync] addObject:currData];
            
            /* For debugging */
            //NSLog(@"dataList size: %d", [dataList count]);
            //NSLog(@"Can't fetch! %@ %@", error, [error localizedDescription]);
            //NSLog(@"data desc: %@", [currData valueForKey:@"desc"]);
            //NSLog(@"data id: %@", [currData valueForKey:@"dataId"]);
            //NSLog(@"dataToSync size: %d", [self.dataToSync count]);
        
        }
        
        if( [syncItem isPhoto] && (![syncItem isPhotoSynced]) )
        {
            NSString *dataId = [syncItem dataId];
            
            [request setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dataId = %@", dataId];
            [request setPredicate:predicate];
            
            NSArray *dataList = [context executeFetchRequest:request error:&error];
            NSManagedObject *currData = [dataList objectAtIndex:0];
            
            NSString *photoId = [currData valueForKey:@"photoId"];
            
            [[self photoToSync] addObject:photoId];
            
            /* For debugging */
            //NSLog(@"photoId to sync: %@", photoId);
            //NSLog(@"photoToSync size: %d", [self.photoToSync count]);
        }
        
        
    }
    
    return num;
}




@end
