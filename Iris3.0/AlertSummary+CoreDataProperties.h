//
//  AlertSummary+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 23/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AlertSummary.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertSummary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *alertCnt;
@property (nullable, nonatomic, retain) NSString *attentionAlertCnt;
@property (nullable, nonatomic, retain) NSString *criticalALertCnt;
@property (nullable, nonatomic, retain) NSString *faultAlertCnt;
@property (nullable, nonatomic, retain) Group *group;

@end

NS_ASSUME_NONNULL_END
