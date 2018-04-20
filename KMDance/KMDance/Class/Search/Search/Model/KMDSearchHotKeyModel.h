//
//  KMDSearchHotKeyModel.h
//  KMDance
//
//  Created by KM on 17/5/252017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HotKeyData;

@interface KMDSearchHotKeyModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<HotKeyData *> *Data;

@end



@interface HotKeyData : NSObject

@property (nonatomic, copy) NSString *Keyword;

@property (nonatomic, copy) NSString *KeyID;

@property (nonatomic, assign) BOOL isSelect;

@end
