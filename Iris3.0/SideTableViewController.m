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
#import "OnDeck.h"
#import "AppDelegate.h"
#import "User.h"
#import "Configeration.h"
#import "Group.h"


@interface SideTableViewController (){
    NSArray *menuItems;
    NSString *selectedString;
}

@end

@implementation SideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setNeedsStatusBarAppearanceUpdate];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _lblName.text = [[OnDeck sharedInstance].userPreferences objectForKey:@"email"];
    _lblRole.text = [[OnDeck sharedInstance].userPreferences objectForKey:@"rolename"];
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 2) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *productList = [story instantiateViewControllerWithIdentifier:@"CreateViewController"];
//        productList.hidesBottomBarWhenPushed = YES;
//        //productList.strTitle = selectedString;
//        //productList.categoryId = pageId;
//        [self.revealViewController revealToggleAnimated:YES];
//        [[[[[self revealViewController].childViewControllers objectAtIndex:1] childViewControllers] objectAtIndex:0]  presentViewController:productList animated:YES completion:nil];
//    }
    if (indexPath.row == 6) {
        [self actionSignOut];
    }
}

- (void)actionSignOut
{
    [[OnDeck sharedInstance] signOutUser];
    
    NSArray *users = [self getUser];
    
    for (User *user in users) {
        [[[self appDelegate] managedObjectContext] deleteObject:user];
    }
    
    NSArray *configerations = [self getConfigeration];
    
    for (Configeration *configeration in configerations) {
        [[[self appDelegate] managedObjectContext] deleteObject:configeration];
        
    }
    
    NSArray *groups = [self getGroups];
    
    for (Group *group in groups) {
        [[[self appDelegate] managedObjectContext] deleteObject:group];
    }
    
    [self saveManageObject];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getConfigeration
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return arr;
}

- (NSArray *)getUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return arr;
}

- (NSArray *)getGroups
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return arr;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

-(BOOL)saveManageObject{
    NSError *error = nil;
    if ([[[self appDelegate] managedObjectContext] save:&error]) {
        
        return YES;
    }else{
        ////NSLog(@"Database Save error :%@",[error description]);
    }
    return NO;
}

@end
