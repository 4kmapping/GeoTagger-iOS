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
            //[instance setHostURL:@"http://localhost:8000/api/0.1/location/"];
            //[instance setHostURL:@"http://10.0.1.2:8000/api/0.1/location/"];
            //[instance setHostURL:@"http://10.0.1.2:8000/api/0.1/loc_pic/"];
            [instance setHostURL:@"http://10.31.15.92:8000/api/0.1/location/"];
            [instance setHostPhotoURL:@"http://10.31.15.92:8000/m/locpic/"];
            [instance setUsername: @"tester"];
            [instance setAppkey:@"1a2b3c4d5e"];
            
        }
    }
    
    return instance;
}



@end
