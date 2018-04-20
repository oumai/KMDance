//
//  KMDUploadCollectionViewCell.m
//  KMDance
//
//  Created by KM on 17/8/72017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadCollectionViewCell.h"

@implementation KMDUploadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1.0f;
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _imageView;
}
@end
