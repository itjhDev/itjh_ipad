//
//  SignUpViewController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "SignUpViewController.h"
#import "AVUser.h"
#import "AVConstants.h"
#import "PickHeadImagePopoverController.h"
@interface SignUpViewController ()<PickHeadImagePopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong,nonatomic) UIPopoverController *chooseImagePopoverController;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =@"注册";
    //图片设置圆角
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius =5.0;
    
    _passwordTextField.secureTextEntry = YES;
    _passwordAgainTextField.secureTextEntry = YES;
    //点击图片选择头像
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage:)];
    [_headImageView addGestureRecognizer:tapGestureRecognizer];
    
      self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
                                                                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)SignUp:(id)sender {
    if(self.accountTextField.text.length==0)
    {
        [self showErrorAlertViewWithReason:@"用户名不能为空"];
        return;
    }
   
    if (self.passwordTextField.text==0) {
        [self showErrorAlertViewWithReason:@"密码不能为空"];
          return;
    }
    if (![self.passwordAgainTextField.text isEqualToString:self.passwordTextField.text]) {
        [self showErrorAlertViewWithReason:@"两次密码输入结果不同"];
          return;
    }
    [self signUpWithName:self.accountTextField.text password:self.passwordTextField.text headImage:@"luigi"];
}
-(void)showErrorAlertViewWithReason:(NSString*)reason
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:reason delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alertView show];
}

-(void)signUpWithName:(NSString*)name
                      password:(NSString*)password
                   headImage:(NSString*)headimage{
    
    AVUser *user =  [AVUser user];
    user.username = name;
    user.password = password;
    NSData *imageData = UIImagePNGRepresentation(_headImageView.image);
    
    __weak typeof(self) weakSelf = self;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSString *errorReason ;
            if (error.code== kAVErrorUsernameTaken) {
                errorReason = @"用户名已存在,请重新选择用户名";
            }
            if (error.code == -1009) {
                errorReason = @"网络无连接，请检查网络";
            }
            [self showErrorAlertViewWithReason:errorReason];
        }
        else
        {
            [user setObject:imageData forKey:@"headimage"];
            [user saveInBackground];
             [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
-(void)chooseImage:(UIGestureRecognizer *)sender{
    PickHeadImagePopoverController *pvc =
                                    [[PickHeadImagePopoverController alloc] initWithNibName:@"PickHeadImagePopoverController" bundle:nil];
    pvc.delegate = self;
    
    _chooseImagePopoverController = [[UIPopoverController alloc]initWithContentViewController:pvc];
    _chooseImagePopoverController.popoverContentSize =  CGSizeMake(450, 600);
    [_chooseImagePopoverController presentPopoverFromRect:sender.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}
-(void)pickHeadImage:(UIImage *)pickHeadImagee{
    _headImageView.image = pickHeadImagee;
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

@end
