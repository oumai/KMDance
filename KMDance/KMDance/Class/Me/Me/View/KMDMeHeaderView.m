//
//  KMDMeHeaderView.m
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDMeHeaderView.h"

@implementation KMDMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        WEAK_SELF(self);
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        [self addSubview:self.loginLabel];
        [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(@0);
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 394.0/750.0*SCREEN_WIDTH)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_bg"]];
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 394.0/750.0*SCREEN_WIDTH);
        [_backView addSubview:imageView];
        
        
        
//        CAGradientLayer *layer = [CAGradientLayer layer];
//        layer.startPoint = CGPointMake(0.5, 0.0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
//        layer.endPoint = CGPointMake(0.5, 1.0);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
//        layer.colors = [NSArray arrayWithObjects:(id)UIColorFromHEX(0xc44fff, 1).CGColor, (id)UIColorFromHEX(0xf46eda, 1).CGColor, nil];
////        layer.locations = @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
//        layer.frame = _backView.layer.bounds;
//        [_backView.layer insertSublayer:layer atIndex:0];
//        
//
//        
//        UIBezierPath *maskPath = [UIBezierPath bezierPath];
//        [maskPath moveToPoint:CGPointMake(0, 0)];
//        [maskPath addLineToPoint:CGPointMake(0, 200-27)];
//        [maskPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH, 200-27) controlPoint:CGPointMake(SCREEN_WIDTH/2.0, 220)];
//        [maskPath addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
//
//        
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//        //设置大小
//        maskLayer.frame = _backView.bounds;
//        //设置图形样子
//        maskLayer.path = maskPath.CGPath;
//        _backView.layer.mask = maskLayer;
        
    }
    return _backView;
}
- (UIImageView *)backImageView {
    
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"默认图"]];
    }
    return _backImageView;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 32.5f;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UILabel *)loginLabel {
    
    if (!_loginLabel) {
        _loginLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        _loginLabel.userInteractionEnabled = YES;
    }
    return _loginLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
