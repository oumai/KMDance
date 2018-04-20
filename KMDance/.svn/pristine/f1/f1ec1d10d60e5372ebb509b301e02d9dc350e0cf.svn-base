//
//  KMDSettingViewController.m
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSettingViewController.h"

#import "KMDSettingTableViewCell.h"

#import "BATOpinionViewController.h"
#import "KMDChangePasswordViewController.h"

#import "AppDelegate+KMDLoginCategory.h"

static  NSString * const SETTING_CELL = @"KMDSettingTableViewCell";

@interface KMDSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *settingTableView;
@property (nonatomic,copy) NSArray *dataArray;

@end

@implementation KMDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = @[@"修改密码",@"反馈意见",@"清理缓存"];
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTING_CELL forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            KMDChangePasswordViewController *changePasswordVC = [[KMDChangePasswordViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changePasswordVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            BATOpinionViewController *opinionVC = [[BATOpinionViewController alloc] init];
            [self.navigationController pushViewController:opinionVC animated:YES];
        }
            break;
        case 2:
        {
            
            WEAK_SELF(self)
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                STRONG_SELF(self);
                [self showProgress];
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [self showSuccessWithText:@"清理完毕"];
                }];
            }];
            
            // Add the actions.
            [alertController addAction:otherAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
    }
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"设置";
    
    [self.view addSubview:self.settingTableView];
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)settingTableView {
    
    if (!_settingTableView) {
        
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_settingTableView registerClass:[KMDSettingTableViewCell class] forCellReuseIdentifier:SETTING_CELL];
        
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingTableView.rowHeight = 45;
        
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        loginOutBtn.titleLabel.textColor  = [UIColor whiteColor];
        [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        loginOutBtn.layer.cornerRadius = 3.f;
        loginOutBtn.clipsToBounds = YES;
        [tableFooterView addSubview:loginOutBtn];
        [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80, 40));
        }];
        
        [loginOutBtn bk_whenTapped:^{
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate kmd_logout];
        }];


        
        _settingTableView.tableFooterView = tableFooterView;
    }
    return _settingTableView;
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
