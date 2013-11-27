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
            
            // TODO: REMOVE THIS SETTING. This is for dev only.
            [instance setHostURL:@"https://192.237.166.7/api/0.1/location/"];
        }
    }
    
    return instance;
}



@end
