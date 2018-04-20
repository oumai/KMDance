//
//  KMDLoginViewController.m
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDLoginViewController.h"
//#import "BATGraditorButton.h"

#import "KMDRegisterViewController.h"
#import "AppDelegate+KMDLoginCategory.h"//登录

#import "KMDForgetPasswordViewController.h"

#import "WHC_KeyboardManager.h"
#import "SFHFKeychainUtils.h"

@interface KMDLoginViewController ()

@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UITextField *userNameTF;
@property (nonatomic,strong) UITextField *passwordTF;
//@property (nonatomic,strong) BATGraditorButton *loginBtn;
//@property (nonatomic,strong) BATGraditorButton *registerBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) UIButton *forgetPasswordBtn;

@end

@implementation KMDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //返回按钮
    WEAK_SELF(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"backwhite_icon"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.userNameTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    if (self.userNameTF.text.length == 0) {
        return;
    }
    NSError *error;
    NSString * password = [SFHFKeychainUtils getPasswordForUsername:self.userNameTF.text andServiceName:ServiceName error:&error];
    if(error){
        DDLogError(@"从Keychain里获取密码出错：%@",error);
        return;
    }
    self.passwordTF.text = password;
}

#pragma mark - NET
- (void)loginRequest {
    [self showProgressWithText:@"正在登录"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate kmd_LoginWithUserName:self.userNameTF.text password:self.passwordTF.text Success:^{
        
        [self showSuccessWithText:@"登录成功"];
        //完成登录，退出登录界面
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    WEAK_SELF(self);
    //界面
    [self.view addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@100);
    }];
    
    [self.view addSubview:self.userNameTF];
    [self.userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userNameTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
    }];
    
    [self.view addSubview:self.forgetPasswordBtn];
    [self.forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.registerBtn.mas_bottom).offset(20);
    }];
    
    [self.view bk_whenTapped:^{
        STRONG_SELF(self);
        [self.view endEditing:YES];
    }];
}

#pragma mark - 
- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon"]];
        _logoImageView.layer.cornerRadius = 3.0f;
        _logoImageView.clipsToBounds = YES;
    }
    return _logoImageView;
}


- (UITextField *)userNameTF {
    
    if (!_userNameTF) {
        
        _userNameTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        _userNameTF.keyboardType = UIKeyboardTypePhonePad;
        [_userNameTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _userNameTF.leftView = leftIcon;
        _userNameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userNameTF;
}

- (UITextField *)passwordTF {
    
    if (!_passwordTF) {
        
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入密码" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
        [_passwordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];

        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _passwordTF.leftView = leftIcon;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTF;
}

- (UIButton *)loginBtn {
    
    if (!_loginBtn) {
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        
        _loginBtn.layer.cornerRadius = 3.0f;
        _loginBtn.clipsToBounds = YES;

        WEAK_SELF(self);
        [_loginBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            [self loginRequest];
        }];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn{
    if (!_registerBtn) {
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        
        _registerBtn.layer.cornerRadius = 3.0f;
        _registerBtn.clipsToBounds = YES;
        
        WEAK_SELF(self);
        [_registerBtn bk_whenTapped:^{
            STRONG_SELF(self);
            
            KMDRegisterViewController *registerVC = [[KMDRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }];
    }
    return _registerBtn;
}

- (UIButton *)forgetPasswordBtn {
    
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"忘记密码?" titleColor:STRING_MID_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        
        WEAK_SELF(self);
        [_forgetPasswordBtn bk_whenTapped:^{
            STRONG_SELF(self);
            //忘记密码
            KMDForgetPasswordViewController *forgetPasswordVC = [[KMDForgetPasswordViewController alloc] init];
            [self.navigationController pushViewController:forgetPasswordVC animated:YES];
        }];
    }
    return _forgetPasswordBtn;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
