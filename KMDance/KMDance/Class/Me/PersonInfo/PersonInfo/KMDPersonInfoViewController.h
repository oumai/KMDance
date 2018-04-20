//
//  KMDPersonInfoViewController.h
//  KMDance
//
//  Created by KM on 17/5/242017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDPersonInfoViewController : UIViewController

@property (nonatomic,copy) void(^changePersonInfoBlock)(KMDPersonInfoEditorType type, NSString *content);

@end
