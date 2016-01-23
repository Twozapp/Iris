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
    if ([HelpDesk sharedInstance].isInternetAvailable) {
        
        
        
        NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
        [arguments setObject:[OnDeck sharedInstance].strUserName forKey:@"email"];
        [arguments setObject:[OnDeck sharedInstance].strPassword forKey:@"password"];
        
        [WebServices sharedInstance].webRequestMode = (WebRequestMode *)WEB_REQUEST_LOGIN;
        [[WebServices sharedInstance] composeWebRequestFromArguments:arguments forWebRequestMode:[WebServices sharedInstance].webRequestMode responseWithStatus:^(NSMutableArray *status){
            
            NSString * message = [status objectAtIndex:0];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([message compare:@"Success"] == NSOrderedSame) {
                
                [OnDeck sharedInstance].strUserName = [OnDeck sharedInstance].strUserName;
                [OnDeck sharedInstance].strPassword = [OnDeck sharedInstance].strPassword;
                
                [[OnDeck sharedInstance] setAutoSignIn];
                
                UIViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoard"];
                svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:svc animated:YES completion:nil];
                
                
            }
            else if ([message compare:@"Failure"] == NSOrderedSame){
                UIViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInNavi"];
                svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:svc animated:YES completion:nil];
            }
            
            else{
                
            }
        }];
    }
    else{
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
