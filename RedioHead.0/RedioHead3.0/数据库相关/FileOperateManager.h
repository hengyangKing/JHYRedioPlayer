//
//  FileOperateManager.h
//  RedioHead3.0
//
//  Created by J on 15/8/29.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperateManager : NSObject
/**
 *  文件操作类，传入音乐名称，删除相应文件的方法
 */
-(void)deleteLocalizeFileWith:(NSString *)musicName;
/**
 *  文件操作类，传入音乐数组，删除相应文件的方法
 */
-(void)deleteLocalizeDataWith:(NSArray *)dataArray;
/**
 *  文件操作类，查询本地MP3文件方法
 */
-(NSMutableArray *)loadMusicFile;

@end
