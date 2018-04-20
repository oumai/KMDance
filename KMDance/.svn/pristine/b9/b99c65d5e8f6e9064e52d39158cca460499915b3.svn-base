//
//  KMDDanceListModel.h
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class KMDDanceListData;

@interface KMDDanceListModel : NSObject

@property (nonatomic, assign) NSInteger         PagesCount;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         RecordsCount;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<KMDDanceListData *> *Data;

@end

@interface KMDDanceListData : NSObject

@property (nonatomic, assign) NSInteger         AccountID;

@property (nonatomic, copy  ) NSString          *AuthorName;

@property (nonatomic, assign) KMDSearchCategory CategoryID;

@property (nonatomic, copy  ) NSString          *CreatedBy;

@property (nonatomic, copy  ) NSString          *CreatedTime;

@property (nonatomic, copy  ) NSString          *ID;

@property (nonatomic, assign) BOOL              IsCollect;

@property (nonatomic, assign) BOOL              IsDeleted;

@property (nonatomic, assign) BOOL              IsFocus;

@property (nonatomic, copy  ) NSString          *Name;

@property (nonatomic, assign) NSInteger         PlayCount;

@property (nonatomic, copy  ) NSString          *Poster;

@property (nonatomic, copy  ) NSString          *Singer;

@property (nonatomic, copy  ) NSString          *Url;

@property (nonatomic, copy  ) NSString          *VideoLong;

@property (nonatomic, assign) KMDStatusFlagType StatusFlag;

@property (nonatomic, copy)   NSString *ResourceKey;
@end
