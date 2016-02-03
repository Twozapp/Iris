//
//  Configeration+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 23/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Configeration.h"

NS_ASSUME_NONNULL_BEGIN

@interface Configeration (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *configid;
@property (nullable, nonatomic, retain) NSNumber *dashboardSensorView;
@property (nullable, nonatomic, retain) NSString *gatewayname;
@property (nullable, nonatomic, retain) NSString *humidityunit;
@property (nullable, nonatomic, retain) NSNumber *incursionenable;
@property (nullable, nonatomic, retain) NSString *lightunit;
@property (nullable, nonatomic, retain) NSNumber *mapView;
@property (nullable, nonatomic, retain) NSString *memstype;
@property (nullable, nonatomic, retain) NSString *moistureunit;
@property (nullable, nonatomic, retain) NSString *nodename;
@property (nullable, nonatomic, retain) NSString *panic_tamper;
@property (nullable, nonatomic, retain) NSString *pressureunit;
@property (nullable, nonatomic, retain) NSNumber *realtimemonitor;
@property (nullable, nonatomic, retain) NSString *speedunit;
@property (nullable, nonatomic, retain) NSString *temperatureunit;
@property (nullable, nonatomic, retain) NSString *vgroupname;
@property (nullable, nonatomic, retain) NSString *vsubgroupname;
@property (nullable, nonatomic, retain) NSNumber *wirelessSensorView;

@end

NS_ASSUME_NONNULL_END
