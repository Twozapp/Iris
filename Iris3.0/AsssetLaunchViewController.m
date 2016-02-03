//
//  AsssetLaunchViewController.m
//  Iris3.0
//
//  Created by Dipin on 17/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AsssetLaunchViewController.h"
#import "AssetViewController.h"
#import "Configeration.h"

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE


@interface AsssetLaunchViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *arrGroups;
    NSMutableArray *annotationList;
}

@end

@implementation AsssetLaunchViewController
@synthesize arrAsset;
@synthesize selectedGroup;
@synthesize selectedIndex;
@synthesize configeration;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tblGroups.hidden = YES;
    _tblGroups.tableFooterView = [[UIView alloc] init];
    if (selectedIndex == 0) {
        _lblAssetTitle.text = @"All Assets";
    }
    else
    {
        _lblAssetTitle.text = selectedGroup.groupname;
    }
    
    arrGroups = [[NSMutableArray alloc] init];
    [arrGroups addObject:@"All Assets"];
    [arrGroups addObjectsFromArray:[self fetchGroups]];
    [_tblGroups reloadData];
    
    // Do any additional setup after loading the view.
    _tableViewAsset.tableFooterView = [[UIView alloc] init];
    _heightTableView.constant = 44 * arrGroups.count;
    
    [self setNeedsStatusBarAppearanceUpdate];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (isiPhone) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor],
           NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor],
           NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    }
    Configeration *conf = (Configeration *)[self fetchConfigeration][0];
    if ([conf.dashboardSensorView isEqualToNumber:[NSNumber numberWithBool:false]]) {
        _assetHeader.text = [NSString stringWithFormat:@"  %@",conf.gatewayname];
    }
    else
    {
        _assetHeader.text = [NSString stringWithFormat:@"  %@",conf.nodename];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
    
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
    if (tableView == _tableViewAsset) {
        return arrAsset.count;
    }
    else
    {
        return arrGroups.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewAsset) {
        static NSString *CellIdentifier = @"AlertCell";
        //WishListCellExpanted
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        GatewayOverView *gateway = (GatewayOverView *)arrAsset[indexPath.row];
        
        UIView *view1 = (UIView *)[cell viewWithTag:1];
        UIView *view2 = (UIView *)[cell viewWithTag:2];
        UIView *view3 = (UIView *)[cell viewWithTag:3];
        UIView *view4 = (UIView *)[cell viewWithTag:4];
        UIImageView *tower = (UIImageView *)[view2 viewWithTag:10];
        UILabel *lblStrength = (UILabel *)[view2 viewWithTag:20];
        UILabel *lblTitle = (UILabel *)[view1 viewWithTag:10];
        UILabel *lblAddress = (UILabel *)[view1 viewWithTag:20];
        UILabel *lblTemperature = (UILabel *)[view3 viewWithTag:10];
        UILabel *lblBattery = (UILabel *)[view4 viewWithTag:10];
        UILabel *lblBatteryLevel = (UILabel *)[view4 viewWithTag:30];
        UILabel *lblTemperatureLevel = (UILabel *)[view3 viewWithTag:30];
        UIImageView *imgTemp = (UIImageView *)[view3 viewWithTag:20];
        UIImageView *imgBatt = (UIImageView *)[view4 viewWithTag:20];
        if (gateway.batt.intValue <= 50) {
            lblBatteryLevel.text = @"Low";
            imgBatt.image = [UIImage imageNamed:@"battery1"];
            lblBatteryLevel.textColor = [UIColor yellowColor];
        }
        else
        {
            imgBatt.image = [UIImage imageNamed:@"battery2"];
            lblBatteryLevel.text = @"";
        }
        
        if (gateway.temperature.intValue > 37) {
            imgTemp.image = [UIImage imageNamed:@"temperature1"];
            lblTemperatureLevel.text = @"High";
        }
        else
        {
            imgTemp.image = [UIImage imageNamed:@"temperature2"];
            lblTemperatureLevel.text = @"";
        }
        lblStrength.textColor = [UIColor blackColor];
        lblStrength.text = gateway.rssi;
        
        lblTitle.text = gateway.assetname.length == 0 ? @"" : gateway.assetname;
        lblAddress.text = gateway.address.length == 0 ? @"" : gateway.address;
        lblTemperature.text = [NSString stringWithFormat:@"%@°C",gateway.temperature];
        lblBattery.text = [NSString stringWithFormat:@"%@%%",gateway.batt];
        UIButton *btnStatus = (UIButton *)[cell viewWithTag:60];
        btnStatus.layer.cornerRadius = 5.0f;
        [btnStatus.layer setMasksToBounds:YES];
        
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [_tblGroups dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
        if (indexPath.row == 0) {
            lblTitle.text = @"All Assets";
        }
        else
        {
            Group *grp = arrGroups[indexPath.row];
            lblTitle.text = grp.groupname;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableViewAsset) {
        Configeration *config = (Configeration *)[self fetchConfigeration][0];

        if (config.mapView.boolValue == YES && arrAsset.count > 0) {
            if (isiPhone) {
                return 44;
            }
            return 64;
        }
        else
        {
            return 0;
        }
    
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackall"];
    UIButton *btn = (UIButton *)[cell viewWithTag:10];
    if (isiPhone) {
        btn.layer.cornerRadius = 15.0f;
    }
    else
    {
        btn.layer.cornerRadius = 24.0f;
    }
    [btn addTarget:self action:@selector(actionTrackAll:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblGroups) {
        if (indexPath.row == 0) {
            selectedIndex = 0;
            _tblGroups.hidden = YES;
            _lblAssetTitle.text = @"All Assets";
            [arrAsset removeAllObjects];
            [arrAsset addObjectsFromArray:[self fetchAssets]];
            [_tableViewAsset reloadData];
        }
        else
        {
            selectedIndex = indexPath.row;
            selectedGroup = arrGroups[indexPath.row];
            _tblGroups.hidden = YES;
            _lblAssetTitle.text = selectedGroup.groupname;
            [arrAsset removeAllObjects];
            [arrAsset addObjectsFromArray:[self fetchAssets]];
            [_tableViewAsset reloadData];
        }
    }
    else
    {
        GatewayOverView *selectedGateway = arrAsset[indexPath.row];
        [self performSegueWithIdentifier:@"toAssets" sender:selectedGateway];
    }
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)requestAsset{
    if ([HelpDesk sharedInstance].isInternetAvailable) {
        
        
        
        NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
        
        
        [WebServices sharedInstance].webRequestMode = (WebRequestMode *)WEB_REQUEST_ASSET;
        [[WebServices sharedInstance] composeWebRequestFromArguments:arguments forWebRequestMode:[WebServices sharedInstance].webRequestMode responseWithStatus:^(NSMutableArray *status){
            
            NSString * message = [status objectAtIndex:0];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([message compare:@"Success"] == NSOrderedSame) {
                
                arrAsset = [status objectAtIndex:1];
                
                [_tableViewAsset reloadData];
                
                
            }
            else if ([message compare:@"Failure"] == NSOrderedSame){
                
            }
            
            else{
                
            }
        }];
    }
    else{
        
        
    }
    
    
}

- (NSArray *)fetchGroups
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    return arr;
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

- (IBAction)actionGroups:(id)sender {
    _tblGroups.hidden = !_tblGroups.hidden;
}

- (NSArray *)fetchAssets
{
    if (selectedIndex == 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
        NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
        return arr;
    }
    else
    {
        return selectedGroup.gatewayoverview.allObjects;
    }
}

- (IBAction)actionTrackAll:(id)sender
{
    [self performSegueWithIdentifier:@"toAssets" sender:@"all"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAssets"]) {
        AssetViewController *assets = (AssetViewController *)segue.destinationViewController;
        
        assets.selectedIndex = selectedIndex;
        assets.selectedGroup = selectedGroup;
        assets.configeration = configeration;
        
        if (![sender isKindOfClass:[NSString class]]) {
            assets.selectedGateway = sender;
            assets.track = @"single";
            assets.arrAsset = [[NSMutableArray alloc] initWithObjects:sender, nil];
        }
        else
        {
            assets.track = @"all";
            assets.arrAsset = arrAsset;
        }
    }
}

- (NSArray *)fetchConfigeration
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
    NSArray *response = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return response;
}

@end
