//
//  SignUpViewController.h
//  Iris3.0
//
//  Created by Priya on 30/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgviewBg;
@property (weak, nonatomic) IBOutlet UITextField *txtFldFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtFldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)actionNext:(id)sender;
- (IBAction)actionClose:(id)sender;

@end
