//
//  LoginViewController.h
//  Iris3.0
//
//  Created by Priya on 30/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;
@property (weak, nonatomic) IBOutlet UITextField *txtFldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPassword;

- (IBAction)actionResetPassword:(id)sender;
- (IBAction)actionSignIn:(id)sender;
@end
