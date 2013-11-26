//
//  GTDataManager.m
//  GeoTagger
//
//  Created by Min Seong Kang on 10/1/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDataManager.h"
//#import "GTData.h"

@implementation GTDataManager


+ (GTDataManager *)getInstance
{
    static GTDataManager *singletonInstance = nil;
    @synchronized(self)
    {
        if(singletonInstance == nil)
        {
            singletonInstance = [[self alloc] init];
        }
    }
    
    return singletonInstance;
    
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSMutableArray *)getAllLocations
{
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    
    NSError *e = nil;
    
    NSMutableArray *locations = [[managedContext executeFetchRequest:fetchRequest error:&e] mutableCopy];
    
    if(!locations) // error occured.
    {
        NSLog(@"Can't fetch all location data, %@, %@", e, [e localizedDescription]);
    }
    
    return locations;
}


- (NSMutableArray *)getAllLocationsWithDescendingDateSorting
{
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *e = nil;
    
    NSMutableArray *locations = [[managedContext executeFetchRequest:fetchRequest error:&e] mutableCopy];
    
    if(!locations) // error occured.
    {
        NSLog(@"Can't fetch all location data, %@, %@", e, [e localizedDescription]);
    }
    
    return locations;
}


/* REFINE OR DELETE THIS
 =======
- (NSManagedObject *)getLocationWithId:(NSInteger)locId
{
    NSManagedObjectContext *mContext = [self managedObjectContext];
    NSFetchRequest *fRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", locId];
    [fRequest setPredicate:predicate];
    
    NSError *e = nil;
    NSManagedObject *location = [mContext executeFetchRequest:fRequest error:&e][0];
    
    if(!location)
    {
        NSLog(@"Can't fetch a location data, %@, %@", e, [e localizedDescription]);
    }
    
    return location;
}
*/


- (NSManagedObject *)saveDesc:(NSString *)desc withLat:(double)latitude
                      withLon:(double)longitude
              withCreatedTime:(NSDate *)date
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                               inManagedObjectContext:context];
    [newLocation setValue:desc forKey:@"desc"];
    [newLocation setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [newLocation setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [newLocation setValue:[date description] forKey:@"created"];
    
    NSLog(@"Before saving, object id of new location is: %@ <<", [newLocation objectID]);
    
    
    NSError *error = nil;
    // Save the object to persistent store.
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    NSLog(@"After saving, object id of new location is: %@ <<", [newLocation objectID]);

    /*
    [newLocation setValue:[[newLocation objectID] description ] forKey:@"uuid"];
    
    if (![context save:&error])
    {
        NSLog(@"Can't update with object id! %@ %@", error, [error localizedDescription]);
    }
    */
    
    return newLocation;

}


@end
