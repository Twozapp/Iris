//
//  DashboardViewController.m
//  Iris3.0
//
//  Created by Priya on 29/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import "DashboardViewController.h"
#import "SWRevealViewController.h"
#import "DashBoardNavigationBar.h"
#import "WebServices.h"
#import "HelpDesk.h"
#import "OnDeck.h"
#import "AppDelegate.h"
#import "Group.h"
#import "GroupSummary.h"
#import "AlertSummary.h"
#import "GatewayOverView.h"
#import "AssetViewController.h"
#import "AlertOverView.h"
#import "AlertViewController.h"
#import <CoreData/CoreData.h>
#import "AsssetLaunchViewController.h"
#import "Configeration.h"
#import "Node.h"
#import "AssetsNotReportingViewController.h"
#import "AssetsReportingViewController.h"

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE

@interface DashboardViewController ()<SWRevealViewControllerDelegate>
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation DashboardViewController
{
    int noofassets;
    int noofNWasset;
    int noofWasset;
    int noofAlerts;
    NSMutableArray *arrGroups;
    NSInteger selectedIndex;
    Group *selectedGroup;
    NSDictionary *configeration;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arrGroups = [[NSMutableArray alloc] init];
    selectedIndex = 0;
    _tblView.tableFooterView = [[UIView alloc] init];
    [self getCompanyConfig];
    //[self getGroupDetails];
    //[self setNeedsStatusBarAppearanceUpdate];

    
    
    _tblView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOverallAssets) name:@"updateAssets" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOverallAlert) name:@"updateAlert" object:nil];
    
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.delegate = self;
    if ( revealViewController )
    {
        [self.menuBarButton setTarget: self.revealViewController];
        [self.menuBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    _ImageViewAllGroups.layer.cornerRadius = 25.0f;
    [_ImageViewAllGroups.layer setMasksToBounds:YES];
    _viewAllRecord.layer.cornerRadius = 10.0f;
    _viewAssets.layer.cornerRadius = 10.0f;
    _viewRecording.layer.cornerRadius = 10.0f;
    _viewReporting.layer.cornerRadius = 10.0f;
    _viewAlerts.layer.cornerRadius = 10.0f;
    
    //[self performSelector:@selector(requestAssetGateWay) withObject:nil afterDelay:0.26];
    //[self performSelector:@selector(requestAlertGateWay) withObject:nil afterDelay:0.26];

}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Dashboard";
    
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
    
//    _lblAlert.text = [OnDeck sharedInstance].strAlert;
//    _lblAsset.text = [OnDeck sharedInstance].strAsset;
//    _lblAssetReporing.text = [OnDeck sharedInstance].strReporting;
//    _lblAssetNotReporting.text = [OnDeck sharedInstance].strNotReporting;
}


- (void)viewWillDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionViewAllReport:(id)sender {
    [self performSegueWithIdentifier:@"toRecords" sender:nil];

}

- (IBAction)actionButton:(id)sender {
    
    
    
    
}

- (IBAction)actionAllGroups:(id)sender {
    
    _tblView.hidden = !_tblView.hidden;
}

- (IBAction)actionAsset:(id)sender {
    
    [self performSegueWithIdentifier:@"toAssetLaunch" sender:nil];
    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    AssetViewController *alertView = (AssetViewController *)[story instantiateViewControllerWithIdentifier:@"AssetViewController"];
//    alertView.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssets]];
//    [self.navigationController pushViewController:alertView animated:YES];
}

- (IBAction)actionReporting:(id)sender {
    
    [self performSegueWithIdentifier:@"toassetsreporting" sender:nil];
    
}

- (IBAction)actionRecording:(id)sender {
    [self performSegueWithIdentifier:@"toassetsnotreporting" sender:nil];
}

- (IBAction)actionAlert:(id)sender {
    
    AlertViewController *alertView = (AlertViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
    alertView.arrAlerts = [[NSMutableArray alloc] initWithArray:[self fetchAlerts]];
    alertView.selectedGroup = selectedGroup;
    alertView.selectedIndex = selectedIndex;
    alertView.configeration = configeration;

    [self.navigationController pushViewController:alertView animated:YES];
    
}

- (IBAction)actionMenu:(id)sender{
   }

- (IBAction)actionCreate:(id)sender
{
    
}

- (IBAction)actionSearch:(id)sender
{
    
}

- (void)requestAssetGateWay{
    if ([HelpDesk sharedInstance].isInternetAvailable) {
        
        NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
       
        [WebServices sharedInstance].webRequestMode = (WebRequestMode *)WEB_REQUEST_ASSET_OVERVIEW;
        [[WebServices sharedInstance] composeWebRequestFromArguments:arguments forWebRequestMode:[WebServices sharedInstance].webRequestMode responseWithStatus:^(NSMutableArray *status){
            
            NSString * message = [status objectAtIndex:0];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([message compare:@"Success"] == NSOrderedSame) {
                
                _lblAlert.text = [OnDeck sharedInstance].strAsset;
                _lblAssetReporing.text = [OnDeck sharedInstance].strReporting;
                _lblAssetNotReporting.text = [OnDeck sharedInstance].strNotReporting;
                
                [self setNeedsFocusUpdate];
                
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


- (void)getGroupDetails
{
    __block NSData *dataFromServer = nil;
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet connection Available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        } else {

        [self requestGetGroup];
        }
    }];
    
    NSBlockOperation *saveToDataBaseOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakSaveToDataBaseOperation = saveToDataBaseOperation;
    
    [weakSaveToDataBaseOperation addExecutionBlock:^{
        [self getOverallAssets];
    }];
    
    [saveToDataBaseOperation addDependency:downloadOperation];
    
    [[NSOperationQueue mainQueue] addOperation:saveToDataBaseOperation];
    [[NSOperationQueue mainQueue] addOperation:downloadOperation];
}

- (void)getGroupDetailsForNodes
{
    __block NSData *dataFromServer = nil;
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet connection Available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        } else {
        [self requestGetGroupForNode];
        }
    }];
    
    NSBlockOperation *saveToDataBaseOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakSaveToDataBaseOperation = saveToDataBaseOperation;
    
    [weakSaveToDataBaseOperation addExecutionBlock:^{
        [self getOverallAssets];
    }];
    
    [saveToDataBaseOperation addDependency:downloadOperation];
    
    [[NSOperationQueue mainQueue] addOperation:saveToDataBaseOperation];
    [[NSOperationQueue mainQueue] addOperation:downloadOperation];
}


- (void)getCompanyConfig
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * urlString = [NSString stringWithFormat:@"%@companyconfig/%@",baseURL,[defaults stringForKey:@"authKey"]];
    NSURL * url = [NSURL URLWithString: urlString];
    NSLog(@"urlString = %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary * dictionary = nil;
         
         
         if([data length] >= 1) {
             dictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
             
             
             if ([dictionary[@"response"][@"Status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                 
                 NSArray *configs = [self fetchAlerts];
                 for (Configeration *conf in configs) {
                     [[[self appDelegate] managedObjectContext] deleteObject:conf];
                     [self saveManageObject];
                 }
                 
                 configeration = dictionary[@"response"][@"company config"];
                 
                 Configeration *config = (Configeration *)[NSEntityDescription insertNewObjectForEntityForName:@"Configeration"
                                                                                        inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                 config.dashboardSensorView = configeration[@"dashboardSensorView"];
                 config.gatewayname = configeration[@"gatewayname"];
                 config.humidityunit = configeration[@"humidityunit"];
                 config.configid =  [NSString stringWithFormat:@"%@",configeration[@"id"]];
                 config.incursionenable = [NSNumber numberWithInt:[configeration[@"incursionenable"] intValue]];
                 config.lightunit = configeration[@"lightunit"];
                 config.mapView = [NSNumber numberWithInt:[configeration[@"mapView"] intValue]];
                 config.memstype = configeration[@"memstype"];
                 config.moistureunit = configeration[@"moistureunit"];
                 config.nodename = configeration[@"nodename"];
                 config.panic_tamper = configeration[@"panic_tamper"];
                 config.pressureunit = configeration[@"pressureunit"];
                 config.realtimemonitor = [NSNumber numberWithInt:[configeration[@"realtimemonitor"] intValue]];
                 config.speedunit = configeration[@"speedunit"];
                 config.temperatureunit = configeration[@"temperatureunit"];
                 config.vgroupname = configeration[@"vgroupname"];
                 config.vsubgroupname = configeration[@"vsubgroupname"];
                 config.wirelessSensorView = [NSNumber numberWithInt:[configeration[@"wirelessSensorView"] intValue]];
                 
                 [self saveManageObject];
                 
                 
                 

                 if ([configeration[@"dashboardSensorView"] isEqualToNumber:[NSNumber numberWithBool:false]]) {
                     _lblAssetsHeader.text = [config.gatewayname capitalizedString];
                     _lblReportingHeader.text = [NSString stringWithFormat:@"%@ Reporting",[config.gatewayname capitalizedString]];
                     _lblNotReporting.text = [NSString stringWithFormat:@"%@ not Reporting",[config.gatewayname capitalizedString]];
                     [self.view setNeedsDisplay];
                     [self getGroupDetails];
                 }
                 else
                 {
                     _lblAssetsHeader.text = [config.nodename capitalizedString];
                     _lblReportingHeader.text = [NSString stringWithFormat:@"%@ Reporting",[config.nodename capitalizedString]];
                     _lblNotReporting.text = [NSString stringWithFormat:@"%@ not Reporting",[config.nodename capitalizedString]];
                     [self.view setNeedsDisplay];
                     [self getGroupDetailsForNodes];
                 }
                 
             }
             NSLog(@"response = %@",dictionary);
             
         }
     }];
    
}

- (void)requestGetGroup
{
    // for getting Group
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * urlString = [NSString stringWithFormat:@"%@group/%@?groupid",baseURL,[defaults stringForKey:@"authKey"]];
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSDictionary * dictionary = nil;
         
         
         if([data length] >= 1) {
             dictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
         }
         
         if(dictionary != nil) {
          
             if ([dictionary[@"response"][@"Msg"] isEqualToString:@"Success"]) {
                 
                 if ([dictionary[@"response"][@"groups"] count] > 0) {
                     NSArray *groups = dictionary[@"response"][@"groups"];
                     
                     for (NSDictionary *dict in groups) {
                         
                         if ([[self isGroupExist:dict[@"id"]] count] == 0) {
                             Group *group = (Group *)[NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                             group.groupid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             group.groupname = dict[@"name"];
                             [self saveManageObject];
                             [arrGroups removeAllObjects];
                             [arrGroups addObject:@"All"];
                             [arrGroups addObjectsFromArray:[self fetchGroups]];
                             [_tblView reloadData];
                             _tblViewHeight.constant = 44 * arrGroups.count;
                             
                             // for getting Gateway Overview
                             
                             NSString * urlString = [NSString stringWithFormat:@"%@gatewayoverview/%@?groupid=%@&subgroupid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * url = [NSURL URLWithString: urlString];
                             
                             NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
                             request1.HTTPMethod = @"GET";
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request1 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request1.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request1
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                              {
                                  
                                  NSDictionary * grpOverview = nil;
                                  
                                  
                                  if([data1 length] >= 1) {
                                      grpOverview = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
                                      
                                      if(grpOverview != nil) {
                                          
                                          if ([grpOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request1.accessibilityValue][0];
                                              
                                              grp.overview = nil;
                                              GroupSummary *smry = (GroupSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupSummary"
                                                                                                    inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.noofasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"gatewayCnt"]];
                                              smry.noofNWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"nwgatewayCnt"]];
                                              smry.noofWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"wgatewayCnt"]];
                                              
                                              grp.overview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAssets" object:nil];
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                             // for getting Alert Overview
                             
                             NSString * urlAlertString = [NSString stringWithFormat:@"%@alertoverview/%@?groupid=%@&subgroupid=&assetid",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlert = [NSURL URLWithString: urlAlertString];
                             
                             NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: urlAlert];
                             request2.HTTPMethod = @"GET";
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request2 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request2.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request2
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data2, NSError *error)
                              {
                                  
                                  NSDictionary * alertOverview = nil;
                                  
                                  
                                  if([data2 length] >= 1) {
                                      alertOverview = [NSJSONSerialization JSONObjectWithData:data2 options: 0 error: nil];
                                      
                                      if(alertOverview != nil) {
                                          
                                          if ([alertOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request2.accessibilityValue][0];
                                              
                                              
                                              
                                              grp.alertoverview = nil;
                                              AlertSummary *smry = (AlertSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.alertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"alertCnt"]];
                                              smry.attentionAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"attentionAlertCnt"]];
                                              smry.criticalALertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"criticalALertCnt"]];
                                              smry.faultAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"faultAlertCnt"]];
                                              
                                              grp.alertoverview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlert" object:nil];
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             // for getting Gateway Summary
                             
                             NSString * urlGatewayString = [NSString stringWithFormat:@"%@gatewaysummary/%@?groupid=%@&subgroupid=&assetgroupid=&gatewayid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlGateway = [NSURL URLWithString: urlGatewayString];
                             
                             NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] initWithURL: urlGateway];
                             request3.HTTPMethod = @"GET";
                             [request3 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request3 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request3 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request3.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request3
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data3, NSError *error)
                              {
                                  
                                  NSDictionary * gatewayOverview = nil;
                                  
                                  
                                  if([data3 length] >= 1) {
                                      gatewayOverview = [NSJSONSerialization JSONObjectWithData:data3 options: 0 error: nil];
                                      
                                      if(gatewayOverview != nil) {
                                          
                                          if ([gatewayOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request3.accessibilityValue][0];
                                              
                                              NSArray *lastGateways = gatewayOverview[@"response"][@"lastgatewayreport"];
                                              
                                              if (lastGateways.count > 0) {
                                                  for (NSDictionary *dict in lastGateways) {
                                                      
                                                      
                                                      if ([[self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]] count] == 0) {
                                                          GatewayOverView *gateway = (GatewayOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"GatewayOverView"
                                                                                                                             inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          gateway.address = [NSString stringWithFormat:@"%@",dict[@"address"]];
                                                          gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                          gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                          gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                          gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                          gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                          gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                          gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                          gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                          gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                          gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                          gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                          gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                          gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
                                                          gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
                                                          gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
                                                          gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
                                                          gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                          
                                                          
                                                          
                                                          [grp addGatewayoverviewObject:gateway];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          GatewayOverView *gateway = [self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]][0];
                                                          
                                                          gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                          gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                          gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                          gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                          gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                          gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                          gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                          gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                          gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                          gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                          gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                          gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                          gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
                                                          gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
                                                          gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
                                                          gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
                                                          
                                                          gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                          
                                                          [self saveManageObject];
                                                      }
                                                  }
                                              }
                                              
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             // for getting Alert Summary
                             
                             NSString * urlAlertSummaryString = [NSString stringWithFormat:@"%@alert/%@?groupid=%@&subgroupid=&alerttypeid=&gatewayid",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlertSummary = [NSURL URLWithString: urlAlertSummaryString];
                             
                             NSMutableURLRequest *request4 = [[NSMutableURLRequest alloc] initWithURL: urlAlertSummary];
                             request4.HTTPMethod = @"GET";
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request4 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request4.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request4
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response3, NSData *data4, NSError *error)
                              {
                                  
                                  NSDictionary * alertSummary = nil;
                                  
                                  
                                  if([data4 length] >= 1) {
                                      alertSummary = [NSJSONSerialization JSONObjectWithData:data4 options: 0 error: nil];
                                      
                                      if(alertSummary != nil) {
                                          
                                          if ([alertSummary[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request4.accessibilityValue][0];
                                              
                                              NSArray *arrAlerts = alertSummary[@"response"][@"Alters"];
                                              
                                              if (arrAlerts.count > 0) {
                                                  for (NSDictionary *dict in arrAlerts) {
                                                      if ([[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]] count] == 0) {
                                                          
                                                          AlertOverView *overView = (AlertOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertOverView"
                                                                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [grp addAlertsummaryObject:overView];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                  else
                                                  {
                                                      AlertOverView *overView = (AlertOverView *)[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]][0];
                                                      
                                                      overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                      overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                      overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                      overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                      overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                      overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                      overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                      overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                      overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                      overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                      overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                      overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                      overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                      overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                      overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                      overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                      overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                      overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                      overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                      overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                      overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                      overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                      
                                                      [self saveManageObject];
                                                      
                                                  }}}


                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                         }
                         else
                         {
                            
                             [arrGroups removeAllObjects];
                             [arrGroups addObject:@"All"];
                             [arrGroups addObjectsFromArray:[self fetchGroups]];
                             [_tblView reloadData];
                             _tblViewHeight.constant = 44 * arrGroups.count;
                             
                             // for getting Gateway Overview
                             
                             NSString * urlString = [NSString stringWithFormat:@"%@gatewayoverview/%@?groupid=%@&subgroupid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * url = [NSURL URLWithString: urlString];
                             
                             NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
                             request1.HTTPMethod = @"GET";
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request1 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request1.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request1
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                              {
                                  
                                  NSDictionary * grpOverview = nil;
                                  
                                  
                                  if([data1 length] >= 1) {
                                      grpOverview = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
                                      
                                      if(grpOverview != nil) {
                                          
                                          if ([grpOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request1.accessibilityValue][0];
                                              
                                              grp.overview = nil;
                                              GroupSummary *smry = (GroupSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.noofasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"gatewayCnt"]];
                                              smry.noofNWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"nwgatewayCnt"]];
                                              smry.noofWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"gatewayoverview"][@"wgatewayCnt"]];
                                              
                                              grp.overview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAssets" object:nil];
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                             
                             // for getting Alert Overview
                             
                             NSString * urlAlertString = [NSString stringWithFormat:@"%@alertoverview/%@?groupid=%@&subgroupid=&assetid",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlert = [NSURL URLWithString: urlAlertString];
                             
                             NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: urlAlert];
                             request2.HTTPMethod = @"GET";
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request2 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request2.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request2
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data2, NSError *error)
                              {
                                  
                                  NSDictionary * alertOverview = nil;
                                  
                                  
                                  if([data2 length] >= 1) {
                                      alertOverview = [NSJSONSerialization JSONObjectWithData:data2 options: 0 error: nil];
                                      
                                      if(alertOverview != nil) {
                                          
                                          if ([alertOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request2.accessibilityValue][0];
                                              
                                              
                                              
                                              grp.alertoverview = nil;
                                              AlertSummary *smry = (AlertSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.alertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"alertCnt"]];
                                              smry.attentionAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"attentionAlertCnt"]];
                                              smry.criticalALertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"criticalALertCnt"]];
                                              smry.faultAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"faultAlertCnt"]];
                                              
                                              grp.alertoverview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlert" object:nil];
                                              
                                          }
                                      }
                                  }
                                  
                              }];

                             // for getting Gateway Summary
                             
                             NSString * urlGatewayString = [NSString stringWithFormat:@"%@gatewaysummary/%@?groupid=%@&subgroupid=&assetgroupid=&gatewayid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlGateway = [NSURL URLWithString: urlGatewayString];
                             
                             NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] initWithURL: urlGateway];
                             request3.HTTPMethod = @"GET";
                             [request3 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request3 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request3 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request3.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request3
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data3, NSError *error)
                              {
                                  
                                  NSDictionary * gatewayOverview = nil;
                                  
                                  
                                  if([data3 length] >= 1) {
                                      gatewayOverview = [NSJSONSerialization JSONObjectWithData:data3 options: 0 error: nil];
                                      
                                      if(gatewayOverview != nil) {
                                          
                                          if ([gatewayOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request2.accessibilityValue][0];
                                              
                                              NSArray *lastGateways = gatewayOverview[@"response"][@"lastgatewayreport"];
                                              
                                              if (lastGateways.count > 0) {
                                                  for (NSDictionary *dict in lastGateways) {
                                                      if ([[self checkGatewayExistinGroup:grp withAssetID:[NSString stringWithFormat:@"%@",dict[@"assetid"]]] count] == 0) {
                                                          GatewayOverView *gateway = (GatewayOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"GatewayOverView"
                                                                                                                                      inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                          gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                          gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                          gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                          gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                          gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                          gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                          gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                          gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                          gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                          gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                          gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                          gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                          gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
                                                          gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
                                                          gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
                                                          gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
                                                          gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          gateway.type = @"asset";
                                                          [grp addGatewayoverviewObject:gateway];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          GatewayOverView *gateway = [self checkGatewayExistinGroup:grp withAssetID:[NSString stringWithFormat:@"%@",dict[@"assetid"]]][0];
                                                          gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                          gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                          gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                          gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                          gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                          gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                          gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                          gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                          gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                          gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                          gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                          gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                          gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                          gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
                                                          gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
                                                          gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
                                                          gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
                                                          gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          gateway.type = @"asset";
                                                          [self saveManageObject];
                                                      }
                                                  }
                                              }
                                              
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                             // for getting Alert Details
                             
                             NSString * urlAlertSummaryString = [NSString stringWithFormat:@"%@alert/%@?groupid=%@&subgroupid=&alerttypeid=&gatewayid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlertSummary = [NSURL URLWithString: urlAlertSummaryString];
                             
                             NSMutableURLRequest *request4 = [[NSMutableURLRequest alloc] initWithURL: urlAlertSummary];
                             request4.HTTPMethod = @"GET";
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request4 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request4.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request4
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response3, NSData *data4, NSError *error)
                              {
                                  
                                  NSDictionary * alertSummary = nil;
                                  
                                  
                                  if([data4 length] >= 1) {
                                      alertSummary = [NSJSONSerialization JSONObjectWithData:data4 options: 0 error: nil];
                                      
                                      if(alertSummary != nil) {
                                          
                                          if ([alertSummary[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request4.accessibilityValue][0];
                                              
                                              NSArray *arrAlerts = alertSummary[@"response"][@"Alters"];
                                              
                                              if (arrAlerts.count > 0) {
                                                  for (NSDictionary *dict in arrAlerts) {
                                                      if ([[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]] count] == 0) {
                                                          
                                                          AlertOverView *overView = (AlertOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertOverView"
                                                                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [grp addAlertsummaryObject:overView];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          AlertOverView *overView = (AlertOverView *)[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]][0];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [self saveManageObject];
                                                          
                                                      }}}
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                         }
                     }
                     
                 }
                 
             }
             
             
         }
         
         
        
         
     }];
    
   
    
}

- (BOOL)checkNodeExist:(NSString *)nodeId ingroup:(Group *)group
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nodeid == %@",nodeId];
    NSArray *arrNode = [group.nodes.allObjects filteredArrayUsingPredicate:predicate];
    
    if (arrNode.count > 0) {
        return YES;
    }
    return NO;
}

- (void)requestGetGroupForNode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * urlString = [NSString stringWithFormat:@"%@group/%@?groupid",baseURL,[defaults stringForKey:@"authKey"]];
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSDictionary * dictionary = nil;
         
         
         if([data length] >= 1) {
             dictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
         }
         
         if(dictionary != nil) {
             
             if ([dictionary[@"response"][@"Msg"] isEqualToString:@"Success"]) {
                 
                 if ([dictionary[@"response"][@"groups"] count] > 0) {
                     NSArray *groups = dictionary[@"response"][@"groups"];
                     
                     for (NSDictionary *dict in groups) {
                         
                         if ([[self isGroupExist:dict[@"id"]] count] == 0) {
                             Group *group = (Group *)[NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                             group.groupid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             group.groupname = dict[@"name"];
                             [self saveManageObject];
                             [arrGroups removeAllObjects];
                             [arrGroups addObject:@"All"];
                             [arrGroups addObjectsFromArray:[self fetchGroups]];
                             [_tblView reloadData];
                             _tblViewHeight.constant = 44 * arrGroups.count;
                             
                             // for getting Node Overview
                             
                             NSString * urlString = [NSString stringWithFormat:@"%@nodeoverview/%@?groupid=%@&subgroupid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * url = [NSURL URLWithString: urlString];
                             
                             NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
                             request1.HTTPMethod = @"GET";
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request1 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request1.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request1
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                              {
                                  
                                  NSDictionary * grpOverview = nil;
                                  
                                  
                                  if([data1 length] >= 1) {
                                      grpOverview = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
                                      
                                      if(grpOverview != nil) {
                                          
                                          if ([grpOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request1.accessibilityValue][0];
                                              
                                              grp.overview = nil;
                                              GroupSummary *smry = (GroupSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.noofasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"nodeCnt"]];
                                              smry.noofNWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"nwnodeCnt"]];
                                              smry.noofWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"wnodeCnt"]];
                                              
                                              grp.overview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAssets" object:nil];
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             // for getting Alert Overview
                             
                             NSString * urlAlertString = [NSString stringWithFormat:@"%@alertoverview/%@?groupid=%@&subgroupid=&assetid",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlert = [NSURL URLWithString: urlAlertString];
                             
                             NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: urlAlert];
                             request2.HTTPMethod = @"GET";
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request2 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request2.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request2
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data2, NSError *error)
                              {
                                  
                                  NSDictionary * alertOverview = nil;
                                  
                                  
                                  if([data2 length] >= 1) {
                                      alertOverview = [NSJSONSerialization JSONObjectWithData:data2 options: 0 error: nil];
                                      
                                      if(alertOverview != nil) {
                                          
                                          if ([alertOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request2.accessibilityValue][0];
                                              
                                              
                                              
                                              grp.alertoverview = nil;
                                              AlertSummary *smry = (AlertSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.alertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"alertCnt"]];
                                              smry.attentionAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"attentionAlertCnt"]];
                                              smry.criticalALertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"criticalALertCnt"]];
                                              smry.faultAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"faultAlertCnt"]];
                                              
                                              grp.alertoverview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlert" object:nil];
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                             // for getting Node
                             
                             NSString * urlNodeString = [NSString stringWithFormat:@"%@node/%@?assetgroupid=&groupid=&subgroupid=&gatewayid=&nodeid=",baseURL,[defaults stringForKey:@"authKey"]];
                             NSURL * urlNode = [NSURL URLWithString: urlNodeString];
                             
                             NSMutableURLRequest *requestNode = [[NSMutableURLRequest alloc] initWithURL: urlNode];
                             requestNode.HTTPMethod = @"GET";
                             [requestNode setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [requestNode setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [requestNode setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             requestNode.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:requestNode
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *dataNode, NSError *error)
                              {
                                  
                                  NSDictionary * node = nil;
                                  
                                  
                                  if([dataNode length] >= 1) {
                                      node = [NSJSONSerialization JSONObjectWithData:dataNode options: 0 error: nil];
                                      
                                      if(node != nil) {
                                          
                                          if ([node[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              if ([node[@"response"][@"Status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                  
                                                  NSArray *nodes = node[@"response"][@"nodes"];
                                                  
                                                  for (NSDictionary *nodesDict in nodes) {
//                                                      Group *grp = (Group *)[self isGroupExist:nodesDict[@"groupid"]][0];
//                                                      if (![self checkNodeExist:nodesDict[@"id"] ingroup:grp]) {
//                                                          Node *node = (Node *)[NSEntityDescription insertNewObjectForEntityForName:@"Node"
//                                                                                                             inManagedObjectContext:[[self appDelegate] managedObjectContext]];
//                                                          node.nodeid = nodesDict[@"id"];
//                                                          node.analogsensorenable = nodesDict[@"analogsensorenable"];
//                                                          node.assetgroupid = nodesDict[@"assetgroupid"];
//                                                          node.assetgroupname = nodesDict[@"assetgroupname"];
//                                                          node.descriptions = nodesDict[@"description"];
//                                                          node.digitalsensorenable = nodesDict[@"digitalsensorenable"];
//                                                          node.extsensortype = nodesDict[@"extsensortype"];
//                                                          node.gatewayid = nodesDict[@"gatewayid"];
//                                                          node.gatewayname = nodesDict[@"gatewayname"];
//                                                          node.groupid = nodesDict[@"groupid"];
//                                                          node.groupname = nodesDict[@"groupname"];
//                                                          node.isalive = nodesDict[@"isalive"];
//                                                          node.isenable = nodesDict[@"isenable"];
//                                                          node.location = nodesDict[@"location"];
//                                                        node.modelid = nodesDict[@"modelid"];
//                                                          node.model = nodesDict[@"model"];
//                                                          node.name = nodesDict[@"name"];
//                                                          node.subgroupid = nodesDict[@"subgroupid"];
//                                                          node.subgroupname = nodesDict[@"subgroupname"];
//                                                          
//                                                          [grp addNodesObject:node];
//                                                          
//                                                          [self saveManageObject];
                                                      
                                                          
                                                          NSString * urlNodeSummary = [NSString stringWithFormat:@"%@nodesummary/%@?groupid=&subgroupid=&assetgroupid=&gatewayid=&nodeid=%@",baseURL,[defaults stringForKey:@"authKey"],nodesDict[@"id"]];
                                                          NSURL * urlNDSummary = [NSURL URLWithString: urlNodeSummary];
                                                          
                                                          NSMutableURLRequest *requestNodesum = [[NSMutableURLRequest alloc] initWithURL: urlNDSummary];
                                                          requestNodesum.HTTPMethod = @"GET";
                                                          [requestNodesum setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                                          [requestNodesum setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                                                          [requestNodesum setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                                          requestNodesum.accessibilityValue = [NSString stringWithFormat:@"%@",nodesDict[@"groupid"]];
                                                          [NSURLConnection sendAsynchronousRequest:requestNodesum
                                                                                             queue:[NSOperationQueue mainQueue]
                                                                                 completionHandler:^(NSURLResponse *response1, NSData *datandSumm, NSError *error)
                                                           {
                                                               
                                                               NSDictionary * nodeSummary = nil;
                                                               
                                                               
                                                               if([datandSumm length] >= 1) {
                                                                   nodeSummary = [NSJSONSerialization JSONObjectWithData:datandSumm options: 0 error: nil];
                                                                   
                                                                   if(nodeSummary != nil) {
                                                                       
                                                                       if ([nodeSummary[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                                                           
                                                                           Group *grp = (Group *)[self isGroupExist:requestNodesum.accessibilityValue][0];
                                                                           
                                                                           NSArray *lastGateways = nodeSummary[@"response"][@"lastnodereport"];
                                                                           
                                                                           if (lastGateways.count > 0) {
                                                                               for (NSDictionary *dict in lastGateways)
                                                           
                                                                                   {
                                                                                       if ([[self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]] count] == 0) {
                                                                                           GatewayOverView *gateway = (GatewayOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"GatewayOverView"
                                                                                                                                                                       inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                                   
                                                                                           gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                                                           gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                                                           gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                                                           gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                                                           gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                                                           gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                                                           gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                                                           gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                                                           gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                                                           gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                                                           gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                                                           gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                                                           gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                                                           gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
                                                                                           
//                                                                                           gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
//                                                                                           gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
//                                                                                           gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
//                                                                                           gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
//                                                                                           gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                                                           
                                                                                           [grp addGatewayoverviewObject:gateway];
                                                                                           [self saveManageObject];
                                                                                           
                                                                                           
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                           GatewayOverView *gateway = [self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]][0];
                                                                                           gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
                                                                                           
                                                                                           gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
                                                                                           gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
                                                                                           gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
                                                                                           gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
                                                                                           gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
                                                                                           gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
                                                                                           gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
                                                                                           gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
                                                                                           gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
                                                                                           gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
                                                                                           gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
                                                                                           gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
                                                                                           gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
//                                                                                           gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
//                                                                                           gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
//                                                                                           gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
//                                                                                           
//                                                                                           gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
//                                                                                           gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                                                           
                                                                                           [self saveManageObject];
                                                                                       }
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
//                                                                                                                         NSString * urlGatewayString = [NSString stringWithFormat:@"%@gatewaysummary/%@?groupid=&subgroupid=&assetgroupid=&assetid=%@",baseURL,[defaults stringForKey:@"authKey"],dict[@"assetid"]];
//                                                                                                                         NSURL * urlGateway = [NSURL URLWithString: urlGatewayString];
//                                                                                                                         
//                                                                                                                         NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] initWithURL: urlGateway];
//                                                                                                                         request3.HTTPMethod = @"GET";
//                                                                                                                         [request3 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//                                                                                                                         [request3 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
//                                                                                                                         [request3 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//                                                                                                                         request3.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
//                                                                                                                         [NSURLConnection sendAsynchronousRequest:request3
//                                                                                                                                                            queue:[NSOperationQueue mainQueue]
//                                                                                                                                                completionHandler:^(NSURLResponse *response1, NSData *data3, NSError *error)
//                                                                                                                          {
//                                                                                                                              
//                                                                                                                              NSDictionary * gatewayOverview = nil;
//                                                                                                                              
//                                                                                                                              
//                                                                                                                              if([data3 length] >= 1) {
//                                                                                                                                  gatewayOverview = [NSJSONSerialization JSONObjectWithData:data3 options: 0 error: nil];
//                                                                                                                                  
//                                                                                                                                  if(gatewayOverview != nil) {
//                                                                                                                                      
//                                                                                                                                      if ([gatewayOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
//                                                                                                                                          
//                                                                                                                                          
//                                                                                                                                          NSArray *lastGateways = gatewayOverview[@"response"][@"lastgatewayreport"];
//                                                                                                                                          
//                                                                                                                                          if (lastGateways.count > 0) {
//                                                                                                                                              for (NSDictionary *dict in lastGateways) {
//                                                                                                                                                  
//                                                                                                                                                  
//                                                                                                                                                  if ([[self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]] count] == 0) {
//                                                                                                                                                      GatewayOverView *gateway = (GatewayOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"GatewayOverView"
//                                                                                                                                                                                                                                  inManagedObjectContext:[[self appDelegate] managedObjectContext]];
//                                                                                                                                                      gateway.address = [NSString stringWithFormat:@"%@",dict[@"address"]];
//                                                                                                                                                      gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
//                                                                                                                                                      gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
//                                                                                                                                                      gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
//                                                                                                                                                      gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
//                                                                                                                                                      gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
//                                                                                                                                                      gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
//                                                                                                                                                      gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
//                                                                                                                                                      gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
//                                                                                                                                                      gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
//                                                                                                                                                      gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
//                                                                                                                                                      gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
//                                                                                                                                                      gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
//                                                                                                                                                      gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
//                                                                                                                                                      gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
//                                                                                                                                                      gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
//                                                                                                                                                      gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
//                                                                                                                                                      gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
//                                                                                                                                                      gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
//                                                                                                                                                      gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
//                                                                                                                                                      
//                                                                                                                                                      
//                                                                                                                                                      
//                                                                                                                                                      [grp addGatewayoverviewObject:gateway];
//                                                                                                                                                      [self saveManageObject];
//                                                                                                                                                      
//                                                                                                                                                      
//                                                                                                                                                  }
//                                                                                                                                                  else
//                                                                                                                                                  {
//                                                                                                                                                      GatewayOverView *gateway = [self checkGatewayExistinGroup:grp withAssetID:dict[@"assetid"]][0];
//                                                                                                                                                      
//                                                                                                                                                      gateway.assetid = [NSString stringWithFormat:@"%@",dict[@"assetid"]];
//                                                                                                                                                      gateway.assetgroupname = [NSString stringWithFormat:@"%@",dict[@"assetgroupname"]];
//                                                                                                                                                      gateway.assetname = [NSString stringWithFormat:@"%@",dict[@"assetname"]];
//                                                                                                                                                      gateway.groupname = [NSString stringWithFormat:@"%@",dict[@"groupname"]];
//                                                                                                                                                      gateway.subgroupname = [NSString stringWithFormat:@"%@",dict[@"subgroupname"]];
//                                                                                                                                                      gateway.datetime = [NSString stringWithFormat:@"%@",dict[@"datetime"]];
//                                                                                                                                                      gateway.batt = [NSString stringWithFormat:@"%@",dict[@"batt"]];
//                                                                                                                                                      gateway.extsensor = [NSString stringWithFormat:@"%@",dict[@"extsensor"]];
//                                                                                                                                                      gateway.humidity = [NSString stringWithFormat:@"%@",dict[@"humidity"]];
//                                                                                                                                                      gateway.temperature = [NSString stringWithFormat:@"%@",dict[@"temperature"]];
//                                                                                                                                                      gateway.light = [NSString stringWithFormat:@"%@",dict[@"light"]];
//                                                                                                                                                      gateway.pressure = [NSString stringWithFormat:@"%@",dict[@"pressure"]];
//                                                                                                                                                      gateway.motion = [NSString stringWithFormat:@"%@",dict[@"motion"]];
//                                                                                                                                                      gateway.speed = [NSString stringWithFormat:@"%@",dict[@"speed"]];
//                                                                                                                                                      gateway.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
//                                                                                                                                                      gateway.rssi = [NSString stringWithFormat:@"%@",dict[@"rssi"]];
//                                                                                                                                                      
//                                                                                                                                                      gateway.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
//                                                                                                                                                      gateway.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
//                                                                                                                                                      gateway.alive = [NSNumber numberWithInt:[dict[@"alive"] intValue]];
//                                                                                                                                                      
//                                                                                                                                                      [self saveManageObject];
//                                                                                                                                                  }
//                                                                                                                                              }
//                                                                                                                                          }
//                                                                                                                                          
//                                                                                                                                          
//                                                                                                                                      }
//                                                                                                                                  }
//                                                                                                                              }
//                                                                                                                              
//                                                                                                                          }];
                                                                                   
                                                                                   
                                                                                   }
                                                                           }
                                                                           
                                                                           
                                                                       }
                                                                   }
                                                               }
                                                               
                                                           }];
                                                          
                                                          
                                                      }
                                                      
//                                                  }
                                                  
                                              }
                                          }
                                      }
                                      
                                  }}];

                             
                             
                             

                             
                             // for getting Alert Details
                             
                             NSString * urlAlertSummaryString = [NSString stringWithFormat:@"%@alert/%@?groupid=%@&subgroupid=&alerttypeid=&gatewayid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlertSummary = [NSURL URLWithString: urlAlertSummaryString];
                             
                             NSMutableURLRequest *request4 = [[NSMutableURLRequest alloc] initWithURL: urlAlertSummary];
                             request4.HTTPMethod = @"GET";
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request4 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request4.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request4
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response3, NSData *data4, NSError *error)
                              {
                                  
                                  NSDictionary * alertSummary = nil;
                                  
                                  
                                  if([data4 length] >= 1) {
                                      alertSummary = [NSJSONSerialization JSONObjectWithData:data4 options: 0 error: nil];
                                      
                                      if(alertSummary != nil) {
                                          
                                          if ([alertSummary[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request4.accessibilityValue][0];
                                              
                                              NSArray *arrAlerts = alertSummary[@"response"][@"Alters"];
                                              
                                              if (arrAlerts.count > 0) {
                                                  for (NSDictionary *dict in arrAlerts) {
                                                      if ([[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]] count] == 0) {
                                                          
                                                          AlertOverView *overView = (AlertOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertOverView"
                                                                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [grp addAlertsummaryObject:overView];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          AlertOverView *overView = (AlertOverView *)[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]][0];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [self saveManageObject];
                                                          
                                                      }}}
                                              
                                              
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                         }
                         else
                         {
                             [arrGroups removeAllObjects];
                             [arrGroups addObject:@"All"];
                             [arrGroups addObjectsFromArray:[self fetchGroups]];
                             [_tblView reloadData];
                             _tblViewHeight.constant = 44 * arrGroups.count;
                             
                             
                             // for getting Node Overview
                             
                             NSString * urlString = [NSString stringWithFormat:@"%@nodeoverview/%@?groupid=%@&subgroupid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * url = [NSURL URLWithString: urlString];
                             
                             NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
                             request1.HTTPMethod = @"GET";
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request1 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request1.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request1
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                              {
                                  
                                  NSDictionary * grpOverview = nil;
                                  
                                  
                                  if([data1 length] >= 1) {
                                      grpOverview = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
                                      
                                      if(grpOverview != nil) {
                                          
                                          if ([grpOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request1.accessibilityValue][0];
                                              
                                              grp.overview = nil;
                                              GroupSummary *smry = (GroupSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.noofasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"nodeCnt"]];
                                              smry.noofNWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"nwnodeCnt"]];
                                              smry.noofWasset = [NSString stringWithFormat:@"%@",grpOverview[@"response"][@"nodeoverview"][@"wnodeCnt"]];
                                              
                                              grp.overview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAssets" object:nil];
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                             // for getting Alert Overview
                             
                             NSString * urlAlertString = [NSString stringWithFormat:@"%@alertoverview/%@?groupid=%@&subgroupid=&assetid",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlert = [NSURL URLWithString: urlAlertString];
                             
                             NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: urlAlert];
                             request2.HTTPMethod = @"GET";
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request2 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request2.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request2
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response1, NSData *data2, NSError *error)
                              {
                                  
                                  NSDictionary * alertOverview = nil;
                                  
                                  
                                  if([data2 length] >= 1) {
                                      alertOverview = [NSJSONSerialization JSONObjectWithData:data2 options: 0 error: nil];
                                      
                                      if(alertOverview != nil) {
                                          
                                          if ([alertOverview[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request2.accessibilityValue][0];
                                              
                                              
                                              
                                              grp.alertoverview = nil;
                                              AlertSummary *smry = (AlertSummary *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertSummary"
                                                                                                                 inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                              
                                              smry.alertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"alertCnt"]];
                                              smry.attentionAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"attentionAlertCnt"]];
                                              smry.criticalALertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"criticalALertCnt"]];
                                              smry.faultAlertCnt = [NSString stringWithFormat:@"%@",alertOverview[@"response"][@"gatewayoverview"][@"faultAlertCnt"]];
                                              
                                              grp.alertoverview = smry;
                                              [self saveManageObject];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlert" object:nil];
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                             
                           // for getting Alert Details
                             
                             NSString * urlAlertSummaryString = [NSString stringWithFormat:@"%@alert/%@?groupid=%@&subgroupid=&alerttypeid=&gatewayid=",baseURL,[defaults stringForKey:@"authKey"],dict[@"id"]];
                             NSURL * urlAlertSummary = [NSURL URLWithString: urlAlertSummaryString];
                             
                             NSMutableURLRequest *request4 = [[NSMutableURLRequest alloc] initWithURL: urlAlertSummary];
                             request4.HTTPMethod = @"GET";
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                             [request4 setValue:@"charset" forHTTPHeaderField:@"utf-8"];
                             [request4 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                             request4.accessibilityValue = [NSString stringWithFormat:@"%@",dict[@"id"]];
                             [NSURLConnection sendAsynchronousRequest:request4
                                                                queue:[NSOperationQueue mainQueue]
                                                    completionHandler:^(NSURLResponse *response3, NSData *data4, NSError *error)
                              {
                                  
                                  NSDictionary * alertSummary = nil;
                                  
                                  
                                  if([data4 length] >= 1) {
                                      alertSummary = [NSJSONSerialization JSONObjectWithData:data4 options: 0 error: nil];
                                      
                                      if(alertSummary != nil) {
                                          
                                          if ([alertSummary[@"response"][@"Msg"]isEqualToString:@"Success"]) {
                                              
                                              Group *grp = (Group *)[self isGroupExist:request4.accessibilityValue][0];
                                              
                                              NSArray *arrAlerts = alertSummary[@"response"][@"Alters"];
                                              
                                              if (arrAlerts.count > 0) {
                                                  for (NSDictionary *dict in arrAlerts) {
                                                      if ([[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]] count] == 0) {
                                                          
                                                          AlertOverView *overView = (AlertOverView *)[NSEntityDescription insertNewObjectForEntityForName:@"AlertOverView"
                                                                                                                                   inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [grp addAlertsummaryObject:overView];
                                                          [self saveManageObject];
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          AlertOverView *overView = (AlertOverView *)[self checkAlertExistinGroup:grp withAlertID:[NSString stringWithFormat:@"%@",dict[@"id"]]][0];
                                                          
                                                          overView.acknowledged = [NSString stringWithFormat:@"%@",dict[@"acknowledged"]];
                                                          overView.alertcfg = [NSString stringWithFormat:@"%@",dict[@"alertcfg"]];
                                                          overView.alertcfgid = [NSString stringWithFormat:@"%@",dict[@"alertcfgid"]];
                                                          overView.alerttype = [NSString stringWithFormat:@"%@",dict[@"alerttype"]];
                                                          overView.alerttypeid = [NSString stringWithFormat:@"%@",dict[@"alerttypeid"]];
                                                          overView.alertvalue = [NSString stringWithFormat:@"%@",dict[@"alertvalue"]];
                                                          overView.enddatetime = [NSString stringWithFormat:@"%@",dict[@"enddatetime"]];
                                                          overView.gateway = [NSString stringWithFormat:@"%@",dict[@"gateway"]];
                                                          overView.gatewayid = [NSString stringWithFormat:@"%@",dict[@"gatewayid"]];
                                                          overView.groupname = [NSString stringWithFormat:@"%@",dict[@"group"]];
                                                          overView.groupid = [NSString stringWithFormat:@"%@",dict[@"groupid"]];
                                                          overView.alertid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                                                          overView.lat = [NSString stringWithFormat:@"%@",dict[@"lat"]];
                                                          overView.lon = [NSString stringWithFormat:@"%@",dict[@"lon"]];
                                                          overView.noccurance = [NSString stringWithFormat:@"%@",dict[@"noccurance"]];
                                                          overView.node = [NSString stringWithFormat:@"%@",dict[@"node"]];
                                                          overView.nodeid = [NSString stringWithFormat:@"%@",dict[@"nodeid"]];
                                                          overView.severity = [NSString stringWithFormat:@"%@",dict[@"severity"]];
                                                          overView.startdatetime = [NSString stringWithFormat:@"%@",dict[@"startdatetime"]];
                                                          overView.subgroup = [NSString stringWithFormat:@"%@",dict[@"subgroup"]];
                                                          overView.subgroupid = [NSString stringWithFormat:@"%@",dict[@"subgroupid"]];
                                                          overView.timezone = [NSString stringWithFormat:@"%@",dict[@"timezone"]];
                                                          
                                                          [self saveManageObject];
                                                          
                                                      }}}
                                              
                                          }
                                      }
                                  }
                                  
                              }];
                             
                         }
                     }
                     
                 }
                 
             }
             
             
         }
         
         
         
         
     }];
    
    
    
}

- (void)getOverallAssets
{
    NSArray *groups = [self fetchGroups];
    noofassets = 0;
    noofNWasset = 0;
    noofWasset = 0;
    for (Group *grp in groups) {
     
        GroupSummary *smmry = (GroupSummary *)grp.overview;
        noofWasset += smmry.noofWasset.intValue;
        noofassets += smmry.noofasset.intValue;
        noofNWasset += smmry.noofNWasset.intValue;
        
    }
    
    _lblAsset.text = [NSString stringWithFormat:@"%i",noofassets];
    _lblAssetNotReporting.text = [NSString stringWithFormat:@"%i",noofNWasset];
    _lblAssetReporing.text = [NSString stringWithFormat:@"%i",noofWasset];
    
    [self.view setNeedsDisplay];
    
}

- (void)getAssetsforgroup:(Group *)group
{
    noofassets = 0;
    noofNWasset = 0;
    noofWasset = 0;
    
        GroupSummary *smmry = (GroupSummary *)group.overview;
        noofWasset = smmry.noofWasset.intValue;
        noofassets = smmry.noofasset.intValue;
        noofNWasset = smmry.noofNWasset.intValue;
        
    
    _lblAsset.text = [NSString stringWithFormat:@"%i",noofassets];
    _lblAssetNotReporting.text = [NSString stringWithFormat:@"%i",noofNWasset];
    _lblAssetReporing.text = [NSString stringWithFormat:@"%i",noofWasset];
    
    [self.view setNeedsDisplay];
    
}

- (void)getOverallAlert
{
    noofAlerts = 0;
    NSArray *groups = [self fetchGroups];
    
    for (Group *grp in groups) {
        
        AlertSummary *smmry = (AlertSummary *)grp.alertoverview;
        noofAlerts += smmry.alertCnt.intValue;
        
    }
    
    _lblAlert.text = [NSString stringWithFormat:@"%i",noofAlerts];
    [self.view setNeedsDisplay];
}

- (void)getAlertforGroup:(Group *)group
{
    noofAlerts = 0;
    
    
        AlertSummary *smmry = (AlertSummary *)group.alertoverview;
        noofAlerts = smmry.alertCnt.intValue;
        
    _lblAlert.text = [NSString stringWithFormat:@"%i",noofAlerts];
    [self.view setNeedsDisplay];
}





- (void)requestAlertGateWay{
    if ([HelpDesk sharedInstance].isInternetAvailable) {
        
        NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
        
        [WebServices sharedInstance].webRequestMode = (WebRequestMode *)WEB_REQUEST_ALERT_OVERVIEW;
        [[WebServices sharedInstance] composeWebRequestFromArguments:arguments forWebRequestMode:[WebServices sharedInstance].webRequestMode responseWithStatus:^(NSMutableArray *status){
            
            NSString * message = [status objectAtIndex:0];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([message compare:@"Success"] == NSOrderedSame) {
                _lblAlert.text = [OnDeck sharedInstance].strAlert;
                
                
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

- (NSArray *)isGroupExist:(NSString *)groupId
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    request.predicate = [NSPredicate predicateWithFormat:@"groupid == %@",groupId];
    
    NSArray *array = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    return array;
}

- (NSArray *)fetchGroups
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    return arr;
}

                         
                         
                         
                         
- (NSArray *)checkGatewayExistinGroup:(Group *)group withAssetID:(NSString *)assetId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetid == %@",assetId];
    NSArray *arr = [group.gatewayoverview.allObjects filteredArrayUsingPredicate:predicate];
    
    return arr;
}

- (NSArray *)checkAlertExistinGroup:(Group *)group withAlertID:(NSString *)alertID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alertid == %@",alertID];
    NSArray *arr = [group.alertsummary.allObjects filteredArrayUsingPredicate:predicate];
    
    return arr;
}
                         
                         

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:10];
    if (indexPath.row != 0) {
        Group *grp = arrGroups[indexPath.row];
        lbl.text = grp.groupname;
    }
    else
       lbl.text = arrGroups[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self getOverallAlert];
        [self getOverallAssets];
        selectedIndex = 0;
        _lblGroups.text = @"ALL GROUPS";
    }
    else
    {
        selectedIndex = indexPath.row;
        Group *grp = arrGroups[indexPath.row];
        selectedGroup = grp;
        _lblGroups.text = grp.groupname.uppercaseString;
        [self getAlertforGroup:grp];
        [self getAssetsforgroup:grp];
    }
    
    _tblView.hidden = YES;
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

- (NSArray *)fetchAssetsNotReporting
{
    if (selectedIndex == 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
        request.predicate = [NSPredicate predicateWithFormat:@"alive == 0"];
        NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
        return arr;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alive == 0"];
        NSArray *arrFilter = [selectedGroup.gatewayoverview.allObjects filteredArrayUsingPredicate:predicate];
        return arrFilter;
    }
}

- (NSArray *)fetchAssetsReporting
{
    if (selectedIndex == 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GatewayOverView"];
        request.predicate = [NSPredicate predicateWithFormat:@"alive == 1"];
        NSArray *arr = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
        return arr;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alive == 1"];
        NSArray *arrFilter = [selectedGroup.gatewayoverview.allObjects filteredArrayUsingPredicate:predicate];
        return arrFilter;
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toAssetLaunch"]) {
        AsssetLaunchViewController *assets = (AsssetLaunchViewController *)segue.destinationViewController;
        assets.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssets]];
        assets.selectedIndex = selectedIndex;
        assets.selectedGroup = selectedGroup;
        assets.configeration = configeration;
    }
    if ([segue.identifier isEqualToString:@"toassetsnotreporting"]) {
        AssetsNotReportingViewController *assets = (AssetsNotReportingViewController *)segue.destinationViewController;
        assets.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssetsNotReporting]];
        assets.selectedIndex = selectedIndex;
        assets.selectedGroup = selectedGroup;
        assets.configeration = configeration;
    }
    if ([segue.identifier isEqualToString:@"toassetsreporting"]) {
        AssetsReportingViewController *assets = (AssetsReportingViewController *)segue.destinationViewController;
        assets.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssetsReporting]];
        assets.selectedIndex = selectedIndex;
        assets.selectedGroup = selectedGroup;
        assets.configeration = configeration;
    }
    if ([segue.identifier isEqualToString:@"toRecords"]) {
        AssetViewController *assets = (AssetViewController *)segue.destinationViewController;
        
        assets.selectedIndex = selectedIndex;
        assets.selectedGroup = selectedGroup;
        assets.configeration = configeration;
        
        assets.track = @"report";
        [assets.segment setSelectedSegmentIndex:1];
        assets.arrAsset = [[NSMutableArray alloc] initWithArray:[self fetchAssets]];

    }
    
    
}

- (NSArray *)fetchConfigeration
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Configeration"];
    NSArray *response = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:nil];
    
    return response;
}
@end
