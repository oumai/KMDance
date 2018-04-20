//
//  KMDNewsModel.h
//  KMDance
//
//  Created by KM on 17/5/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class KMDNewsData;

@interface KMDNewsModel : NSObject

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         RecordsCount;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<KMDNewsData *> *Data;

@end

@interface KMDNewsData : NSObject

@property (nonatomic, copy  ) NSString          *ID;
@property (nonatomic, copy  ) NSString          *Title;
@property (nonatomic, copy  ) NSString          *Body;
@property (nonatomic, copy  ) NSString          *LastModifiedTime;
@property (nonatomic, copy  ) NSString          *Category;
@property (nonatomic, copy  ) NSString          *CreatedTime;
@property (nonatomic, assign) BOOL              IsCollectLink;
@property (nonatomic, copy  ) NSString          *MainImage;
@property (nonatomic, assign) NSInteger         ReadingQuantity;
@property (nonatomic, copy  ) NSString          *NewLableList;
@property (nonatomic, copy  ) NSString          *ReleaseTime;
@property (nonatomic, assign) NSInteger          HelpfulCount;
@property (nonatomic, copy  ) NSString          *Author;
@property (nonatomic, copy  ) NSString          *SourceName;
@property (nonatomic, copy  ) NSString          *Abstract;
@property (nonatomic, assign) NSInteger          Sort;

@end
