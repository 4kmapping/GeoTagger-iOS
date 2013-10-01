//
//  GTData.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTData.h"

@implementation GTData

- (id)initWithDesc:(NSString *)desc
          latitude:(CLLocationDegrees)lat
         longitude:(CLLocationDegrees)lon
           created:(NSDate *)date
{
    self = [super init]; 
    
    if (self)
    {
        _desc = desc;
        _latitude = lat;
        _longitude = lon;
        _created = date;
        
        return self;
    }
    
    return nil;
}

@end
