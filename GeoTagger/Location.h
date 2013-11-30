//
//  Location.h
//  GeoTagger
//
//  Created by Min Seong Kang on 11/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sync;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * artsType;
@property (nonatomic, retain) NSNumber * bibleStudyType;
@property (nonatomic, retain) NSNumber * campusType;
@property (nonatomic, retain) NSNumber * churchPlantingType;
@property (nonatomic, retain) NSNumber * communityDevType;
@property (nonatomic, retain) NSNumber * constructionType;
@property (nonatomic, retain) NSNumber * contactConfirmed;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSString * contactWebsite;
@property (nonatomic, retain) NSNumber * counselingType;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * evanType;
@property (nonatomic, retain) NSNumber * healthcareType;
@property (nonatomic, retain) NSNumber * hospitalType;
@property (nonatomic, retain) NSNumber * indigenousType;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * mediaType;
@property (nonatomic, retain) NSNumber * mercyType;
@property (nonatomic, retain) NSNumber * orphansType;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) NSNumber * prisonType;
@property (nonatomic, retain) NSNumber * prostitutesType;
@property (nonatomic, retain) NSNumber * researchType;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * trainType;
@property (nonatomic, retain) NSNumber * urbanType;
@property (nonatomic, retain) NSNumber * womenType;
@property (nonatomic, retain) NSNumber * youthType;
@property (nonatomic, retain) Sync *locationSync;

+ (NSArray *)getBooleanTypeList;

@end
