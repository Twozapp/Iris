//
//  AlertViewController.h
//  Iris3.0
//
//  Created by Priya on 01/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Group.h"
#import "Configeration.h"

@interface AlertViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITableView *tableViewAlert;

@property (strong , nonatomic) NSMutableArray *arrAlerts;
@property (weak, nonatomic) IBOutlet UITableView *tblGroups;
@property (weak, nonatomic) IBOutlet UILabel *lblAlerts;

@property (nonatomic, strong) Group *selectedGroup;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *assetHeader;
@property (nonatomic , strong) NSDictionary *configeration;
- (IBAction)actionGroups:(id)sender;
@end
