//
//  SideTableViewController.m
//  EastandLo
//
//  Created by Priyanka on 4/1/15.
//  Copyright (c) 2015 Openwave. All rights reserved.
//

#import "SideTableViewController.h"
#import "SWRevealViewController.h"
#import "DashboardViewController.h"


@interface SideTableViewController (){
    NSArray *menuItems;
    NSString *selectedString;
}

@end

@implementation SideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.tableFooterView = [[UIView alloc] init];
    menuItems = [[NSArray alloc]initWithObjects:@"New", @"Tops", @"Skirts", @"Pants", @"Shorts", @"Dresses", @"Denim", @"Sale", nil];
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *productList = [story instantiateViewControllerWithIdentifier:@"CreateViewController"];
        productList.hidesBottomBarWhenPushed = YES;
        //productList.strTitle = selectedString;
        //productList.categoryId = pageId;
        [self.revealViewController revealToggleAnimated:YES];
        [[[[[self revealViewController].childViewControllers objectAtIndex:1] childViewControllers] objectAtIndex:0]  presentViewController:productList animated:YES completion:nil];
    }
    
}





@end
