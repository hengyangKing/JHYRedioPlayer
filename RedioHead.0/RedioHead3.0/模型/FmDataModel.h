//
//  FmDataModel.h
//  RedioHead3.0
//
//  Created by J on 15/9/2.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmDataModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)int channel_id;
@property(nonatomic,assign)BOOL isSelect;
+ (NSMutableArray *)parsingDateFromResultDict:(NSDictionary *)dict;

@end
