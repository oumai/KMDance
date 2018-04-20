//
//  KMDChangePasswordViewController.m
//  KMDance
//
//  Created by KM on 17/6/12017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDChangePasswordViewController.h"
#import "BATGraditorButton.h"

#import "BATLoginModel.h"
#import "BATBaseModel.h"

#import "AppDelegate+KMDLoginCategory.h"//登录

#import "WHC_KeyboardManager.h"

@interface KMDChangePasswordViewController ()

@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UITextField *oldPasswodTF;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UITextField *confirmPasswordTF;
@property (nonatomic,strong) BATGraditorButton *confirmBtn;

@end

@implementation KMDChangePasswordViewController

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
    
    if (![self.passwordTF.text isEqualToString:self.confirmPasswordTF.text]) {
        [self showText:@"两次密码输入不一致"];
        return NO;
    }
    
    return YES;
}


#pragma mark - NET
-(void)changePassWordResquest {
    
    [self checkInput];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
    BATLoginModel * login = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    NSDictionary * para = @{
                            @"AccountID":@(login.Data.ID),
                            @"OldPassword":self.oldPasswodTF.text,
                            @"NewPassword":self.passwordTF.text,
                            @"ConfirmPassword":self.confirmPasswordTF.text
                            };
    
    [HTTPTool requestWithLoginURLString:@"/api/Account/ChangePassword" parameters:para type:kXMHTTPMethodPOST success:^(id responseObject) {
        BATBaseModel * success = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (success.ResultCode == 0) {
            [self showSuccessWithText:@"修改成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self bk_performBlock:^(id obj) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate kmd_logout];
                
            } afterDelay:1];
            
        }
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
    
    [self.view addSubview:self.oldPasswodTF];
    [self.oldPasswodTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.oldPasswodTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    
    [self.view addSubview:self.confirmPasswordTF];
    [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 55));
    }];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.confirmPasswordTF.mas_bottom).offset(30);
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


- (UITextField *)oldPasswodTF {
    
    if (!_oldPasswodTF) {
        
        _oldPasswodTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入旧密码" BorderStyle:UITextBorderStyleNone];
        _oldPasswodTF.secureTextEntry = YES;
        [_oldPasswodTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
    
    }
    return _oldPasswodTF;
}

- (UITextField *)confirmPasswordTF {
    
    if (!_confirmPasswordTF) {
        
        _confirmPasswordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请确认密码" BorderStyle:UITextBorderStyleNone];
        _confirmPasswordTF.secureTextEntry = YES;
        [_confirmPasswordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
    }
    return _confirmPasswordTF;
}


- (UITextField *)passwordTF {
    
    if (!_passwordTF) {
        
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:BASE_COLOR placeholder:@"请输入新密码" BorderStyle:UITextBorderStyleNone];
        _passwordTF.secureTextEntry = YES;
        [_passwordTF setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH-30 height:0.5];
        
    
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
            [self changePassWordResquest];
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
