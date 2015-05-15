//
//  GTDataManager.h
//  GeoTagger
//
//  Created by Min Seong Kang on 10/1/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTData;

@interface GTDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (GTDataManager *)getInstance;

- (NSMutableArray *)getAllLocations;

- (NSMutableArray *)getAllLocationsWithDescendingDateSorting;

- (NSManagedObject *)saveDesc:(NSString *)desc withLat:(double)latitude
                      withLon:(double)longitude
              withCreatedTime:(NSDate *)date;

- (int)syncWithLocation:(NSManagedObject *)location;

- (int)syncWithLocPhoto:(NSData *)photoData photoId:(NSString *)photoId;

- (NSString *)convertToJsonFromObject:(NSManagedObject *)obj;

- (NSMutableArray *)getPlaceCandidateListWithPlaceName:(NSString *)placeName
                                           countryName:(NSString *)countryName;


@end

// TODO: Update this part later.
// Category for handling uncertified dev https.
@interface NSURLRequest(Private)
+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;
@end
