//
//  BATCourseCommentModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCourseCommentModel.h"

@implementation BATCourseCommentModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATCourseCommentData class]};
}

@end

@implementation BATCourseCommentData

+ (NSDictionary *)objectClassInArray{
    return @{@"secondReplyList" : [BATCourseCommentData class]};
}

- (double)commentHeight
{
    if (_commentHeight == 0) {
        
        double contentWidth = SCREEN_WIDTH - 60.0f - 15.0f;
        
        float tempHeight = 0.0f;
        
        
        NSString *string = @"";
        if (self.ReplyAccountName.length > 0) {
            string = [NSString stringWithFormat:@"%@回复%@：%@",self.UserName,self.ReplyAccountName,self.ReplyContent];
        } else {
            string = [NSString stringWithFormat:@"%@：%@",self.UserName,self.ReplyContent];
        }
        
        tempHeight = [Tools calculateHeightWithText:string width:contentWidth - 16 font:[UIFont systemFontOfSize:11] lineHeight:15.0f];
        
        _commentHeight = (tempHeight >= 30 ? ceilf(tempHeight) + 4 : 30);
        
    }
    return _commentHeight;
}

- (double)commentTableViewHeight
{
    //    if (!_commentTableViewHeight) {
    
    double commentTableViewHeight = 0;
    
    if (self.secondReplyList.count > 0) {
        
        for (BATCourseCommentData *commet in self.secondReplyList) {
            commentTableViewHeight = commentTableViewHeight + commet.commentHeight;
        }
        
        _commentTableViewHeight = commentTableViewHeight;
    }
    
    //    }
    return _commentTableViewHeight;
}


@end
