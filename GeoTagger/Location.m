//
//  Location.m
//  GeoTagger
//
//  Created by Min Seong Kang on 11/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "Location.h"
#import "Sync.h"


@implementation Location

@dynamic artsType;
@dynamic bibleStudyType;
@dynamic campusType;
@dynamic churchPlantingType;
@dynamic communityDevType;
@dynamic constructionType;
@dynamic contactConfirmed;
@dynamic contactEmail;
@dynamic contactPhone;
@dynamic contactWebsite;
@dynamic counselingType;
@dynamic created;
@dynamic desc;
@dynamic evanType;
@dynamic healthcareType;
@dynamic hospitalType;
@dynamic indigenousType;
@dynamic latitude;
@dynamic longitude;
@dynamic mediaType;
@dynamic mercyType;
@dynamic orphansType;
@dynamic photoId;
@dynamic prisonType;
@dynamic prostitutesType;
@dynamic researchType;
@dynamic tags;
@dynamic trainType;
@dynamic urbanType;
@dynamic womenType;
@dynamic youthType;
@dynamic locationSync;

+ (NSArray *)getBooleanTypeList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [list addObject:@"artsType"];
    [list addObject:@"bibleStudyType"];
    [list addObject:@"campusType"];
    [list addObject:@"churchPlantingType"];
    [list addObject:@"communityDevType"];
    [list addObject:@"constructionType"];
    [list addObject:@"counselingType"];
    [list addObject:@"contactConfirmed"];
    [list addObject:@"evanType"];
    [list addObject:@"healthcareType"];
    [list addObject:@"hospitalType"];
    [list addObject:@"indigenousType"];
    [list addObject:@"mediaType"];
    [list addObject:@"mercyType"];
    [list addObject:@"orphansType"];
    [list addObject:@"prisonType"];
    [list addObject:@"prostitutesType"];
    [list addObject:@"researchType"];
    [list addObject:@"trainType"];
    [list addObject:@"urbanType"];
    [list addObject:@"womenType"];
    [list addObject:@"youthType"];
    
    return list;
}


@end
