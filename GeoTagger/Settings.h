//
//  Settings.h
//  GeoTagger
//
//  Created by Min Seong Kang on 12/3/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * appkey;
@property (nonatomic, retain) NSNumber * isOffline;
@property (nonatomic, retain) NSString * hostPhotoURL;
@property (nonatomic, retain) NSString * hostURL;

@end
