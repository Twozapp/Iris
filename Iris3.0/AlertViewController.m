//
//  AlertViewController.m
//  Iris3.0
//
//  Created by Priya on 01/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewAlert.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlertCell";
    //WishListCellExpanted
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:20];
    UILabel *lblDuration = (UILabel *)[cell viewWithTag:30];
    UILabel *lblDegree = (UILabel *)[cell viewWithTag:40];
    UILabel *lblTemperature = (UILabel *)[cell viewWithTag:50];
    UIButton *btnStatus = (UIButton *)[cell viewWithTag:60];
    btnStatus.layer.cornerRadius = 5.0f;
    [btnStatus.layer setMasksToBounds:YES];
    
    
    
    return cell;
}


@end
