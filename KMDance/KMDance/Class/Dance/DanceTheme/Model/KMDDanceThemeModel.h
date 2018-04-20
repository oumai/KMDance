//
//  KMDDanceThemeModel.h
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class KMDDanceThemeData;

@interface KMDDanceThemeModel : NSObject

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<KMDDanceThemeData *> *Data;

@end

@interface KMDDanceThemeData : NSObject

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *ZoneTypeName;

@property (nonatomic, assign) NSInteger ZoneType;

@property (nonatomic, strong) NSArray *ZoneMusicList;

@property (nonatomic, assign) NSInteger multiple;

@end

