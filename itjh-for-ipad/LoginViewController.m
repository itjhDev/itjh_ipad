//
//  LoginViewController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "LoginViewController.h"
#import "AVUser.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLoad{
    //触碰空白地方收起键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    self.passwordTextField.secureTextEntry =YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
  //  [NSNotificationCenter defaultCenter]rem
}
#pragma mark --收起键盘
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
   
    [textField resignFirstResponder];
    return YES;
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
    
}
- (IBAction)loginIn:(id)sender {
    
     if(self.accountTextField.text.length==0)
    {
        [self showErrorAlertViewWithReason:@"用户名不能为空"];
        return;
    }
    if (self.passwordTextField.text==0) {
        [self showErrorAlertViewWithReason:@"密码不能为空"];
    }
  

    [self loginWithName:self.accountTextField.text
                     password:self.passwordTextField.text
                  headImage:nil];
}
-(void)showErrorAlertViewWithReason:(NSString*)reason
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录失败"
                                                                              message:reason
                                                                               delegate:nil
                                                                  cancelButtonTitle:@"好的"
                                                                  otherButtonTitles: nil];
    [alertView show];
}






-(void)loginWithName:(NSString*)name
                   password:(NSString*)password
                headImage:(NSString*)headimage
{
    [AVUser logInWithUsernameInBackground:name password:password block:^(AVUser *user, NSError *error) {
        if (!user) {
            NSString * errorReason ;
            switch (error.code) {
                case 211:
                    errorReason = @"该用户不存在";
                    break;
                 case 210:
                    errorReason = @"用户名和密码不匹配";
                default:
                    errorReason = error.localizedDescription;
                    break;
                    
            }             [self showErrorAlertViewWithReason:errorReason];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(BOOL )shouldAutorotate
{
    return NO;
}
@end
