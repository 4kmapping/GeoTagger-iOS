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
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *hostURL;
@property (nonatomic, strong) NSString *hostPhotoURL;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *appkey;

+ (GTSettings *)getInstance;


@end
