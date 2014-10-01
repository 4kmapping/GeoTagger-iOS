//
//  GTDataManagerTests.m
//  GeoTagger
//
//  Created by Jason Ko on 9/26/14.
//  Copyright (c) 2014 msk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Location.h"
#import "Sync.h"
#import "GTDataManager.h"

@interface GTDataManagerTests : XCTestCase

@property (nonatomic, strong) GTDataManager *dataManager;

@end

@implementation GTDataManagerTests

- (void)setUp {
    [super setUp];
    
   self.dataManager = [GTDataManager getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConvertJson {
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Coordinator with in-mem store type
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
    // Context with private queue
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                                       //initWithConcurrencyType:NSPrivateQueueConcurrencyType]; // Choose your concurrency type, or leave it off entirely
    context.persistentStoreCoordinator = coordinator;
 
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                       inManagedObjectContext:context];
    location.dataId = @"id";
    
    Sync *sync = [NSEntityDescription insertNewObjectForEntityForName:@"Sync"
                                               inManagedObjectContext:context];
    sync.isPhoto = @NO;
    sync.isDataSynced = @NO;
    sync.isPhotoSynced = @YES;
    sync.dataId = @"DataID";
    location.locationSync = sync;
    
    location.latitude = @18.20;
    location.longitude = @-24.41;
    location.created = @"Created Date";
    
    for (NSString *key in [Location getBooleanTypeList]) {
        [location setValue:@NO forKey:key];
    }
    
    [location setValue:@YES forKey:@"evanType"];
    [location setValue:@YES forKey:@"trainType"];
    [location setValue:@YES forKey:@"mercyType"];
    [location setValue:@"Description 1" forKey:@"desc"];
    [location setValue:@"Tag1 tag2 tag3" forKey:@"tags"];
    
    
    NSString *json = [self.dataManager convertToJsonFromObject:location];
    NSLog(@"%@", json);
    NSString *expected = @"{\"trainType\":true,\"evanType\":true,\"youthType\":false,\"contactConfirmed\":false,\"tags\":\"Tag1 tag2 tag3\",\"contactEmail\":null,\"bibleStudyType\":false,\"communityDevType\":false,\"contactPhone\":null,\"researchType\":false,\"womenType\":false,\"constructionType\":false,\"campusType\":false,\"latitude\":18.2,\"artsType\":false,\"counselingType\":false,\"orphansType\":false,\"photoId\":null,\"prostitutesType\":false,\"hospitalType\":false,\"urbanType\":false,\"healthcareType\":false,\"mediaType\":false,\"mercyType\":true,\"longitude\":-24.41,\"prisonType\":false,\"dataId\":\"id\",\"churchPlantingType\":false,\"desc\":\"Description 1\",\"indigenousType\":false,\"contactWebsite\":null,\"created\":\"Created Date\"}";
    XCTAssert([json isEqualToString:expected], @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
