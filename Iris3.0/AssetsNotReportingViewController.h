//
//  AssetsNotReportingViewController.h
//  Iris3.0
//
//  Created by Dipin on 17/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface AssetsNotReportingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblAssets;
@property (nonatomic, strong) Group *selectedGroup;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *arrAsset;
@property (nonatomic , strong) NSDictionary *configeration;
@property (weak, nonatomic) IBOutlet UILabel *assetHeader;

@end
