//
//  KMDForgetPasswordViewController.m
//  KMDance
//
//  Created by KM on 17/6/12017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDForgetPasswordViewController.h"
#import "BATGraditorButton.h"

#import "WHC_KeyboardManager.h"

@interface KMDForgetPasswordViewController ()

@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UITextField *userNameTF;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UIButton *requestCodeBtn;
@property (nonatomic,strong) BATGraditorButton *confirmBtn;

@end

@implementation KMDForgetPasswordViewController

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
    
}

-(BOOL)checkInput {
    
    [self.view endEditing: YES];
    
    if (self.passwordTF.text.length == 0) {
        [self showText:@"请输入密码"];
        return NO;
    }
    
    if(self.passwordTF.text.length > 18){
        [self showText:@"密码过长，请重新输入"];
        return NO;
    }
    if(self.passwordTF.text.length < 6){
        [self showText:@"密码过短，请重新输入"];
        return NO;
    }
    
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return NO;
    }
    
    return YES;
}

#pragma mark - NET
- (void)confirmRequest {
    
    [self checkInput];
    
    NSDictionary *para = @{@"VerifyCode":self.codeTF.text,@"NewPassword":self.passwordTF.text,@"PhoneNumber":self.userNameTF.text};
    
    [HTTPTool requestWithLoginURLString:@"/api/account/forgetchangepassword" parameters:para type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"修改成功" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)codeRequest {
    
    [self showProgress];
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.userNameTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    [self showProgress];
    
    [HTTPTool requestWithLoginURLString:[NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/2",self.userNameTF.text] parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
        [self dismissProgress];
        //倒计时
#warning 倒计时
        
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
    
    [self.view addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userNameTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];

    
    [self.view addSubview:self.requestCodeBtn];
    [self.requestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(@-5);
        make.centerY.equalTo(self.codeTF.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.codeTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
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
        
//        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon"]];
//        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
//        [leftIcon addSubview:searchIcon];
//        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(leftIcon);
//        }];
//        
//        _userNameTF.leftView = leftIcon;
//        _userNameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userNameTF;
}

- (UITextField *)codeTF {
    
    if (!_codeTF) {
        
        _codeTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入验证码" BorderStyle:UITextBorderStyleNone];
        _codeTF.keyboardType = UIKeyboardTypePhonePad;
        [_codeTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
    
    }
    return _codeTF;
}
- (UIButton *)requestCodeBtn {
    
    if (!_requestCodeBtn) {
        
        _requestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"获取验证码" titleColor:START_COLOR  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];

        WEAK_SELF(self);
        [_requestCodeBtn bk_whenTapped:^{
            STRONG_SELF(self);
            [self codeRequest];
        }];
    }
    return _requestCodeBtn;
}

- (UITextField *)passwordTF {
    
    if (!_passwordTF) {
        
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入密码" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
        [_passwordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
//        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon"]];
//        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
//        [leftIcon addSubview:searchIcon];
//        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(leftIcon);
//        }];
//        
//        _passwordTF.leftView = leftIcon;
//        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTF;
}

- (BATGraditorButton *)confirmBtn {
    
    if (!_confirmBtn) {
        
        _confirmBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 3.0f;
        _confirmBtn.layer.masksToBounds = YES;
        
        [_confirmBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _confirmBtn.enablehollowOut = YES;
        _confirmBtn.titleColor  = [UIColor whiteColor];
        WEAK_SELF(self);
        [_confirmBtn bk_whenTapped:^{
            
            STRONG_SELF(self);
            [self confirmRequest];
        }];
    }
    return _confirmBtn;
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
