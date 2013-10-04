//
//  GTDataManager.m
//  GeoTagger
//
//  Created by Min Seong Kang on 10/1/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDataManager.h"
#import "GTData.h"

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
    
    NSMutableArray * locations = [[managedContext executeFetchRequest:fetchRequest error:&e] mutableCopy];
    
    if(!locations) // error occured.
    {
        NSLog(@"Can't fetch location data, %@, %@", e, [e localizedDescription]);
    }
    
    return locations;
}


- (NSManagedObject *)saveDesc:(NSString *)desc withLat:(double)latitude withLon:(double)longitude withCreatedTime:(NSDate *)date
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                               inManagedObjectContext:context];
    [newLocation setValue:desc forKey:@"desc"];
    [newLocation setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [newLocation setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [newLocation setValue:date forKey:@"created"];
    
    NSError *error = nil;
    // Save the object to persistent store.
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    return newLocation;

}


@end
