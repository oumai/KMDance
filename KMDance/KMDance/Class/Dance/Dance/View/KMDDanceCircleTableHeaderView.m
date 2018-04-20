//
//  KMDDanceCircleTableHeaderView.m
//  KMDance
//
//  Created by KM on 17/6/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceCircleTableHeaderView.h"

@implementation KMDDanceCircleTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.circlePictureView];
        [self.circlePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.TopPicClick) {
        self.TopPicClick(index);
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index  {
    
}

#pragma mark - getter

- (SDCycleScrollView *)circlePictureView {
    if (!_circlePictureView) {
        _circlePictureView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"默认图"]];
        _circlePictureView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _circlePictureView.showPageControl = YES;
        _circlePictureView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _circlePictureView.pageDotColor = [UIColor lightGrayColor];
        _circlePictureView.currentPageDotColor = START_COLOR;
        _circlePictureView.autoScrollTimeInterval = 5.0f;
    }
    return _circlePictureView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
