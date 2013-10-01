//
//  GTMapPoint.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/26/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GTMapPoint : NSObject <MKAnnotation>
{
    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t indexNum:(NSUInteger)index;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic) NSUInteger indexNum;


@end
