//
//  FmDataModel.m
//  RedioHead3.0
//
//  Created by J on 15/9/2.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "FmDataModel.h"

@implementation FmDataModel
+ (NSMutableArray *)parsingDateFromResultDict:(NSDictionary *)dict
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *songArray = dict[@"channels"];
        for (NSDictionary *songDict in songArray) {
            //每次创建一个model
            FmDataModel *model = [[FmDataModel alloc] init];
            //用appDict给model
            [model setValuesForKeysWithDictionary:songDict];
            model.isSelect=NO;
            [dataArray addObject:model];
        }
    }
    return dataArray;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 防止崩溃
}

@end
