//
//  GroupSummary+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 23/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GroupSummary.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupSummary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupid;
@property (nullable, nonatomic, retain) NSString *noofasset;
@property (nullable, nonatomic, retain) NSString *noofNWasset;
@property (nullable, nonatomic, retain) NSString *noofWasset;
@property (nullable, nonatomic, retain) NSString *subgroupid;
@property (nullable, nonatomic, retain) Group *group;

@end

NS_ASSUME_NONNULL_END
