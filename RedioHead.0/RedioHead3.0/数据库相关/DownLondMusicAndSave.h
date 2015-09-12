//
//  DownLondMusicAndSave.h
//  RedioHead3.0
//
//  Created by J on 15/8/19.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataModel.h"
#import "DownLondMusicSucceed.h"
@interface DownLondMusicAndSave : NSObject
@property(nonatomic,assign)id<DownLondMusicSucceed>delegate;
+ (instancetype)sharedInstance ;

-(BOOL)opinionFileName:(NSString *)fileName;

- (void)downloadMusicFileWithDataModel:(dataModel *)model  andFileNameIs:(NSString *)fileName;
@end
