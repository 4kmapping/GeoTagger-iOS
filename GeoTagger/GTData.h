//
//  GTData.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GTData : NSObject
{
}

@property NSString *desc;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;
@property (nonatomic, strong) NSDate *created;

- (id)initWithDesc:(NSString *)desc latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon created:(NSDate *)date;

@end
