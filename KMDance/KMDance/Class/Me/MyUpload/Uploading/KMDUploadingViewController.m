//
//  KMDUploadingViewController.m
//  KMDance
//
//  Created by KM on 17/8/42017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadingViewController.h"

#import "KMDUploadingTableViewCell.h"

#import "KMDUploadCenter.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Reachability.h"

static  NSString * const UPLOADING_CELL = @"KMDUploadingTableViewCell.h";

@interface KMDUploadingViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,KMDUploadProgressDelegate>

@property (nonatomic,strong) UITableView *uploadingTableView;

@property (nonatomic,strong) NSDate *lastDate;

@end

@implementation KMDUploadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    [KMDUploadCenter sharedKMDUploadCenter].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [KMDUploadCenter sharedKMDUploadCenter].dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDUploadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UPLOADING_CELL forIndexPath:indexPath];
    
    KMDUploadFile *file = [KMDUploadCenter sharedKMDUploadCenter].dataArray[indexPath.row];
    
    [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:file.imageUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
    cell.danceTitleLabel.text = file.videoName;
    
    if (file.isPause == YES) {
        cell.pauseButton.selected = YES;
        cell.pauseStatusButton.selected = YES;

    }
    else {
        cell.pauseButton.selected = NO;
        cell.pauseStatusButton.selected = NO;

    }
    
    cell.progressView.progress = ([file.fileArr indexOfObject:@"wait"]/[file.trunks floatValue]);
    
    //暂停
    WEAK_SELF(cell);
    [cell setPauseBlock:^{
        
        STRONG_SELF(cell);
        cell.pauseButton.selected = !cell.pauseButton.selected;
        cell.pauseStatusButton.selected = !cell.pauseStatusButton.selected;

        file.isPause = !file.isPause;
        
        if ([self getCurrentReachStatus] == ReachableViaWWAN && file.isPause == NO) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您正在使用移动数据网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                cell.pauseButton.selected = !cell.pauseButton.selected;
                cell.pauseStatusButton.selected = !cell.pauseStatusButton.selected;
                
                file.isPause = !file.isPause;
            }];
            UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([file.filePath isEqualToString:[KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.filePath]) {
                    
                    [KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.isPause = YES;
                }
                
                if ([KMDUploadCenter sharedKMDUploadCenter].isUploading == NO) {
                    
                    [[KMDUploadCenter sharedKMDUploadCenter] startUpload];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:uploadAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        if ([file.filePath isEqualToString:[KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.filePath]) {
            
            [KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.isPause = YES;
        }

        if ([KMDUploadCenter sharedKMDUploadCenter].isUploading == NO) {
            
            [[KMDUploadCenter sharedKMDUploadCenter] startUpload];
        }
    }];
    
    WEAK_SELF(self);
    [cell setDeleteBlock:^{
        
        STRONG_SELF(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除任务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            
            [[NSFileManager defaultManager] removeItemAtPath:[[NSHomeDirectory() stringByAppendingString:@"/tmp/"] stringByAppendingString:file.filePath] error:nil];

            [[KMDUploadCenter sharedKMDUploadCenter].dataArray removeObjectAtIndex:indexPath.row];

            if ([file.filePath isEqualToString:[KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.filePath]) {
                
                [KMDUploadCenter sharedKMDUploadCenter].currentUploadFile.isPause = YES;
            }
            
            [self.uploadingTableView reloadData];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:uploadAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    return cell;
}

#pragma mark - KMDUploadProgressDelegate
- (void)uploadProgress:(double)progress uploadFile:(KMDUploadFile *)file {
    
    DDLogDebug(@"%f",progress);
    
    NSUInteger row = INT32_MAX;

    for (KMDUploadFile *tmpFile in [KMDUploadCenter sharedKMDUploadCenter].dataArray) {
        
        if ([tmpFile.filePath isEqualToString:file.filePath]) {
            row = [[KMDUploadCenter sharedKMDUploadCenter].dataArray indexOfObject:tmpFile];
            break;
        }
    }
    
    KMDUploadingTableViewCell *cell = (KMDUploadingTableViewCell *)[self.uploadingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.progressView.progress = progress;
    
    if (file.isPause == YES) {
        cell.rateLabel.text = @"";
        return;
    }
    
    NSDate *now = [NSDate date];
    if (self.lastDate) {
        NSTimeInterval timeInterval = [now timeIntervalSinceDate:self.lastDate];

        cell.rateLabel.text = [NSString stringWithFormat:@"%.1fKB/s", 64.0/timeInterval];
        self.lastDate = now;
    }
    else {
        self.lastDate = [NSDate date];
    }
}

- (void)uploadPauseWithUploadFile:(KMDUploadFile *)file {
    
    NSUInteger row = INT32_MAX;
    
    for (KMDUploadFile *tmpFile in [KMDUploadCenter sharedKMDUploadCenter].dataArray) {
        
        if ([tmpFile.filePath isEqualToString:file.filePath]) {
            row = [[KMDUploadCenter sharedKMDUploadCenter].dataArray indexOfObject:tmpFile];
            break;
        }
    }
    
    KMDUploadingTableViewCell *cell = (KMDUploadingTableViewCell *)[self.uploadingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    
    cell.pauseButton.selected = YES;
    cell.pauseStatusButton.selected = YES;
}

- (void)uploadFinishWithUploadFile:(KMDUploadFile *)file {
    
    [self.uploadingTableView reloadData];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *contentStr = @"您没有上传任何内容哦，快去看看吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: STRING_MID_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    return attrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"no_collection"];
    
}

#pragma mark - private
- (NetworkStatus)getCurrentReachStatus {
    
    Reachability*reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [reach currentReachabilityStatus];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.uploadingTableView];
    [self.uploadingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)uploadingTableView {
    
    if (!_uploadingTableView) {
        
        _uploadingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _uploadingTableView.showsVerticalScrollIndicator = NO;
        _uploadingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _uploadingTableView.backgroundColor = [UIColor whiteColor];
        _uploadingTableView.rowHeight = 90;
        
        [_uploadingTableView registerClass:[KMDUploadingTableViewCell class] forCellReuseIdentifier:UPLOADING_CELL];
        
        _uploadingTableView.delegate = self;
        _uploadingTableView.dataSource = self;
        
        _uploadingTableView.emptyDataSetDelegate = self;
        _uploadingTableView.emptyDataSetSource = self;
    }
    return _uploadingTableView;
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
