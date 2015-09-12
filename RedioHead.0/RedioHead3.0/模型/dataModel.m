//
//  dataModel.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "dataModel.h"
@interface dataModel()

@end
@implementation dataModel
+ (NSMutableArray *)parsingDateFromResultDict:(NSDictionary *)dict
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *songArray = dict[@"song"];
        for (NSDictionary *songDict in songArray) {
            //每次创建一个model
            dataModel *model = [[dataModel alloc] init];
            //用appDict给model
            [model setValuesForKeysWithDictionary:songDict];
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
