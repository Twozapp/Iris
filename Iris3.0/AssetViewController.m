//
//  AssetViewController.m
//  Iris3.0
//
//  Created by Priya on 01/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AssetViewController.h"
#import "OnDeck.h"
#import "HelpDesk.h"
#import "Asset.h"
#import "GatewayOverView.h"
#import "AppDelegate.h"
#import "AlertOverView.h"
#import "Configeration.h"

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE

@interface AssetViewController ()<UITableViewDelegate, UITableViewDataSource>{
  
    NSMutableArray *arrGroups;
    NSMutableArray *annotationList;
    NSArray *arrAlerts;
    GatewayOverView *selectedGateway;
    UISegmentedControl *reportSegment;
    CGFloat _scale;
    CGFloat defaultScale;
    CGPoint defaultPoint;

}
@property (weak, nonatomic) IBOutlet UITableView *tblAssets;

@end

@implementation AssetViewController
@synthesize arrAsset;
@synthesize selectedGroup;
@synthesize selectedIndex;
@synthesize configeration;
@synthesize track;
@synthesize selectedGateway;
@synthesize tabbarScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblGroups.hidden = YES;
    Configeration *config = (Configeration *)[self fetchConfigeration][0];
    [_segment removeAllSegments];
    
    [tabbarScrollView setContentSize:CGSizeMake(448, tabbarScrollView.frame.size.height)];
    if (isiPhone) {
        _viewGraph = [[UIView alloc] initWithFrame:CGRectMake(5, ([UIScreen mainScreen].bounds.size.height - 64 )/2 - 180, [UIScreen mainScreen].bounds.size.width-20, 360)];
        _viewGraph.backgroundColor = [UIColor blackColor];
        [self.viewReports addSubview:_viewGraph];
        
        _lblXAxis = [[UILabel alloc] initWithFrame:CGRectMake(_viewGraph.bounds.size.width/2-60, _viewGraph.frame.size.height - 25, 120, 21)];
        _lblXAxis.text = @"Time";
        _lblXAxis.textColor = [UIColor redColor];
        _lblXAxis.textAlignment = NSTextAlignmentCenter;
        [self.viewGraph addSubview:_lblXAxis];
        
        _lblYAxis = [[UILabel alloc] initWithFrame:CGRectMake(-45, _viewGraph.frame.size.height/2  , 120, 20)];
        _lblYAxis.text = @"Temperature";
        _lblYAxis.textColor = [UIColor redColor];
        _lblYAxis.textAlignment = NSTextAlignmentCenter;
        float   angle = - M_PI/2;  //rotate 180°, or 1 π radians
        _lblYAxis.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
        [self.viewGraph addSubview:_lblYAxis];
        
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [_segment setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
    }
    else
    {
        _viewGraph = [[UIView alloc] initWithFrame:CGRectMake(10, ([UIScreen mainScreen].bounds.size.height - 64 )/2 - 300, [UIScreen mainScreen].bounds.size.width-20, 600)];
        _viewGraph.backgroundColor = [UIColor blackColor];
        [self.viewReports addSubview:_viewGraph];
        
        _lblXAxis = [[UILabel alloc] initWithFrame:CGRectMake(_viewGraph.bounds.size.width/2-60, _viewGraph.frame.size.height - 35, 120, 21)];
        _lblXAxis.text = @"Time";
        _lblXAxis.textColor = [UIColor redColor];
        _lblXAxis.textAlignment = NSTextAlignmentCenter;
        [self.viewGraph addSubview:_lblXAxis];
        
        _lblYAxis = [[UILabel alloc] initWithFrame:CGRectMake(-40, _viewGraph.frame.size.height/2 , 120, 20)];
        _lblYAxis.text = @"Temperature";
        _lblYAxis.textColor = [UIColor redColor];
        _lblYAxis.textAlignment = NSTextAlignmentCenter;
        float   angle = - M_PI/2;  //rotate 180°, or 1 π radians
        _lblYAxis.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
        [self.viewGraph addSubview:_lblYAxis];
        
        UIFont *font = [UIFont systemFontOfSize:22.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [_segment setTitleTextAttributes:attributes
                                forState:UIControlStateNormal];
    }
    
    
    
    [_viewGraph.layer setMasksToBounds:YES];
    _viewGraph.layer.borderWidth = 1.0f;
    _viewGraph.layer.borderColor = [UIColor redColor].CGColor;
    
    if (config.dashboardSensorView.boolValue == NO) {
        reportSegment = [[UISegmentedControl alloc] initWithItems:@[@"Temperature", @"Speed"]];
        [reportSegment setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 130 , 20, 260, 30)];
        reportSegment.tintColor = [UIColor redColor];
        [reportSegment addTarget:self action:@selector(actionReportChange:) forControlEvents:UIControlEventValueChanged];
        [reportSegment setSelectedSegmentIndex:0];
        [_viewReports addSubview:reportSegment];
        
        
        if (isiPhone) {
            UIFont *font = [UIFont systemFontOfSize:22.0f];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:NSFontAttributeName];
            [reportSegment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
        }
        else
        {
            UIFont *font = [UIFont systemFontOfSize:22.0f];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:NSFontAttributeName];
            [reportSegment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
        }
        

    }
    
    if (config.mapView.boolValue == YES) {
        NSArray *arr = @[@"Track", @"Report", @"Alerts"];
        for (int i = 0; i < arr.count ; i++){
            [_segment insertSegmentWithTitle:[NSString stringWithFormat:@"%@",arr[i]] atIndex:i animated:NO];
        }
        float height;
        if (isiPhone) {
            height = 190;
            
        }
        else
        {
            height = 270;
        }
        
        
        
        
        _hghtCollection.constant = height;
        annotationList = [[NSMutableArray alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setMapType:MKMapTypeStandard];
        [_mapView setZoomEnabled:YES];
        [_mapView setScrollEnabled:YES];
        
        for (GatewayOverView *overView in arrAsset) {
            
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(overView.lat.doubleValue, overView.lon.doubleValue);
            NSLog(@"lat = %f and lon = %f",overView.lat.doubleValue, overView.lon.doubleValue);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = coord1;
            annotation.title = overView.assetname;
            annotation.accessibilityValue = overView.assetid;
            
            [annotationList addObject:annotation];
        }
        selectedGateway = arrAsset[0];
        [self.mapView addAnnotations:annotationList];
        
        GatewayOverView *ovrView = arrAsset[0];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(ovrView.lat.doubleValue, ovrView.lon.doubleValue);
        
        MKCoordinateSpan span = MKCoordinateSpanMake(10.0, 10.0);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region];
        _viewMap.hidden = NO;
        _tableViewAsset.hidden = YES;
        _viewReports.hidden = YES;
        
    }
    else
    {
        
        NSArray *arr = @[@"Report", @"Alerts"];
        for (int i = 0; i < arr.count ; i++){
            [_segment insertSegmentWithTitle:[NSString stringWithFormat:@"%@",arr[i]] atIndex:i animated:NO];
        }
        _viewMap.hidden = YES;
        _tableViewAsset.hidden = YES;
        _viewReports.hidden = NO;
        [self configUI];
    }
    
    
    if (selectedIndex == 0) {
        _lblAssetTitle.text = @"All Assets";
    }
    else
    {
        _lblAssetTitle.text = selectedGroup.groupname;
    }
    //_tblAssets.hidden = YES;
    _segment.selectedSegmentIndex = 0;
    
     arrAlerts = [self fetchAlertForGateway];
    
    
    
    
    _segment.layer.cornerRadius = 15.0f;
    _segment.layer.masksToBounds = YES;
    
    arrGroups = [[NSMutableArray alloc] init];
    [arrGroups addObject:@"All Assets"];
    [arrGroups addObjectsFromArray:[self fetchGroups]];
    [_tblGroups reloadData];
    // Do any additional setup after loading the view.
    _tableViewAsset.tableFooterView = [[UIView alloc] init];
   // arrAsset = [[NSMutableArray alloc] init];
    
    //[self performSelector:@selector(requestAsset) withObject:nil afterDelay:0.25];
    
    if ([track isEqualToString:@"report"] ) {
        if (config.mapView.boolValue == YES) {
            _segment.selectedSegmentIndex = 1;
                _viewMap.hidden = YES;
                _tableViewAsset.hidden = YES;
                _viewReports.hidden = NO;
                [self configUI];
            
        }
        else
        {
            _segment.selectedSegmentIndex = 0;
                //[_viewMap bringSubviewToFront:_tableViewAlert];
                _viewMap.hidden = YES;
                _tableViewAsset.hidden = YES;
                _viewReports.hidden = NO;
                [self configUI];
            
        }
        
    }
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
    
}


- (void)viewWillAppear:(BOOL)animated
{
    Configeration *conf = (Configeration *)[self fetchConfigeration][0];
    if ([conf.dashboardSensorView isEqualToNumber:[NSNumber numberWithBool:false]]) {
        _assetHeader.text = [NSString stringWithFormat:@"%@ & Alert Time",conf.gatewayname];
    }
    else
    {
        _assetHeader.text = [NSString stringWithFormat:@"%@ & Alert Time",conf.nodename];
    }
}

-(void)addButtons {
    
    for(int i =1;i<=7;i++) {
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i-1)*64, 0, 64, tabbarScrollView.frame.size.height);
        btn.backgroundColor = [UIColor blackColor];
        btn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.tag = i;
        
        switch (btn.tag) {
            case 1:
                [btn setTitle:@"Tab-1" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:[NSString stringWithFormat:@"Tab-2"] forState:UIControlStateNormal];
                break;
            case 3:
                [btn setTitle:[NSString stringWithFormat:@"Tab-3"] forState:UIControlStateNormal];
                break;
            case 4:
                [btn setTitle:[NSString stringWithFormat:@"Tab-4"] forState:UIControlStateNormal];
                break;
            case 5:
                [btn setTitle:[NSString stringWithFormat:@"Tab-5"] forState:UIControlStateNormal];
                break;
            case 6:
                [btn setTitle:[NSString stringWithFormat:@"Tab-6"] forState:UIControlStateNormal];
                break;
            case 7:
                [btn setTitle:[NSString stringWithFormat:@"Tab-7"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [tabbarScrollView addSubview:btn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
/*
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

*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableViewAsset) {
        return arrAlerts.count;
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
        
        //btnStatus.titleLabel.text = @"Fault";
        
        
        btnStatus.layer.cornerRadius = 12.0f;
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
/*
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
    lblTitle.text = gateway.assetname;
    lblAddress.text = gateway.address;
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
*/
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
                
                for (GatewayOverView *overView in arrAsset) {
                    
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(overView.lat.doubleValue, overView.lon.doubleValue);
                   
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    [annotation setCoordinate:coord];
                    annotation.title = overView.assetid;
                    
                    [annotationList addObject:annotation];
                }
                
                 [self.mapView addAnnotations:annotationList];
                GatewayOverView *ovrView = arrAsset[0];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(ovrView.lat.doubleValue, ovrView.lon.doubleValue);
                
                MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
                MKCoordinateRegion region = {coord, span};
                [self.mapView setRegion:region];
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

- (IBAction)actionSegmant:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    Configeration *config = (Configeration *)[self fetchConfigeration][0];
    
    if (config.mapView.boolValue == YES) {
    if (segment.selectedSegmentIndex == 0) {
        //[_viewMap bringSubviewToFront:_tableViewAlert];
        _viewMap.hidden = NO;
        _tableViewAsset.hidden = YES;
        _viewReports.hidden = YES;
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        _viewMap.hidden = YES;
        _tableViewAsset.hidden = YES;
        _viewReports.hidden = NO;
        [self configUI];
    }
    else
    {
        //[_tableViewAlert bringSubviewToFront:_viewMap];
        _viewMap.hidden = YES;
        arrAlerts = [self fetchAlertForGateway];
        _tableViewAsset.hidden = NO;
        [_tableViewAsset reloadData];
        _viewReports.hidden = YES;
    }
    }
    else
    {
        if (segment.selectedSegmentIndex == 0) {
            //[_viewMap bringSubviewToFront:_tableViewAlert];
            _viewMap.hidden = YES;
            _tableViewAsset.hidden = YES;
            _viewReports.hidden = NO;
            [self configUI];
        }
        else if (segment.selectedSegmentIndex == 1)
        {
            _viewMap.hidden = YES;
            _tableViewAsset.hidden = NO;
            _viewReports.hidden = YES;
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrAsset.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    
    float height;
    if (isiPhone) {
        height = 190;
        
    }
    else
    {
        height = 270;
    }

        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    GatewayOverView *overview = (GatewayOverView *)arrAsset[indexPath.row];
    
    UIView *view1 = (UIView *)[cell viewWithTag:10];
    UIView *view2 = (UIView *)[cell viewWithTag:20];
    UIView *view3 = (UIView *)[cell viewWithTag:30];
    UIView *view4 = (UIView *)[cell viewWithTag:40];
    UIView *view5 = (UIView *)[cell viewWithTag:50];
    UIView *view6 = (UIView *)[cell viewWithTag:60];
    
    UILabel *lbl1 = (UILabel *)[view1 viewWithTag:3];
    UILabel *lbl2 = (UILabel *)[view2 viewWithTag:3];
    UILabel *lbl3 = (UILabel *)[view3 viewWithTag:3];
    UILabel *lbl4 = (UILabel *)[view4 viewWithTag:3];
    UILabel *lbl5 = (UILabel *)[view5 viewWithTag:3];
    UILabel *lbl6 = (UILabel *)[view6 viewWithTag:3];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:100];
    
    lblTitle.text = overview.assetname;
    lbl1.text = overview.light;
    lbl2.text = [NSString stringWithFormat:@"%@°C",overview.temperature];
    lbl3.text = overview.pressure;
    if (overview.lon.length > 0) {
       lbl4.text = @"Valid";
    }
    else
    {
        lbl4.text = @"Invalid";
    }
    
    //lbl5.text = [NSString stringWithFormat:@"%@°C",overview.humidity];
    lbl5.text = overview.humidity;
    
    /*
     MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
     annotationPoint.coordinate = CLLocationCoordinate2DMake(overview.lat.doubleValue, overview.lon.doubleValue);
     
     
     //[annotationList addObject:annotationPoint];
     
     //[self.mapView addAnnotations:annotationList];
     //[self gotoDefaultLocation];
     */
    
    
    
    
    return cell;
}

- (void)gotoDefaultLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    if (arrAsset.count > 0) {
        GatewayOverView *overView = arrAsset[0];
        float lat = [overView.lat floatValue];
        float lon = [overView.lat floatValue];
        newRegion.center.latitude = lat;
        newRegion.center.longitude = lon;
        newRegion.span.latitudeDelta = 10.0;
        newRegion.span.longitudeDelta = 10.0;
        
        [self.mapView setRegion:newRegion animated:YES];
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:AnnotationViewID];
    }
    MKPointAnnotation *ann = (MKPointAnnotation *)annotation;
    annotationView.accessibilityValue = ann.accessibilityValue;
    annotationView.enabled = YES;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"map_pin"];//mycustom image
    annotationView.annotation = annotation;
    
    return annotationView;
}
- (MKAnnotationView *)annotaionView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"map_pin"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSString *assetid = [view accessibilityValue];
    view.enabled = YES;
    view.userInteractionEnabled = YES;
    [mapView deselectAnnotation:view animated:YES];
    NSInteger index = [arrAsset indexOfObject:[self getGatewayOverviewFromArraywithassetID:assetid]];
    selectedGateway = [self getGatewayOverviewFromArraywithassetID:assetid];
    [_collectionAssets scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    
}

- (NSArray *)fetchAlertForGateway
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AlertOverView"];
    request.predicate = [NSPredicate predicateWithFormat:@"gatewayid == %@",selectedGateway.assetid];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    return arr;
}

- (NSArray *)fetchConfigeration
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
        NSArray *response = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
        
        return response;
    }


- (GatewayOverView *)getGatewayOverviewFromArraywithassetID:(NSString *)astID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetid == %@",astID];
    NSArray *reponse = [arrAsset filteredArrayUsingPredicate:predicate];
    return (GatewayOverView *)reponse[0];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    *targetContentOffset = scrollView.contentOffset; // set acceleration to 0.0
    float pageWidth = (float)self.collectionAssets.bounds.size.width;
    int minSpace = 5;
    
    int cellToSwipe = (scrollView.contentOffset.x)/(pageWidth + minSpace) + 0.5; // cell width + min spacing for lines
    if (cellToSwipe < 0) {
        cellToSwipe = 0;
    } else if (cellToSwipe >= self.arrAsset.count) {
        cellToSwipe = self.arrAsset.count - 1;
    }
    GatewayOverView *ovrView = arrAsset[cellToSwipe];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(ovrView.lat.doubleValue, ovrView.lon.doubleValue);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(10.0, 10.0);
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    [_collectionAssets scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellToSwipe inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    selectedGateway = ovrView;
}

#pragma mark - Graph

- (void)configUI
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    if (isiPhone) {
        chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(25, 0, [UIScreen mainScreen].bounds.size.width-35, 330)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
        [chartView showInView:self.viewGraph];
    }
    else
    {
        chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width-50, 560)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
        [chartView showInView:self.viewGraph];
    }
    
    
    if (reportSegment.selectedSegmentIndex==0) {
      _lblYAxis.text = @"Temperature";
    }
    else
    {
      _lblYAxis.text = @"Speed";
    }
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    
    [chartView addGestureRecognizer:twoFingerPinch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    tap.numberOfTapsRequired = 2;
    
    [_viewGraph addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;  // In order to discard dragging when pinching
    [chartView addGestureRecognizer:panGesture];
    defaultPoint = CGPointMake(chartView.frame.origin.x, chartView.frame.origin.y);
    defaultScale = twoFingerPinch.scale;
    
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return @[@"1",@"2",@"3",@"4",@"5"];
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    if (reportSegment.selectedSegmentIndex==0) {
        NSMutableArray *yarray = [[NSMutableArray alloc] init];
        for (GatewayOverView *gatway in arrAsset) {
            NSArray *ary = @[gatway.temperature,gatway.temperature,gatway.temperature, gatway.temperature, gatway.temperature];
            [yarray addObject:ary];
        }
        
        
        
        
        return yarray;
    }
    else
    {
        NSMutableArray *yarray = [[NSMutableArray alloc] init];
        for (GatewayOverView *gatway in arrAsset) {
            NSArray *ary = @[gatway.speed,gatway.speed,gatway.speed, gatway.speed, gatway.speed];
            [yarray addObject:ary];
        }
        
        
        
        return yarray;
    }
    
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    NSMutableArray *yarray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrAsset.count; i ++) {
        [yarray addObject:[self randomColor]];
    }
    return yarray;
}

- (UIColor *)randomColor
{
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    return randColor;
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
        if (reportSegment.selectedSegmentIndex==0) {
    return CGRangeMake(100, 10);
        }
    //    if (path.row==2) {
    //        return CGRangeMake(100, 0);
    //    }
     return CGRangeMake(400, 0);
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    //    if (path.row==2) {
    //     return CGRangeMake(25, 75);
    //    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

- (IBAction)actionReportChange:(id)sender
{
    
    [self configUI];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    _scale = recognizer.scale;
    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, _scale, _scale);
    chartView.transform = tr;
}

- (void)actionTap:(UITapGestureRecognizer *)recognizer
{
    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, defaultScale, defaultScale);
    chartView.transform = tr;
    
    chartView.frame = CGRectMake(defaultPoint.x, defaultPoint.y, chartView.frame.size.width, chartView.frame.size.height);
    
    //[recognizer setTranslation:CGPointMake(0, 0) inView:sender.view];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// On dragging gesture put map in free mode
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    //if (sender.state == UIGestureRecognizerStateBegan) [self setMapInFreeModePushedBy:sender];
    CGPoint translation = [sender translationInView:sender.view];
    
    sender.view.center=CGPointMake(sender.view.center.x+translation.x, sender.view.center.y+ translation.y);
    
    [sender setTranslation:CGPointMake(0, 0) inView:sender.view];
}

-(void)buttonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
   // NSLog(@"Tab bar %d is clicked",btn.tag);
    [self tabCall:btn.tag];
}

-(void)tabCall:(NSInteger)tag {
    switch (tag) {
            
        case 1:
            
           // [self.view addSubview:self.navFirstTab.view];
            break;
            
        case 2:
            //[self.view addSubview:self.navSecondTab.view];
            break;
            
        case 3:
            //[self.view addSubview:self.navThirdTab.view];
            break;
            
        case 4:
            //[self.view addSubview:self.navFourthTab.view];
            break;
            
        case 5:
            //[self.view addSubview:self.navFifthTab.view];
            break;
            
        case 6:
            //[self.view addSubview:self.navSixthTab.view];
            break;
            
        case 7:
            //[self.view addSubview:self.navSeventhTab.view];
            break;
            
        default:
            break;
    }
}
@end
