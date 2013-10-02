//
//  GTDataController.m
//  GeoTagger
//
//  Created by Min Seong Kang on 9/27/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTDataController.h"
#import "GTDataManager.h"

@implementation GTDataController


- (NSUInteger)addFormData:(GTData *)data
{
    // Return the index number of the inserted data.
    
    GTDataManager *dataManager = [[GTDataManager alloc] init];
    [dataManager saveLocation:data];
    
    if (self.dataCollection)
    {
        [self.dataCollection addObject:data];
        return [self.dataCollection count] - 1;
    }
    else
    {
        NSLog(@"data collection object is nil and failed to add data.");
        return -1;
    }
}



- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *newArray = [[NSMutableArray alloc] init];
        self.dataCollection = newArray;
        return self;
    }
    
    return nil;
}



@end
