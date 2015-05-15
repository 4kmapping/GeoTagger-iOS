//
//  PlaceCandidate.h
//  GeoTagger
//
//  Created by Min Seong Kang on 5/14/15.
//  Copyright (c) 2015 msk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceCandidate : NSObject

@property (nonatomic, retain) NSString *factualId;
@property (nonatomic, retain) NSString *contextname;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end
