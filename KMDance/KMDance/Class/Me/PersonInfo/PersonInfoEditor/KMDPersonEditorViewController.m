//
//  KMDPersonEditorViewController.m
//  KMDance
//
//  Created by KM on 17/5/242017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDPersonEditorViewController.h"

#import "KMDPersonInfoViewController.h"

@interface KMDPersonEditorViewController ()

@property (nonatomic,strong) UITextField *inputTF;

@end

@implementation KMDPersonEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout
- (void)layoutPages {
    
    
    [self.view addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.mas_equalTo(40);
    }];
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        STRONG_SELF(self);
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[KMDPersonInfoViewController class]]) {
                KMDPersonInfoViewController *personInfoVC = (KMDPersonInfoViewController *)VC;
                personInfoVC.changePersonInfoBlock(self.type, self.inputTF.text);
                break;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

}
#pragma mark - getter
- (UITextField *)inputTF {
    
    if (!_inputTF) {
        
        _inputTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputTF.font = [UIFont systemFontOfSize:16];
        _inputTF.textColor = BASE_COLOR;
        _inputTF.text = self.content;
        _inputTF.backgroundColor = [UIColor whiteColor];
        
        switch (self.type) {
            case kKMDPhone:
                _inputTF.keyboardType = UIKeyboardTypePhonePad;
                break;
            case kKMDUserName:

                break;
        }
        switch (self.type) {
            case kKMDUserName:
            {
                _inputTF.placeholder = @"请输入昵称";
            }
                break;
            case kKMDPhone:
            {
                _inputTF.placeholder = @"请输入手机号码";
            }
                break;
        }
    }
    return _inputTF;
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
