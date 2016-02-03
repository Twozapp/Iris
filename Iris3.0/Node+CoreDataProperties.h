//
//  Node+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 23/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface Node (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *analogsensorenable;
@property (nullable, nonatomic, retain) NSNumber *assetgroupid;
@property (nullable, nonatomic, retain) NSString *assetgroupname;
@property (nullable, nonatomic, retain) NSString *descriptions;
@property (nullable, nonatomic, retain) NSString *digitalsensorenable;
@property (nullable, nonatomic, retain) NSString *extsensortype;
@property (nullable, nonatomic, retain) NSNumber *gatewayid;
@property (nullable, nonatomic, retain) NSString *gatewayname;
@property (nullable, nonatomic, retain) NSNumber *groupid;
@property (nullable, nonatomic, retain) NSString *groupname;
@property (nullable, nonatomic, retain) NSNumber *isalive;
@property (nullable, nonatomic, retain) NSNumber *isenable;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *model;
@property (nullable, nonatomic, retain) NSNumber *modelid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *nodeid;
@property (nullable, nonatomic, retain) NSNumber *subgroupid;
@property (nullable, nonatomic, retain) NSString *subgroupname;
@property (nullable, nonatomic, retain) Group *group;
@property (nullable, nonatomic, retain) GatewayOverView *nodesummary;

@end

NS_ASSUME_NONNULL_END
