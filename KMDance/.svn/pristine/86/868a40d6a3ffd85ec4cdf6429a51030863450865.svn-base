//
//  KMDShareView.m
//  KMDance
//
//  Created by KM on 17/5/312017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDShareView.h"
#import "KMDShareCollectionViewCell.h"

static  NSString * const SHARE_CELL = @"KMDShareCollectionViewCell.h";

@implementation KMDShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.shareCollectionView];
        [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(@0);
            make.bottom.equalTo(@-40);
        }];
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.top.equalTo(self.shareCollectionView.mas_bottom);
        }];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KMDShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHARE_CELL forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            //微信好友
            cell.shareImageView.image = [UIImage imageNamed:@"微信好友"];
            cell.titleLabel.text = @"微信好友";
        }
            break;
        case 1:
        {
            //微信朋友圈
            cell.shareImageView.image = [UIImage imageNamed:@"朋友圈"];
            cell.titleLabel.text = @"微信朋友圈";

        }
            break;
        case 2:
        {
            //QQ好友
            cell.shareImageView.image = [UIImage imageNamed:@"QQ好友"];
            cell.titleLabel.text = @"QQ好友";

        }
            break;
        case 3:
        {
            // 新浪微博
            cell.shareImageView.image = [UIImage imageNamed:@"新浪微博"];
            cell.titleLabel.text = @"新浪微博";

        }
            break;
    
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH/4.0, 100);
    return size;
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.weiChatBlock) {
                self.weiChatBlock();
            }
        }
            break;
        case 1:
        {
            if (self.weiChatMomentsBlock) {
                self.weiChatMomentsBlock();
            }
        }
            break;
        case 2:
        {
            if (self.QQBlock) {
                self.QQBlock();
            }
        }
            break;
        case 3:
        {
            if (self.weiboBlock) {
                self.weiboBlock();
            }
        }
            break;
    }
}

#pragma mark - getter
- (UICollectionView *)shareCollectionView {
    
    if (!_shareCollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _shareCollectionView.backgroundColor = [UIColor whiteColor];
        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        _shareCollectionView.delegate = self;
        _shareCollectionView.dataSource = self;
        
        [_shareCollectionView registerClass:[KMDShareCollectionViewCell class] forCellWithReuseIdentifier:SHARE_CELL];
    }
    return _shareCollectionView;
}

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消" titleColor:BASE_COLOR backgroundColor:[UIColor whiteColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        [_cancelBtn setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        WEAK_SELF(self);
        [_cancelBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }];
    }
    return _cancelBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
