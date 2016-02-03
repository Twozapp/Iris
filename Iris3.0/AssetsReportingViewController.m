//
//  AssetsReportingViewController.m
//  Iris3.0
//
//  Created by Dipin on 17/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AssetsReportingViewController.h"
#import "GatewayOverView.h"
#import "AppDelegate.h"
#import "AssetViewController.h"
#import "Configeration.h"

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE


@interface AssetsReportingViewController ()

@end

@implementation AssetsReportingViewController
{
}
@synthesize selectedIndex;
@synthesize selectedGroup;
@synthesize configeration;
@synthesize arrAsset;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tblAssets.tableFooterView = [[UIView alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
    
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
        self.title = [NSString stringWithFormat:@"%@ Reporting",conf.gatewayname];
        _assetHeader.text = [NSString stringWithFormat:@"  %@",conf.gatewayname];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@ Reporting",conf.nodename];
        _assetHeader.text = [NSString stringWithFormat:@"  %@",conf.nodename];
    }
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
        return arrAsset.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        if (gateway.batt.intValue <= 20) {
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
        lblTitle.text = gateway.assetname;
        lblAddress.text = gateway.address;
        lblTemperature.text = [NSString stringWithFormat:@"%@°C",gateway.temperature];
        lblBattery.text = [NSString stringWithFormat:@"%@%%",gateway.batt];
        UIButton *btnStatus = (UIButton *)[cell viewWithTag:60];
        btnStatus.layer.cornerRadius = 5.0f;
        [btnStatus.layer setMasksToBounds:YES];
        
        
        
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GatewayOverView *selectedGateway = arrAsset[indexPath.row];
    [self performSegueWithIdentifier:@"toAssets" sender:selectedGateway];
}

- (NSArray *)fetchAssets
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
    request.predicate = [NSPredicate predicateWithFormat:@"alive == 1"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    return arr;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tblAssets) {
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

- (NSArray *)fetchConfigeration
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
    NSArray *response = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return response;
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


@end
