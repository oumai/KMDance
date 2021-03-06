//
//  BATSendCommentView.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSendCommentView.h"

@implementation BATSendCommentView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

//        self.backgroundColor = BASE_BACKGROUND_COLOR;

        WEAK_SELF(self);
        
//        [self setTopBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0.5];

        [self addSubview:self.claerBGView];
        [self.claerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.sendBGView];
        [self.sendBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(120);
        }];

        [self.sendBGView addSubview:self.sendCommentButton];
        [self.sendCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.bottom.equalTo(self.sendBGView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];

        [self.sendBGView addSubview:self.commentTextView];
        [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.equalTo(self.sendBGView).offset(10);
            make.right.equalTo(self.sendBGView.mas_right).offset(-10);
            make.bottom.equalTo(self.sendCommentButton.mas_top).offset(-5);
        }];
        
    }
    return self;
}

- (YYTextView *)commentTextView {

    if (!_commentTextView) {
        _commentTextView = [[YYTextView alloc] initWithFrame:CGRectZero];
        _commentTextView.backgroundColor = [UIColor whiteColor];
    }
    return _commentTextView;
}

- (UIButton *)sendCommentButton {

    if (!_sendCommentButton) {
        _sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"发表" titleColor:[UIColor whiteColor] backgroundColor:[UIColor lightGrayColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        _sendCommentButton.layer.cornerRadius = 5.0f;
        WEAK_SELF(self);
        [_sendCommentButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.sendBlock) {
                self.sendBlock();
            }
        }];
    }
    return _sendCommentButton;
}

- (UIView *)claerBGView{
    if (!_claerBGView) {
        _claerBGView = [[UIView alloc]init];
        _claerBGView.backgroundColor = [UIColor clearColor];
        _claerBGView.userInteractionEnabled = YES;
        WEAK_SELF(self);

        [_claerBGView bk_whenTapped:^{
            STRONG_SELF(self);

            if (self.claerBlock) {
                self.claerBlock();
            }
        }];
    }
    return _claerBGView;
}


- (UIView *)sendBGView{
    if (!_sendBGView) {
        _sendBGView = [[UIView alloc]init];
        _sendBGView.backgroundColor = BASE_BACKGROUND_COLOR;;
    }
    return _sendBGView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
