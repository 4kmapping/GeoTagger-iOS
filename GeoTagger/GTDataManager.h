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

- (NSManagedObjectContext *)managedObjectContext;

- (NSMutableArray *)getAllLocations;

- (void)saveLocation:(GTData *)location;

@end
