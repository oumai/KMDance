//
//  KMDRegisterViewController.m
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDRegisterViewController.h"
//#import "BATGraditorButton.h"

#import "BATLoginModel.h"

#import "AppDelegate+KMDLoginCategory.h"

#import "WHC_KeyboardManager.h"

@interface KMDRegisterViewController ()

@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UITextField *confirmPasswordTF;
@property (nonatomic,strong) UIButton *requestCodeBtn;
//@property (nonatomic,strong) BATGraditorButton *registerBtn;
@property (nonatomic,strong) UIButton *registerBtn;

@end

@implementation KMDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(BOOL)checkInput {
    
    [self.view endEditing: YES];
    //判断输入框是否为空。(即无输入)
    if (self.phoneTF.text.length == 0) {
        [self showErrorWithText:@"请输入手机号"];
        return NO;
    }
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showErrorWithText:@"请输入正确的手机号"];
        return NO;
    }
    
    
    if (self.codeTF.text.length == 0) {
        [self showErrorWithText:@"请输入验证码"];
        return NO;
    }
    if (self.passwordTF.text.length == 0) {
        [self showErrorWithText:@"请输入密码"];
        return NO;
    }
    
    if(self.passwordTF.text.length > 18){
        [self showErrorWithText:@"密码过长，请重新输入"];
        return NO;
    }
    if(self.passwordTF.text.length < 6){
        [self showErrorWithText:@"密码过短，请重新输入"];
        return NO;
    }
    
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showErrorWithText:@"密码中不能包含空格"];
        return NO;
    }
    
    if (![self.passwordTF.text isEqualToString:self.confirmPasswordTF.text]) {
        [self showErrorWithText:@"两次密码输入不一致"];
        return NO;
    }
    
    return YES;
}

#pragma mark - NET
- (void)codeRequest {
    
    //判断输入的手机号码是否符合规范
    if (![Tools checkPhoneNumber:self.phoneTF.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    
    [self showProgress];
    
    [HTTPTool requestWithLoginURLString:[NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/1",self.phoneTF.text] parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
        [self dismissProgress];
        //倒计时
#warning 倒计时
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}



- (void)registerRequest {
    
    if (![self checkInput]) {
        
        return;
    }
    
    NSDictionary *para = @{@"VerificationCode":self.codeTF.text,@"Password":self.passwordTF.text,@"PhoneNumber":self.phoneTF.text,@"AccountLevel":@"广场舞"};
    
    [self showProgress];
    
    [HTTPTool requestWithLoginURLString:@"/api/NetworkMedical/UserRegister" parameters:para type:kXMHTTPMethodPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"注册成功"];
        
        //talkingData注册分析
        [TalkingData onRegister:self.phoneTF.text type:TDAccountTypeRegistered name:@""];

        BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];
        
        if (login.ResultCode == 0) {
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate successActionWithLogin:login userName:self.phoneTF.text password:self.passwordTF.text];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}


#pragma mark - layout

- (void)layoutPages {
    
    self.title = @"注册";

    WEAK_SELF(self);
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.requestCodeBtn];
    [self.requestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(@-5);
        make.centerY.equalTo(self.phoneTF.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.view addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.codeTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
    }];
    
    [self.view addSubview:self.confirmPasswordTF];
    [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.confirmPasswordTF.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 50));
    }];
    
    [self.view bk_whenTapped:^{
        STRONG_SELF(self);
        [self.view endEditing:YES];
    }];
}


#pragma mark - getter
- (UITextField *)phoneTF {
    
    if (!_phoneTF) {
        
        _phoneTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        [_phoneTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
        UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        label.text = @"手机号码";
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [leftIcon addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        _phoneTF.leftView = leftIcon;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _phoneTF;
}

- (UITextField *)codeTF {
    
    if (!_codeTF) {
        
        _codeTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入验证码" BorderStyle:UITextBorderStyleNone];
        _codeTF.keyboardType = UIKeyboardTypePhonePad;
        [_codeTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
        UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        label.text = @"验证码";
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [leftIcon addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        _codeTF.leftView = leftIcon;
        _codeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _codeTF;
}

- (UITextField *)passwordTF {
    
    if (!_passwordTF) {
        
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入登录密码（6-18位）" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
        [_passwordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
        UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        label.text = @"登录密码";
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [leftIcon addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        _passwordTF.leftView = leftIcon;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTF;
}

- (UITextField *)confirmPasswordTF {
    
    if (!_confirmPasswordTF) {
        
        _confirmPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请再次输入密码" BorderStyle:UITextBorderStyleNone];
        _confirmPasswordTF.secureTextEntry = YES;
        [_confirmPasswordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];

        UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        label.text = @"确认密码";
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [leftIcon addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        _confirmPasswordTF.leftView = leftIcon;
        _confirmPasswordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _confirmPasswordTF;
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
            
            [self registerRequest];
        }];
    }
    return _registerBtn;
}

- (UIButton *)requestCodeBtn {
    
    if (!_requestCodeBtn) {
        
        _requestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"获取验证码" titleColor:[UIColor whiteColor] backgroundColor:END_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:13]];
        _requestCodeBtn.layer.cornerRadius = 15.0f;
        WEAK_SELF(self);
        [_requestCodeBtn bk_whenTapped:^{
            STRONG_SELF(self);
            [self codeRequest];
        }];
    }
    return _requestCodeBtn;
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
