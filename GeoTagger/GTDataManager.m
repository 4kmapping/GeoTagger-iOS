//
//  GTDataManager.m
//  GeoTagger
//
//  Created by Min Seong Kang on 10/1/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDataManager.h"
#import "GTSettings.h"
#import "Location.h"

/*
 GTDataManager contains all the common methods used to read/write data to local and remote storage.
 */
@implementation GTDataManager

static const int timeoutSeconds = 7;


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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GeoTagger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[GTDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"GeoTagger.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
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
    
    NSError *error = nil;
    // Save the object to persistent store.
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    return newLocation;

}


# pragma Location data synchronization

- (int)syncWithLocation:(NSManagedObject *)location
{
    GTSettings *settings = [GTSettings getInstance];
    NSString *jsonStr = [self convertToJsonFromObject:location]; 
    NSURL *url = [NSURL URLWithString:[settings hostURL]];
    
    // TODO: This is a temporary setting to by-pass uncertified SSL. UPDATE THIS PART
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:timeoutSeconds];
    
    // Set headers
    NSMutableDictionary * headers = [[NSMutableDictionary alloc] init];
    NSString *appkeyStr = [NSString stringWithFormat:@"ApiKey %@:%@", settings.username, settings.appkey];
    [headers setObject:appkeyStr forKey:@"Authorization"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    
    [request setAllHTTPHeaderFields:headers];
    
    request.HTTPMethod = @"POST";
    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    /* For Debugging */
    //NSLog(@"json data is: %@", jsonStr);
    //NSLog(@"syncing location status code is: %d", [responseCode statusCode]);
    //NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);
    
    
    return [responseCode statusCode];
}



 - (int)syncWithLocPhoto:(NSData *)photoData photoId:(NSString *)photoId
{

    // create request
    GTSettings *settings = [GTSettings getInstance];
    NSURL *url = [NSURL URLWithString:[settings hostPhotoURL]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:timeoutSeconds];
    
    // Set headers
    NSMutableDictionary * headers = [[NSMutableDictionary alloc] init];

    NSString *appkeyStr = [NSString stringWithFormat:@"ApiKey %@:%@", settings.username, settings.appkey];
    [headers setObject:appkeyStr forKey:@"Authorization"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    [request setAllHTTPHeaderFields:headers];

    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:settings.username forKey:@"username"];

    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *boundaryConstant = @"----------V4xnHDg04ehbqgZCaMO5jx";

    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];

    // post body
    NSMutableData *body = [NSMutableData data];

    // add params (all params are strings)
    for (NSString *param in _params)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    // add image data
    if (photoData)
    {
    
        NSString *picParamName = @"pic";
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", picParamName, photoId] dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; \r\n", picParamName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:photoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
        NSString *dataStr = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
    
        //NSLog(@"%@", dataStr);
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

    // setting the body of the post to the reqeust
    [request setHTTPBody:body];

    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    // set URL
    [request setURL:url];

    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    //NSLog(@"syncing photo status code is: %d", [responseCode statusCode]);
    //NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);

    return [responseCode statusCode];

}


# pragma Helper methods

- (NSString *)convertToJsonFromObject:(NSManagedObject *)obj
{
    NSEntityDescription *entity = [obj entity];
    NSDictionary *attributes = [entity attributesByName];
    NSArray *keys = attributes.allKeys;
    
    NSDictionary *dict = [[obj dictionaryWithValuesForKeys:keys] mutableCopy];
    
    NSArray *booleanTypeList = [Location getBooleanTypeList];
    
    // Substitute 0/1 to true/false for boolean values
    for (NSString *key in booleanTypeList)
    {
        int value = [dict[key] intValue];
        [dict setValue:[NSNumber numberWithBool:value] forKey:key];
    }
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    NSString *jsonStr;
    
    if(!jsonData)
    {
        NSLog(@"JSON Error: %@", error);
    }
    else
    {
        jsonStr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    }
    
    return jsonStr;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
