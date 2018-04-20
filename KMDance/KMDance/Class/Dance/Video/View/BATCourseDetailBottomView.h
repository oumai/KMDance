//
//  BATCourseDetailBottomView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputBlock)(void);

@interface BATCourseDetailBottomView : UIView

/**
 背景
 */
@property (nonatomic,strong) UIView *bgView;


/**
 背景图片
 */
@property (nonatomic,strong) UIImageView *bgImageView;

/**
 评论icon
 */
@property (nonatomic,strong) UIImageView *iconImageView;

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 触发按钮
 */
@property (nonatomic,strong) UIButton *button;

/**
 输入Block
 */
@property (nonatomic,strong) InputBlock inputBlock;

@end
