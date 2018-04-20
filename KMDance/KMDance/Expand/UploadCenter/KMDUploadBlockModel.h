//
//  KMDUploadBlockModel.h
//  KMDance
//
//  Created by KM on 17/8/142017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMDUploadIncomplete;

@interface KMDUploadBlockModel : NSObject

@property (nonatomic,assign) NSInteger BlockSize;
@property (nonatomic,assign) NSInteger FileSize;
@property (nonatomic,assign) NSInteger IncompleteBlocks;
@property (nonatomic,assign) float Progress;
@property (nonatomic,copy) NSString *Token;
@property (nonatomic,assign) NSInteger TotalBlocks;
@property (nonatomic,strong) KMDUploadIncomplete *incomplete;

@end


@interface KMDUploadIncomplete : NSObject

@property (nonatomic,assign) NSInteger blockIndex;
@property (nonatomic,assign) NSInteger end;
@property (nonatomic,assign) NSInteger start;

@end
