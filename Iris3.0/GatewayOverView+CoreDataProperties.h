//
//  GatewayOverView+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 17/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GatewayOverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GatewayOverView (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *assetgroupname;
@property (nullable, nonatomic, retain) NSString *assetid;
@property (nullable, nonatomic, retain) NSString *assetname;
@property (nullable, nonatomic, retain) NSString *batt;
@property (nullable, nonatomic, retain) NSString *datetime;
@property (nullable, nonatomic, retain) NSString *distance;
@property (nullable, nonatomic, retain) NSString *extsensor;
@property (nullable, nonatomic, retain) NSString *groupname;
@property (nullable, nonatomic, retain) NSString *humidity;
@property (nullable, nonatomic, retain) NSString *light;
@property (nullable, nonatomic, retain) NSString *motion;
@property (nullable, nonatomic, retain) NSString *pressure;
@property (nullable, nonatomic, retain) NSString *rssi;
@property (nullable, nonatomic, retain) NSString *speed;
@property (nullable, nonatomic, retain) NSString *subgroupname;
@property (nullable, nonatomic, retain) NSString *temperature;
@property (nullable, nonatomic, retain) NSString *lat;
@property (nullable, nonatomic, retain) NSString *lon;
@property (nullable, nonatomic, retain) NSNumber *alive;
@property (nullable, nonatomic, retain) Group *group;

@end

NS_ASSUME_NONNULL_END
