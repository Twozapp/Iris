//
//  SplashViewController.m
//  Iris3.0
//
//  Created by Priya on 29/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import "SplashViewController.h"
#import "OnDeck.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_activityIndicator startAnimating];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (![[OnDeck sharedInstance] isUserAlreadyExists])
        [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:3.0];
    else
            [self performSelector:@selector(requestSignIn) withObject:nil afterDelay:3.0];

    // Do any additional setup after loading the view.
}

- (void)stopAnimating{
    [_activityIndicator stopAnimating];
    
    UIViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInNavi"];
    svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svc animated:YES completion:nil];
    
}

-(void)requestSignIn
{
    [_activityIndicator stopAnimating];
    [OnDeck sharedInstance].strauthKey = [[OnDeck sharedInstance].userPreferences objectForKey:@"authKey"];
    [OnDeck sharedInstance].strUserName = [[OnDeck sharedInstance].userPreferences objectForKey:@"email"];
    [OnDeck sharedInstance].strPassword = [[OnDeck sharedInstance].userPreferences objectForKey:@"password"];
    
    UIViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInNavi"];
    svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svc animated:NO completion:^{
        UIViewController *abc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoard"];
        abc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [svc presentViewController:abc animated:NO completion:nil];
    }];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
