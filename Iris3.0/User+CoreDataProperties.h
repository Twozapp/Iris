//
//  User+CoreDataProperties.h
//  Iris3.0
//
//  Created by Dipin on 07/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *authKey;

@end

NS_ASSUME_NONNULL_END
