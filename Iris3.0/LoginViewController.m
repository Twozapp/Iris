//
//  LoginViewController.m
//  Iris3.0
//
//  Created by Priya on 30/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkManager.h"
#import "HelpDesk.h"
#import "OnDeck.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    
    _btnSignIn.layer.cornerRadius = 25.0f;
    [_btnSignIn.layer setMasksToBounds:YES];
    
    _imgViewBg.layer.cornerRadius = 8.0f;
    [_imgViewBg.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtFldEmail resignFirstResponder];
    [_txtFldPassword resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldEmail)
    {
        [_txtFldPassword becomeFirstResponder];
    }
    else if (textField == _txtFldPassword)
    {
        [_txtFldPassword resignFirstResponder];
    }
    return YES;
}


- (IBAction)actionResetPassword:(id)sender {
}

- (IBAction)actionSignIn:(id)sender {
    
    [self performSelector:@selector(requestLogin) withObject:nil afterDelay:0.25];
    
   
}

- (void)requestLogin{
    {
        [_txtFldEmail resignFirstResponder];
        [_txtFldPassword resignFirstResponder];
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet connection Available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        } else {
       
            
            NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
            [arguments setObject:_txtFldEmail.text forKey:@"email"];
            [arguments setObject:_txtFldPassword.text forKey:@"password"];
            
            [WebServices sharedInstance].webRequestMode = (WebRequestMode *)WEB_REQUEST_LOGIN;
            [[WebServices sharedInstance] composeWebRequestFromArguments:arguments forWebRequestMode:[WebServices sharedInstance].webRequestMode responseWithStatus:^(NSMutableArray *status){
                
                NSString * message = [status objectAtIndex:0];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if ([message compare:@"Success"] == NSOrderedSame) {
                    
                    if (![self isUserExist]) {
                        User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                                                             inManagedObjectContext:[[self appDelegate] managedObjectContext]];
                        user.userid = [NSString stringWithFormat:@"%@",[status objectAtIndex:1]];
                        user.username = _txtFldEmail.text;
                        user.password = _txtFldPassword.text;
                        user.authKey = [OnDeck sharedInstance].strauthKey;
                        
                        [self saveManageObject];
                                            }
                    [OnDeck sharedInstance].strUserName = _txtFldEmail.text;
                    [OnDeck sharedInstance].strPassword = _txtFldPassword.text;
                    
                    [[OnDeck sharedInstance] setAutoSignIn];
                    
                    _txtFldEmail.text = @"";
                    _txtFldPassword.text = @"";
                    
                    UIViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoard"];
                    svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:svc animated:YES completion:nil];
                    
                    
                }
                else if ([message compare:@"Failure"] == NSOrderedSame){
                    [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Invalid username and password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }
                
                else{
                   [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Invalid username and password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show]; 
                }
            }];
        }
        
        
        
    }
}

- (BOOL)isUserExist
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSInteger count = [[[self appDelegate] managedObjectContext] countForFetchRequest:request error:&error];
    
    if (count > 0) {
        return YES;
    }
    
    return NO;
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
@end
