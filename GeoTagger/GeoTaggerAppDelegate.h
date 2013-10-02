//
//  GeoTaggerAppDelegate.h
//  GeoTagger
//
//  Created by Min Seong Kang on 9/26/13.
//  Copyright (c) 2013 msk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeoTaggerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
