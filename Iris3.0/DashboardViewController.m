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

@interface DashboardViewController ()<SWRevealViewControllerDelegate>
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    UIImage *backgrd = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/img-navigationbar-background.png"]];
    UIImage *scaledImage = [UIImage imageWithCGImage:[backgrd CGImage]
                                               scale:2.0 orientation:UIImageOrientationUp];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:scaledImage];
    
     //For Custom Navigation bar
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DashBoardNavigationBar" owner:self options:nil];
    DashBoardNavigationBar *connectionViewNavigationBar = (DashBoardNavigationBar *)[nib objectAtIndex:0];
    connectionViewNavigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    connectionViewNavigationBar.tag = 1;
    self.navigationItem.titleView = connectionViewNavigationBar;
    
    // ConnectionView Navigationbar Button Actions
    [connectionViewNavigationBar.btnCreate addTarget:self action:@selector(actionCreate:)
                                     forControlEvents:UIControlEventTouchUpInside];
    
    [connectionViewNavigationBar.btnSearch addTarget:self action:@selector(actionSearch:)
                                        forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //self.navigationItem.title = @"Dashboard";
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

}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Dashboard";
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionButton:(id)sender {
    
    
    
    
}

- (IBAction)actionAllGroups:(id)sender {
}

- (IBAction)actionAsset:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *alertView = [story instantiateViewControllerWithIdentifier:@"AssetViewController"];
    [self.navigationController pushViewController:alertView animated:YES];
}

- (IBAction)actionReporting:(id)sender {
    
}

- (IBAction)actionRecording:(id)sender {
    
}

- (IBAction)actionAlert:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *alertView = [story instantiateViewControllerWithIdentifier:@"AlertViewController"];
    [self.navigationController pushViewController:alertView animated:YES];
    
    
}

- (IBAction)actionMenu:(id)sender{
   }
@end
