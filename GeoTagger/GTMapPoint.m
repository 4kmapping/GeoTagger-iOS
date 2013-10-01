//
//  GTMapPoint.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/26/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTMapPoint.h"

@implementation GTMapPoint

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
                indexNum:(NSUInteger)index
{
    self = [super init];
    
    if(self)
    {
        _coordinate = c;
        [self setTitle:t];
        [self setIndexNum:index];
    }
    
    return self;
}

@end
