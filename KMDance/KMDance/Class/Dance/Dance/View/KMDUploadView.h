//
//  KMDUploadView.h
//  KMDance
//
//  Created by KM on 17/8/72017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDUploadView : UIView

@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UILabel *cameraLabel;
@property (nonatomic,strong) UIButton *videoBtn;
@property (nonatomic,strong) UILabel *videoLabel;

@property (nonatomic,copy) void(^cameraClickBlock)(void);
@property (nonatomic,copy) void(^videoClickBlock)(void);

@end
