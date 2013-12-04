//
//  Sync.h
//  GeoTagger
//
//  Created by Min Seong Kang on 12/2/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Sync : NSManagedObject

@property (nonatomic, retain) NSNumber * isDataSynced;
@property (nonatomic, retain) NSNumber * isPhoto;
@property (nonatomic, retain) NSNumber * isPhotoSynced;
@property (nonatomic, retain) NSDate * lastSyncTime;
@property (nonatomic, retain) NSString * dataId;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) Location *syncLocation;

@end
