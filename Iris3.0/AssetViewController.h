//
//  AssetViewController.h
//  Iris3.0
//
//  Created by Priya on 01/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "GatewayOverView.h"
#import <MapKit/MapKit.h>
#import "UUChart.h"



@interface AssetViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate, UUChartDataSource, UIGestureRecognizerDelegate>
{
    UUChart *chartView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewAsset;
@property (nonatomic, strong) NSMutableArray *arrAsset;
@property (nonatomic, strong) Group *selectedGroup;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIView *viewReports;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *tabbarScrollView;
@property (strong, nonatomic) UIView *viewGraph;
@property (strong, nonatomic) UILabel *lblXAxis;
@property (strong, nonatomic) UILabel *lblYAxis;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionAssets;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hghtCollection;
@property (weak, nonatomic) IBOutlet UILabel *assetHeader;
@property (nonatomic , strong) NSDictionary *configeration;
@property (nonatomic, strong) NSString *track;
@property (nonatomic, strong) GatewayOverView *selectedGateway;
- (IBAction)actionSegmant:(id)sender;

- (IBAction)actionGroups:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblGroups;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetTitle;

@end
