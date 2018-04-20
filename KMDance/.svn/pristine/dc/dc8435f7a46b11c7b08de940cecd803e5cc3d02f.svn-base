//
//  MJExtensionConfig.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"

@implementation MJExtensionConfig

+ (void)load
{
    [NSObject mj_setupNewValueFromOldValue:^id(id object, id oldValue, MJProperty *property) {
        
        if (property.type.typeClass == [NSString class]) {
            
            if (oldValue == nil) {
                return @"";
            } else if ([oldValue isKindOfClass:[NSNull class]]) {
                return @"";
            } else if ([oldValue isKindOfClass:[NSString class]]) {
                if ([oldValue isEqualToString:@"(null)"] || [oldValue isEqualToString:@"<null>"] || [oldValue isEqualToString:@"null"]) {
                    return @"";
                }
            }
        }
        return oldValue;
    }];
}

@end
