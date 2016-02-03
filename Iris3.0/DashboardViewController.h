//
//  DashboardViewController.h
//  Iris3.0
//
//  Created by Priya on 29/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString *baseURL = @"http://198.57.226.173:8080/irisservices/v3.0/";

@interface DashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblGroups;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetsHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblReportingHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblNotReporting;
- (IBAction)actionViewAllReport:(id)sender;

- (IBAction)actionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewAllGroups;
@property (weak, nonatomic) IBOutlet UIView *viewAllRecord;
@property (weak, nonatomic) IBOutlet UIView *viewAssets;
@property (weak, nonatomic) IBOutlet UIView *viewRecording;
@property (weak, nonatomic) IBOutlet UIView *viewReporting;
@property (weak, nonatomic) IBOutlet UIView *viewAlerts;
@property (weak, nonatomic) IBOutlet UILabel *lblAsset;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetReporing;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetNotReporting;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
- (IBAction)actionAllGroups:(id)sender;
- (IBAction)actionAsset:(id)sender;
- (IBAction)actionReporting:(id)sender;
- (IBAction)actionRecording:(id)sender;

- (IBAction)actionAlert:(id)sender;

- (IBAction)actionMenu:(id)sender;
@end
