//
//  AlertViewController.m
//  Iris3.0
//
//  Created by Priya on 01/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AlertViewController.h"
#import "AlertOverView.h"
#import "AppDelegate.h"
#import "AssetViewController.h"
#import "Configeration.h"

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE


@interface AlertViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arrGroups;
    NSMutableArray *annotationList;
}
@end

@implementation AlertViewController

@synthesize arrAlerts;
@synthesize selectedIndex;
@synthesize selectedGroup;
@synthesize configeration;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (selectedIndex == 0) {
        _lblAlerts.text = @"All Alerts";
    }
    else
    {
        _lblAlerts.text = selectedGroup.groupname;
    }
    
    
    arrGroups = [[NSMutableArray alloc] init];
    [arrGroups addObject:@"All Alerts"];
    [arrGroups addObjectsFromArray:[self fetchGroups]];
    [_tblGroups reloadData];
    _tblGroups.hidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    _tableViewAlert.tableFooterView = [[UIView alloc] init];
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
        _assetHeader.text = [NSString stringWithFormat:@"%@ & Alert Time",conf.gatewayname];
    }
    else
    {
        _assetHeader.text = [NSString stringWithFormat:@"%@ & Alert Time",conf.nodename];
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
    if (tableView == _tableViewAlert) {
        return arrAlerts.count;
    }
    else
    {
        return arrGroups.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableViewAlert) {
        Configeration *config = (Configeration *)[self fetchConfigeration][0];
        
        if (config.mapView.boolValue == YES && arrAlerts.count > 0) {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewAlert) {

    static NSString *CellIdentifier = @"AlertCell";
    //WishListCellExpanted
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AlertOverView *overview = (AlertOverView *)arrAlerts[indexPath.row];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:20];
    UILabel *lblDuration = (UILabel *)[cell viewWithTag:30];
    UILabel *lblDegree = (UILabel *)[cell viewWithTag:40];
    // UILabel *lblTemperature = (UILabel *)[cell viewWithTag:50];
    UIButton *btnStatus = (UIButton *)[cell viewWithTag:60];
    
    lblTitle.text = overview.gateway;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
   // [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"]];
   // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"]];
    NSDate *startDate = [formatter dateFromString:overview.startdatetime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm"];
    NSString *strDate = [dateFormatter stringFromDate:startDate];
    
    lblDate.text = [NSString stringWithFormat:@"%@ hrs",strDate];
    
    NSDate *endDate = [formatter dateFromString:overview.enddatetime];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *conversionInfo = [calendar components:unitFlags fromDate:startDate   toDate:endDate  options:0];
    
    NSInteger days = [conversionInfo day];
    NSInteger hours = [conversionInfo hour];
    NSInteger minutes = [conversionInfo minute];
    if (days != 0) {
        lblDuration.text = [NSString stringWithFormat:@"Duration: %li days",(long)days];
    }
    else
    {
        if (hours != 0) {
         lblDuration.text = [NSString stringWithFormat:@"Duration: %li hrs",(long)hours];
        }
        else
        {
            lblDuration.text = [NSString stringWithFormat:@"Duration: %li mins",(long)minutes];
        }
        
    }
    
    lblDegree.text = [NSString stringWithFormat:@"%@°C",overview.alertvalue];
    
    switch (overview.severity.intValue) {
        case 2:
        {
           [btnStatus setTitle:@"ATTENTION" forState:UIControlStateNormal];
            btnStatus.backgroundColor = [UIColor blueColor];
        }
            break;
        
        case 3:
        {
            [btnStatus setTitle:@"CRITICAL" forState:UIControlStateNormal];
            btnStatus.backgroundColor = [UIColor orangeColor];
        }
            break;
        case 4:
        {
            [btnStatus setTitle:@"FAULT" forState:UIControlStateNormal];
            btnStatus.backgroundColor = [UIColor redColor];
        }
            break;
            
        default:
            break;
    }
    
   // btnStatus.titleLabel.text = @"Fault";
    
    
    btnStatus.layer.cornerRadius = 12.0f;
    [btnStatus.layer setMasksToBounds:YES];
    
    
    
    return cell;
    }
    else
    {
        UITableViewCell *cell = [_tblGroups dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
        if (indexPath.row == 0) {
            lblTitle.text = @"All Alerts";
        }
        else
        {
            Group *grp = arrGroups[indexPath.row];
            lblTitle.text = grp.groupname;
        }
        return cell;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblGroups) {
        if (indexPath.row == 0) {
            selectedIndex = 0;
            _tblGroups.hidden = YES;
            _lblAlerts.text = @"All Alerts";
            [arrAlerts removeAllObjects];
            [arrAlerts addObjectsFromArray:[self fetchAlerts]];
            [_tableViewAlert reloadData];
        }
        else
        {
            selectedIndex = indexPath.row;
            selectedGroup = arrGroups[indexPath.row];
            _tblGroups.hidden = YES;
            _lblAlerts.text = selectedGroup.groupname;
            [arrAlerts removeAllObjects];
            [arrAlerts addObjectsFromArray:[self fetchAlerts]];
            [_tableViewAlert reloadData];
        }
    }
    else
    {
        Configeration *config = (Configeration *)[self fetchConfigeration][0];
        if (config.mapView.boolValue == YES) {
            AlertOverView *alert = arrAlerts[indexPath.row];
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
            request.predicate = [NSPredicate predicateWithFormat:@"assetid == %@",alert.gatewayid];
            NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
            //[arrAssets addObject:arr[0]];
            if (arr.count > 0) {
                GatewayOverView *selectedGateway = (GatewayOverView *)arr[0];
                [self performSegueWithIdentifier:@"toAssets" sender:selectedGateway];
            }
            else
            {
                [self performSegueWithIdentifier:@"toAssets" sender:nil];
            }
        }
        
        
    }
}

- (NSArray *)fetchAlerts
{
    if (selectedIndex == 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AlertOverView"];
        NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
        return arr;
    }
    else
    {
        return selectedGroup.alertsummary.allObjects;
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
            assets.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssets]];
        }
    }
}

- (NSArray *)fetchAssets
{
        NSMutableArray *arrAssets = [[NSMutableArray alloc] init];
        for (AlertOverView *alert in arrAlerts) {
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
            request.predicate = [NSPredicate predicateWithFormat:@"assetid == %@",alert.gatewayid];
            NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
            if (![arrAssets containsObject:arr[0]]) {
                [arrAssets addObject:arr[0]];
            }
            
        }
        
        
        return arrAssets;
   
}


- (NSArray *)fetchConfigeration
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
    NSArray *response = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return response;
}


@end
