//
//  SignUpViewController.m
//  Iris3.0
//
//  Created by Priya on 30/12/15.
//  Copyright © 2015 Priya. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _imgviewBg.layer.cornerRadius = 10.0f;
    [_imgviewBg.layer setMasksToBounds:YES];
    
    _btnNext.layer.cornerRadius = 5.0f;
    [_btnNext.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtFldFullName resignFirstResponder];
    [_txtFldEmail resignFirstResponder];
    [_txtFldPassword resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldFullName)
    {
        [_txtFldEmail becomeFirstResponder];
        [_txtFldPassword resignFirstResponder];
    }
    else if (textField == _txtFldEmail)
    {
        [_txtFldPassword becomeFirstResponder];
    }
    else if (textField == _txtFldPassword)
    {
        [_txtFldPassword resignFirstResponder];
    }
    return YES;
}



- (IBAction)actionNext:(id)sender {
}

- (IBAction)actionClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
