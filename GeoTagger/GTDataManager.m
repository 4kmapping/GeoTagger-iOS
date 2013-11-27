//
//  GTDataManager.m
//  GeoTagger
//
//  Created by Min Seong Kang on 10/1/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDataManager.h"
#import "GTSettings.h"

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


# pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    
    NSLog(@"didReceivedResponse was hit");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"didFailWithError was hit: %@", error);
}



# pragma Location data synchronization

- (void)syncWithLocation:(NSManagedObject *)location
{
    GTSettings *settings = [GTSettings getInstance];
    NSString *jsonStr = [self convertToJsonFromObject:location];
    
    NSURL *url = [NSURL URLWithString:[settings hostURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:jsonStr];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
    
}


# pragma Helper methods

- (NSString *)convertToJsonFromObject:(NSManagedObject *)obj
{
    NSEntityDescription *entity = [obj entity];
    NSDictionary *attributes = [entity attributesByName];
    NSArray *keys = attributes.allKeys;
    
    NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys] ;
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    NSString *jsonStr;
    
    if(!jsonData)
    {
        NSLog(@"JSON Error: %@", error);
    }
    else
    {
        NSString *jsonStr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON OUTOUT: %@", jsonStr);
    }
    
    return jsonStr;
}



@end
