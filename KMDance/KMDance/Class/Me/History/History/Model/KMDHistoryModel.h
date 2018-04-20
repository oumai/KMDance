//
//  KMDHistoryModel.h
//  KMDance
//
//  Created by KM on 17/6/12017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class KMDHistoryData;

@interface KMDHistoryModel : NSObject

@property (nonatomic, assign) NSInteger         PagesCount;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         RecordsCount;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<KMDHistoryData *> *Data;

@end

@interface KMDHistoryData : NSObject

@property (nonatomic, assign) NSInteger         AccountID;

@property (nonatomic, copy  ) NSString          *AuthorName;

@property (nonatomic, assign) KMDSearchCategory CategoryID;

@property (nonatomic, copy  ) NSString          *CreatedBy;

@property (nonatomic, copy  ) NSString          *CreatedTime;

@property (nonatomic, copy  ) NSString          *ID;

@property (nonatomic, copy  ) NSString          *VideoID;

@property (nonatomic, assign) BOOL              IsDeleted;

@property (nonatomic, copy  ) NSString          *MusicName;

@property (nonatomic, copy  ) NSString          *Poster;

@property (nonatomic, copy  ) NSString          *PlayRecording;

@property (nonatomic, copy)   NSString *ResourceKey;

@end
