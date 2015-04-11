//
//  GTSettings.m
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTSettings.h"
#import "GTDataManager.h"
#import "Settings.h"

@implementation GTSettings

static GTSettings *instance = nil;

+ (GTSettings *) getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {

            
            instance = [GTSettings new];
            
            GTDataManager *dataManager = [GTDataManager getInstance];
            
            NSManagedObjectContext *context = [dataManager managedObjectContext];
            

            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context]];
            
            [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
            
            NSError *error;
            NSUInteger count = [context countForFetchRequest:request error:&error];
            if(count == NSNotFound)
            {
                NSLog(@"Can't query and count for Settings in data store %@ %@", error, [error localizedDescription]);
            }
            
            // Execute this part only once.
            if(count == 0)
            {
                
                NSLog(@"Creating new entry");
                
                Settings *newSettings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings"
                                                                      inManagedObjectContext:context];
                newSettings.username = @"";
                newSettings.appkey = @"";
                newSettings.isOffline = false; //NO; bobc
                
                // TODO: Update this part. Now it is hard-coded.
                newSettings.hostURL = @"https://192.237.166.7/api/0.1/location/";
                newSettings.hostPhotoURL = @"https://192.237.166.7/m/locpic/";
                
                NSError *error = nil;
                if (![context save:&error])
                {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
            
            
            request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context]];
            [request setFetchLimit:1];
            
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            // Initialize settings instance with values.
            NSManagedObject *settings = [results objectAtIndex:0];
            
            [instance setHostURL:[settings valueForKey:@"hostURL"]];
            [instance setHostPhotoURL:[settings valueForKey:@"hostPhotoURL"]];
            [instance setIsOffline:(BOOL)[settings valueForKey:@"isOffline"]];
            [instance setUsername:[settings valueForKey:@"username"]];
            [instance setAppkey:[settings valueForKey:@"appkey"]];
            
        }
    }
    
    return instance;
}

- (void) save
{
    GTDataManager *dataManager = [GTDataManager getInstance];
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    // Create a new managed object
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context]];
    [request setFetchLimit:1];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject *settings = [results objectAtIndex:0];
    
    [settings setValue:instance.username forKey:@"username"];
    [settings setValue:instance.appkey forKey:@"appkey"];
    
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}



@end
