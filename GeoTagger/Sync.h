//
//  Sync.h
//  GeoTagger
//
//  Created by Min Seong Kang on 11/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Sync : NSManagedObject

@property (nonatomic, retain) NSNumber * isDataSynced;
@property (nonatomic, retain) NSDate * lastSyncTime;
@property (nonatomic, retain) NSNumber * isPhotoSynced;
@property (nonatomic, retain) NSNumber * isPhoto;
@property (nonatomic, retain) Location *syncLocation;

@end
