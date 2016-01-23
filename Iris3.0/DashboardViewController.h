//
//  DashboardViewController.h
//  Iris3.0
//
//  Created by Priya on 29/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewAllGroups;
@property (weak, nonatomic) IBOutlet UIView *viewAllRecord;
@property (weak, nonatomic) IBOutlet UIView *viewAssets;
@property (weak, nonatomic) IBOutlet UIView *viewRecording;
@property (weak, nonatomic) IBOutlet UIView *viewReporting;
@property (weak, nonatomic) IBOutlet UIView *viewAlerts;
- (IBAction)actionAllGroups:(id)sender;
- (IBAction)actionAsset:(id)sender;
- (IBAction)actionReporting:(id)sender;
- (IBAction)actionRecording:(id)sender;

- (IBAction)actionAlert:(id)sender;

- (IBAction)actionMenu:(id)sender;
@end
