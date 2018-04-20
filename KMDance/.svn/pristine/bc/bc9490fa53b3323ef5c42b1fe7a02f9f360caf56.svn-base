//
//  KMDPersonInfoViewController.m
//  KMDance
//
//  Created by KM on 17/5/242017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDPersonInfoViewController.h"

#import "KMDPersonAvatarTableViewCell.h"
#import "KMDPersonInfoTableViewCell.h"

#import "BATPerson.h"

#import "KMDPersonEditorViewController.h"

#import "TZImagePickerController.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"

#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <ZLPhotoBrowser/ZLPhotoConfiguration.h>

static  NSString * const INFO_CELL = @"KMDPersonInfoTableViewCell";
static  NSString * const AVATAR_CELL = @"KMDPersonAvatarTableViewCell";

@interface KMDPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,STPickerSingleDelegate,STPickerDateDelegate>

@property (nonatomic,strong) UITableView *infoTableView;
@property (nonatomic,copy) NSArray *dataArray;
@property (nonatomic,strong) BATPerson *person;

@property (nonatomic,strong) ZLPhotoActionSheet *photoActionSheet;

@end

@implementation KMDPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self layoutPages];
    
    [self personInfoListRequest];
    
    self.dataArray = @[@"头像",@"昵称",@"性别",@"出生日期",@"手机号码",];

    WEAK_SELF(self);
    [self setChangePersonInfoBlock:^(KMDPersonInfoEditorType type, NSString *content){
        STRONG_SELF(self);
        switch (type) {
            case kKMDUserName:
                self.person.Data.UserName = content;
                break;
            case kKMDPhone:
                self.person.Data.PhoneNumber = content;
                break;
        }
        
        [self requestChangePersonInfo];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //头像
        KMDPersonAvatarTableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:AVATAR_CELL forIndexPath:indexPath];
        avatarCell.nameLabel.text = self.dataArray[indexPath.row];
        [avatarCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"avatar_01"]];
        WEAK_SELF(self);
        [avatarCell.avatarImageView bk_whenTapped:^{
            
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        return avatarCell;
    }
    else {
        
        KMDPersonInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:INFO_CELL forIndexPath:indexPath];
        infoCell.nameLabel.text = self.dataArray[indexPath.row];
        switch (indexPath.row) {
            case 1:
            {
                infoCell.contentLabel.text = self.person.Data.UserName;
            }
                break;
            case 2:
            {
                infoCell.contentLabel.text = [self.person.Data.Sex isEqualToString:@"1"] ? @"男":@"女";
            }
                break;
            case 3:
            {
                infoCell.contentLabel.text = [self.person.Data.Birthday substringToIndex:10];
            }
                break;
            case 4:
            {
                infoCell.contentLabel.text = self.person.Data.PhoneNumber;
                infoCell.rightArrowImageView.hidden = YES;
            }
                break;
        }
        return infoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            //头像
        }
            break;
        case 1:
        {
            //昵称
            KMDPersonEditorViewController *editorVC = [[KMDPersonEditorViewController alloc] init];
            editorVC.title = @"修改昵称";
            editorVC.type = kKMDUserName;
            editorVC.content = self.person.Data.UserName;
            [self.navigationController pushViewController:editorVC animated:YES];
        }
            break;
        case 2:
        {
            //性别
            [self presentPickerView];
        }
            break;
        case 3:
        {
            [self presentDatePickerView];
        }
            break;
        case 4:
        {
            //手机号码
//            KMDPersonEditorViewController *editorVC = [[KMDPersonEditorViewController alloc] init];
//            editorVC.title = @"修改手机号码";
//            editorVC.type = kKMDPhone;
//            editorVC.content = self.person.Data.PhoneNumber;
//            [self.navigationController pushViewController:editorVC animated:YES];
        }
            break;
    }
}

#pragma mark - STPickerDateDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)year];
    NSString *monthStr;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    else {
        monthStr = [NSString stringWithFormat:@"%ld",(long)month];

    }
    NSString *dayStr;

    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    else {
        dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    }

    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
    
    self.person.Data.Birthday = dateString;
    [self requestChangePersonInfo];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    self.person.Data.Sex = [selectedTitle isEqualToString:@"男"] ? @"1" : @"0";;
    [self requestChangePersonInfo];
    
}

#pragma mark - private
- (void)getPhotosFromLocal {
    
    [self.photoActionSheet showPhotoLibrary];
    
    /*
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    tzImagePickerVC.barItemTextColor = STRING_DARK_COLOR;
    
    tzImagePickerVC.showSelectBtn = NO;
    tzImagePickerVC.allowCrop = YES;
    tzImagePickerVC.needCircleCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = SCREEN_WIDTH - 2 * left;
    NSInteger top = (SCREEN_HEIGHT- widthHeight) / 2;
    tzImagePickerVC.cropRect = CGRectMake(left, top, widthHeight, widthHeight);

    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        UIImage *avatar = [photos firstObject];
        
        if (isSelectOriginalPhoto == NO) {
            avatar = [Tools compressImageWithImage:avatar ScalePercent:0.5];
        }
        
        [HTTPTool requestUploadImageToBATWithImages:@[avatar] success:^(NSArray *imageArray) {
            
            [self dismissProgress];
            
            NSDictionary *dic = [imageArray firstObject];
            //更改个人信息
            
            self.person.Data.PhotoPath = dic[@"url"];
            
            [self requestChangePersonInfo];
            
        } failure:^(NSError *error) {
            
        } uploadProgress:^(NSProgress *progress) {
            
            [self showProgres:progress.fractionCompleted];
        }];
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
     */
    
}

- (void)presentPickerView{
    
    NSMutableArray *dataM = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    //设置默认选中的按钮
    pickerSingle.buttonRight.selected = YES;
    /** 2.边线,选择器和上方tool之间的边线 */
    pickerSingle.lineView = [[UIView alloc]init];
    //设置按钮边框颜色
    pickerSingle.borderButtonColor = [UIColor whiteColor];
    //设置数据源
    [pickerSingle setArrayData:dataM];
    //设置弹出视图的标题
    [pickerSingle setTitle:@"请选择"];
    //设置视图的位置为屏幕下方
    [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
    
}

- (void)presentDatePickerView {
    
    STPickerDate *datePicker = [[STPickerDate alloc] init];

    [datePicker selectCustomDate:[Tools dateWithDateString:self.person.Data.Birthday Format:@"yyyy-MM-dd HH:mm:ss"]];
    
    //设置默认选中的按钮
    datePicker.buttonRight.selected = YES;
    /** 2.边线,选择器和上方tool之间的边线 */
    datePicker.lineView = [[UIView alloc]init];
    //设置按钮边框颜色
    datePicker.borderButtonColor = [UIColor whiteColor];
    //设置弹出视图的标题
    [datePicker setTitle:@"请选择出生日期"];
    //设置视图的位置为屏幕下方
    [datePicker setContentMode:STPickerContentModeBottom];
    [datePicker setDelegate:self];
    [datePicker show];
}

#pragma mark - NET
- (void)personInfoListRequest {
    
    [HTTPTool requestWithLoginURLString:@"/api/Patient/Info" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
        self.person = [BATPerson mj_objectWithKeyValues:responseObject];
        [self.infoTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

- (void)requestChangePersonInfo
{
    NSDictionary * dic = @{
                           @"PhotoPath":self.person.Data.PhotoPath,
                           @"UserName":self.person.Data.UserName,
                           @"Sex":self.person.Data.Sex,
                           @"Birthday":[NSString stringWithFormat:@"%@ 00:00:00",self.person.Data.Birthday],
                           @"Signature":self.person.Data.Signature,
                           @"PatientID":[NSNumber numberWithInteger:self.person.Data.PatientID],
                           @"GeneticDisease":self.person.Data.GeneticDisease,
                           @"Allergies":self.person.Data.Allergies,
                           @"Anamnese":self.person.Data.Anamnese,
                           @"PhoneNumber":self.person.Data.PhoneNumber
                           };
    
    DDLogDebug(@"dic ==== %@",dic);
    [HTTPTool requestWithLoginURLString:@"/api/Patient/Info" parameters:dic type:kXMHTTPMethodPOST success:^(id responseObject) {
        
        [self.infoTableView reloadData];
    } failure:^(NSError *error) {
        
        [self personInfoListRequest];
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"个人信息";
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
#pragma mark - getter
- (UITableView *)infoTableView {
    
    if (!_infoTableView) {
        
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _infoTableView.rowHeight = 55;
        
        _infoTableView.tableFooterView = [[UIView alloc] init];
        [_infoTableView registerClass:[KMDPersonInfoTableViewCell class] forCellReuseIdentifier:INFO_CELL];
        [_infoTableView registerClass:[KMDPersonAvatarTableViewCell class] forCellReuseIdentifier:AVATAR_CELL];

        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        
        
    }
    return _infoTableView;
}

- (ZLPhotoActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
        ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
        configuration.maxSelectCount = 1;
        configuration.useSystemCamera = NO;
        
        /*
         //以下参数为自定义参数，均可不设置，有默认值
         configuration.sortAscending = self.sortSegment.selectedSegmentIndex==0;
         configuration.allowSelectImage = self.selImageSwitch.isOn;
         configuration.allowSelectGif = self.selGifSwitch.isOn;
         configuration.allowSelectVideo = self.selVideoSwitch.isOn;
         configuration.allowSelectLivePhoto = self.selLivePhotoSwitch.isOn;
         configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
         configuration.allowEditImage = self.allowEditSwitch.isOn;
         configuration.allowEditVideo = self.allowEditVideoSwitch.isOn;
         configuration.allowSlideSelect = self.allowSlideSelectSwitch.isOn;
         configuration.allowMixSelect = self.mixSelectSwitch.isOn;
         configuration.allowDragSelect = self.allowDragSelectSwitch.isOn;
         //设置相册内部显示拍照按钮
         configuration.allowTakePhotoInLibrary = self.takePhotoInLibrarySwitch.isOn;
         //设置在内部拍照按钮上实时显示相机俘获画面
         configuration.showCaptureImageOnTakePhotoBtn = self.showCaptureImageSwitch.isOn;
         //设置照片最大预览数
         configuration.maxPreviewCount = self.previewTextField.text.integerValue;
         //设置照片最大选择数
         configuration.maxSelectCount = self.maxSelCountTextField.text.integerValue;
         //设置允许选择的视频最大时长
         configuration.maxVideoDuration = self.maxVideoDurationTextField.text.integerValue;
         //设置照片cell弧度
         configuration.cellCornerRadio = self.cornerRadioTextField.text.floatValue;
         //单选模式是否显示选择按钮
         //    configuration.showSelectBtn = YES;
         //是否在选择图片后直接进入编辑界面
         configuration.editAfterSelectThumbnailImage = self.editAfterSelectImageSwitch.isOn;
         //设置编辑比例
         //    configuration.clipRatios = @[GetClipRatio(1, 1)];
         //是否在已选择照片上显示遮罩层
         configuration.showSelectedMask = self.maskSwitch.isOn;
         //颜色，状态栏样式
         //    configuration.selectedMaskColor = [UIColor purpleColor];
         //    configuration.navBarColor = [UIColor orangeColor];
         //    configuration.navTitleColor = [UIColor blackColor];
         //    configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
         //    configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
         //    configuration.bottomViewBgColor = [UIColor blackColor];
         //    configuration.statusBarStyle = UIStatusBarStyleDefault;
         //是否允许框架解析图片
         configuration.shouldAnialysisAsset = self.allowAnialysisAssetSwitch.isOn;
         //框架语言
         configuration.languageType = self.languageSegment.selectedSegmentIndex;
         //是否使用系统相机
         //    configuration.useSystemCamera = YES;
         //    configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
         */
#pragma mark - required
        _photoActionSheet.configuration = configuration;
        //如果调用的方法没有传sender，则该属性必须提前赋值
        _photoActionSheet.sender = self;
        //记录上次选择的图片
        _photoActionSheet.arrSelectedAssets = nil;
        
        WEAK_SELF(self);
        [_photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            
            STRONG_SELF(self);
            
            UIImage *avatar = [images firstObject];
            
            if (isOriginal == NO) {
                avatar = [Tools compressImageWithImage:avatar ScalePercent:0.5];
            }
            
            [HTTPTool requestUploadImageToBATWithImages:@[avatar] success:^(NSArray *imageArray) {
                
                [self dismissProgress];
                
                NSDictionary *dic = [imageArray firstObject];
                //更改个人信息
                
                self.person.Data.PhotoPath = dic[@"url"];
                
                [self requestChangePersonInfo];
                
            } failure:^(NSError *error) {
                
            } uploadProgress:^(NSProgress *progress) {
                
                [self showProgres:progress.fractionCompleted];
            }];
        }];
    }
    
    return _photoActionSheet;
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
