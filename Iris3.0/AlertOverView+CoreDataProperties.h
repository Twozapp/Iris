//
//  AlertOverView+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AlertOverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertOverView (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *alertid;
@property (nullable, nonatomic, retain) NSString *startdatetime;
@property (nullable, nonatomic, retain) NSString *enddatetime;
@property (nullable, nonatomic, retain) NSString *alertvalue;
@property (nullable, nonatomic, retain) NSString *timezone;
@property (nullable, nonatomic, retain) NSString *acknowledged;
@property (nullable, nonatomic, retain) NSString *noccurance;
@property (nullable, nonatomic, retain) NSString *severity;
@property (nullable, nonatomic, retain) NSString *alertcfgid;
@property (nullable, nonatomic, retain) NSString *alertcfg;
@property (nullable, nonatomic, retain) NSString *alerttypeid;
@property (nullable, nonatomic, retain) NSString *alerttype;
@property (nullable, nonatomic, retain) NSString *nodeid;
@property (nullable, nonatomic, retain) NSString *node;
@property (nullable, nonatomic, retain) NSString *gatewayid;
@property (nullable, nonatomic, retain) NSString *gateway;
@property (nullable, nonatomic, retain) NSString *subgroupid;
@property (nullable, nonatomic, retain) NSString *subgroup;
@property (nullable, nonatomic, retain) NSString *groupid;
@property (nullable, nonatomic, retain) NSString *groupname;
@property (nullable, nonatomic, retain) NSString *lat;
@property (nullable, nonatomic, retain) NSString *lon;
@property (nullable, nonatomic, retain) Group *group;

@end

NS_ASSUME_NONNULL_END
