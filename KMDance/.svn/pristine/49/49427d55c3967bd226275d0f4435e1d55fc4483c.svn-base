//
//  SendPublishViewController.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATOpinionViewController.h"
#import "BATMenusModel.h"
#import "BATBaseModel.h"

//#import "StarsView.h"
#import "YYText.h"

#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "TZImagePickerController.h"
#import "BATUploadImageModel.h"
#import "TZImageManager.h"
#import "BATOpinionFooterView.h"
#import "BATFeedbackCell.h"
@interface BATOpinionViewController () <YYTextViewDelegate,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//@property (nonatomic,strong) YYTextView *feedBackContentTextView;
//@property (nonatomic,strong) UILabel *wordNumberLabel;


@property (nonatomic,strong) UITableView *tableView;

/**
 *  图片数组
 */
@property (nonatomic,strong) NSMutableArray *picDataSource;

/**
 *  待上传的图片数组URL
 */
@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

/**
 临时数据
 */
@property (nonatomic,strong) NSMutableArray *tempPicArray;

/**
 意见反馈
 */
@property (nonatomic,copy) NSString *feekback;
/**
 邮箱
 */
@property (nonatomic,copy) NSString *emailStr;
/**
 提交
 */
@property (nonatomic,strong) BATOpinionFooterView *opinionFooterView;

@end

@implementation BATOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    [self.tableView registerClass:[BATFeedbackCell class] forCellReuseIdentifier:NSStringFromClass([BATFeedbackCell class])];
    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
//    rightItem.enabled = NO;
//    self.navigationItem.rightBarButtonItem = rightItem;
//    
//    if (self.navigationController.viewControllers.count == 1) {
//        WEAK_SELF(self);
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"关闭" style:UIBarButtonItemStyleDone handler:^(id sender) {
//            STRONG_SELF(self);
//            [self.view endEditing:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        self.navigationItem.leftBarButtonItem = backItem;
//    }
    
    [self layoutPages];
    
    [self.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"BATWriteTextViewTableViewCell"];
    [self.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"BATAddPicTableViewCell"];
    
//    [self.feedBackContentTextView becomeFirstResponder];
    
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    _feekback = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 45;
    }else if (indexPath.row == 1) {
        return 150;
    }else{
        NSInteger picCount = _picDataSource.count < 9 ? _picDataSource.count + 1 : _picDataSource.count;
        
        if (picCount <= 4) {
            return ItemWidth + 30;
        } else if (picCount <= 8) {
            return 2 * ItemWidth + 10 + 30;
        } else {
            return 3 * ItemWidth + 20 + 30;
        }

    }
    
  }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BATFeedbackCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATFeedbackCell class])];
//        feedbackCell.backgroundColor = [UIColor redColor];
        return feedbackCell;
    }else if (indexPath.row == 1) {
        BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATWriteTextViewTableViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.placeholderText = @"您的意见和建议，对我们非常重要";
        cell.textView.text = _feekback;
        cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/800",(unsigned long)_feekback.length];
        return cell;
    }else {
        
    BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddPicTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.titleLabel.text = @"添加照片";
    cell.messageLabel.text = @"具体反馈页面或其它图片";
    [cell reloadCollectionViewData:_picDataSource];
    return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    BATWriteTextViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (textView.text.length > 0) {
        _opinionFooterView.submitBtn.enabled = YES;
    } else if (_picDataSource.count == 0 && textView.text.length == 0) {
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
//    if (textView.text.length > 0) {
//        _opinionFooterView.submitBtn.enabled = YES;
//    }
//    else if (textView.text.length <= 0) {
//        _opinionFooterView.submitBtn.enabled = NO;
//    }
    
    if (textView.text.length > 800) {
        [self showText:@"最多输入800个字"];
        textView.text = [textView.text substringToIndex:800];
    }
    _feekback = textView.text;
    cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/800",(unsigned long)_feekback.length];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromCamera];
        }];
        
        UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoGalleryAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self deletePic:indexPath];
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        WEAK_SELF(self);
//        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            STRONG_SELF(self);
//            [self deletePic:indexPath];
//        }];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertController addAction:deleteAction];
//        [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
        if (!error) {
            [_tempPicArray removeAllObjects];
            [_tempPicArray addObject:image];
            [self requestUpdateImages];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

#pragma mark - Action

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - _picDataSource.count) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    tzImagePickerVC.barItemTextColor = STRING_DARK_COLOR;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);
        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (!isSelectOriginalPhoto) {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                } else {
                    [_tempPicArray addObject:image];
                }
            }
            
            [self requestUpdateImages];
        }
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark 删除图片11
- (void)deletePic:(NSIndexPath *)indexPath
{
    [_picDataSource removeObjectAtIndex:indexPath.row];
    [_dynamicImgArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
    if (_picDataSource.count == 0 && _feekback.length == 0 ) {
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
}

- (void)submitBtnAction:(UIButton *)button
{
    BATFeedbackCell *emailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _emailStr = emailCell.textFiled.text;

    if (![Tools checkEmail:_emailStr]) {
        [self showText:@"邮箱格式错误"];
        return;
    }
    if (_picDataSource.count !=0 || _feekback.length !=0) {
        _opinionFooterView.submitBtn.enabled = NO;
    }else{
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
    
    if (self.className.length == 0) {
        //没有从别的界面过来
        self.className = @"";
        self.titleName = @"";
    }
    
    [self feedBackRequest];

}

- (void)hiddenKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - NET

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    [HTTPTool requestUploadImageToBATWithImages:_tempPicArray success:^(NSArray *imageArray) {
        
        [self dismissProgress];
        
        DDLogDebug(@"imageArray %@",imageArray);
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
        [self.tableView reloadData];
        
        _opinionFooterView.submitBtn.enabled = YES;
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    } uploadProgress:^(NSProgress *progress) {
        [self showProgres:progress.fractionCompleted];

    }];
}

#pragma mark - NET
- (void) feedBackRequest {
    
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    
    for (BATImage *batImage in _dynamicImgArray) {
        [imgs addObject:batImage.url];
    }
    
    [HTTPTool requestWithLoginURLString:@"/api/FeedBack/InsertFeedBack"
                        parameters:@{
                                     @"OpinionsContent":_feekback,
                                     @"MenuName":self.className,
                                     @"Email":_emailStr,
                                     @"Source":@"iOSKMDance",
                                     @"Version":[Tools getLocalVersion],
                                     @"MenuId":@(1),
                                     @"Title":self.titleName.length==0?@"":self.titleName,
                                     @"PictureUrl":[imgs componentsJoinedByString:@","]
                                     }
                              type:kXMHTTPMethodPOST
                           success:^(id responseObject) {
                               _opinionFooterView.submitBtn.enabled = YES;
                               
                               [self showSuccessWithText:@"我们已收到您的反馈意见，谢谢。"];
                               [self bk_performBlock:^(id obj) {
                                   [self.view endEditing:YES];
                                   [self.navigationController popViewControllerAnimated:YES];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               } afterDelay:1.5];
                               
                           } failure:^(NSError *error) {
                               [self showErrorWithText:error.localizedDescription];
                               _opinionFooterView.submitBtn.enabled = YES;
                           }];
    
}

#pragma mark - layout
- (void)layoutPages {

    [self.view addSubview:self.tableView];
    
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableFooterView = self.opinionFooterView;
    
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (BATOpinionFooterView *)opinionFooterView
{
    if (!_opinionFooterView) {
        _opinionFooterView = [[BATOpinionFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.0f)];
        [_opinionFooterView.submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _opinionFooterView;
}

@end
