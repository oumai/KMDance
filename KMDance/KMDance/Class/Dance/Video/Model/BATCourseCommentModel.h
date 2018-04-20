//
//  BATCourseCommentModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATCourseCommentData;
@interface BATCourseCommentModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATCourseCommentData *> *Data;

@end

@interface BATCourseCommentData : NSObject

@property (nonatomic,assign) NSInteger AccountID;
@property (nonatomic,copy) NSString *CreatedTime;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *ParentID;
@property (nonatomic,copy) NSString *ParentLevelID;
@property (nonatomic,copy) NSString *PhotoPath;
@property (nonatomic,copy) NSString *ReplyContent;
@property (nonatomic,assign) NSInteger ReplyNum;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *VideoID;
@property (nonatomic,copy) NSString *ReplyUserName;
@property (nonatomic,assign) NSInteger SetStarNum;


@property (nonatomic,strong) NSMutableArray <BATCourseCommentData *> *secondReplyList;


@property (nonatomic,assign) BOOL IsSetStar;
@property (nonatomic,assign) NSInteger StarCount;
@property (nonatomic,copy) NSString *ReplyTime;
@property (nonatomic,copy) NSString *ReplyAccountName;


@property (nonatomic, assign) double          commentTableViewHeight;

@property (nonatomic, assign) double          commentHeight;

@end
