//
//  GTSettings.m
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import "GTSettings.h"

@implementation GTSettings

static GTSettings *instance = nil;

+ (GTSettings *) getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [GTSettings new];
            [instance setIsOffline:NO];
        }
    }
    
    return instance;
}



@end
