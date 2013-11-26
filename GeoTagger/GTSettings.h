//
//  GTSettings.h
//  GeoTagger
//
//  Created by Min Seong Kang on 11/21/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTSettings : NSObject
{
}

@property (nonatomic) BOOL isOffline;

+ (GTSettings *)getInstance;


@end
