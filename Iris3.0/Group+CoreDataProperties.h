//
//  Group+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 28/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupid;
@property (nullable, nonatomic, retain) NSString *groupname;
@property (nullable, nonatomic, retain) AlertSummary *alertoverview;
@property (nullable, nonatomic, retain) NSSet<AlertOverView *> *alertsummary;
@property (nullable, nonatomic, retain) NSSet<GatewayOverView *> *gatewayoverview;
@property (nullable, nonatomic, retain) NSSet<Node *> *nodes;
@property (nullable, nonatomic, retain) GroupSummary *overview;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addAlertsummaryObject:(AlertOverView *)value;
- (void)removeAlertsummaryObject:(AlertOverView *)value;
- (void)addAlertsummary:(NSSet<AlertOverView *> *)values;
- (void)removeAlertsummary:(NSSet<AlertOverView *> *)values;

- (void)addGatewayoverviewObject:(GatewayOverView *)value;
- (void)removeGatewayoverviewObject:(GatewayOverView *)value;
- (void)addGatewayoverview:(NSSet<GatewayOverView *> *)values;
- (void)removeGatewayoverview:(NSSet<GatewayOverView *> *)values;

- (void)addNodesObject:(Node *)value;
- (void)removeNodesObject:(Node *)value;
- (void)addNodes:(NSSet<Node *> *)values;
- (void)removeNodes:(NSSet<Node *> *)values;

@end

NS_ASSUME_NONNULL_END
