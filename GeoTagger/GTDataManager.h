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
{
    NSMutableData *_responseData;
}

+ (GTDataManager *)getInstance;

- (NSManagedObjectContext *)managedObjectContext;

- (NSMutableArray *)getAllLocations;

- (NSMutableArray *)getAllLocationsWithDescendingDateSorting;

- (NSManagedObject *)saveDesc:(NSString *)desc withLat:(double)latitude
                      withLon:(double)longitude
              withCreatedTime:(NSDate *)date;

- (int)syncWithLocation:(NSManagedObject *)location;

- (int)syncWithLocPhoto:(NSData *)photoData photoId:(NSString *)photoId;
- (int)syncWithLocPhoto:(NSData *)photoDataId;

- (NSString *)convertToJsonFromObject:(NSManagedObject *)obj;

@end
