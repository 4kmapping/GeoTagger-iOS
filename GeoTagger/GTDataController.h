//
//  GTDataController.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTData;

@interface GTDataController : NSObject

@property (nonatomic, retain) NSMutableArray *dataCollection;

- (NSUInteger)addFormData:(GTData *)data;

@end
