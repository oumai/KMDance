//
//  KMDDanceThemeTableViewCell.h
//  KMDance
//
//  Created by KM on 17/6/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDDanceThemeTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UICollectionView *videoCollectionView;
@property (nonatomic,strong) UIButton *expandButton;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger multiple;

//@property (nonatomic,assign) NSInteger expandBtnHeight;

@property (nonatomic,copy) void(^videoClicked)(NSString *videoID);
@property (nonatomic,copy) void(^expandClicked)(void);

@end
