//
//  AsssetLaunchViewController.h
//  Iris3.0
//
//  Created by Dipin on 17/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "OnDeck.h"
#import "HelpDesk.h"
#import "Asset.h"
#import "GatewayOverView.h"
#import "AppDelegate.h"

@interface AsssetLaunchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableViewAsset;
@property (nonatomic, strong) NSMutableArray *arrAsset;
@property (nonatomic, strong) Group *selectedGroup;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSDictionary *configeration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;

@property (weak, nonatomic) IBOutlet UITableView *tblGroups;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetTitle;
@property (weak, nonatomic) IBOutlet UILabel *assetHeader;


@end
