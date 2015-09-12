//
//  MusicListingDBManager.h
//  RedioHead3.0
//
//  Created by J on 15/8/15.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataModel.h"
#import "saveInformationSucceed.h"
@interface MusicListingDBManager : NSObject
@property(nonatomic,strong)id<MusicListDBManagerDelegate> delegate;
// 获取数据管理者
// 单例 线程安全的管理者
+ (id)sharedManager;

// 实时回传数据，随时准备保存
-(void)passNowPlatMusic:(dataModel *)dataModel;
//传进来列表查询数据方法
-(NSMutableArray *)queryMusicListWithListName:(NSString *)listName;

#pragma mark 新的数据库方法
/**
 *  创建或打开新的表，将列表名和是否下载写入
 *
 *  @param listName      列表名
 *  @param localizemusic 是否下载标记
 */
-(void)createNewMusicListWithListName:(NSString *)listName andLocalizemusic:(NSString *)localizemusic;

/**
 *  读取出列表内的相应流派并删除相同项目
 */
-(NSMutableArray *)queryMusicList;


/**
 *  根据列表名称选择出带有响应标签的数据
 */
-(NSMutableArray *)newQueryMusicListWithListName:(NSString *)listName;

/**
 *  根据列表名删除列表
 */
-(void)deleteMusiclitWithListName:(NSString *)listName;
/**
 *  根据url删除列表
 */
-(void)deleteMusiclitWithListNameArray:(NSArray *)deleteMusicListName;
/**
 *  查询所有已下载的歌曲
 */
-(NSMutableArray *)queryLocalizeMusicList;

/**
 *  将歌曲从列表中删除但保留再数据库中
 */
-(void)changeMusicLictWithArray:(NSArray *)deleteArray;

/**
 *  将本地歌曲添加进现有播放列表的方法
 */
-(void)addLocalizeMusicListWithListName:(NSString *)listName andDataArray:(dataModel *)model;

/**
 *  将已收藏未下载歌曲写入下载名方法
 */
-(void)makeMusicFileIsLocalizeMusicWithDataModel:(dataModel *)model;
/**
 *  创建播放列表，并将本地数组添加进去的方法
 */
//-(void)createNewMusicListWithListName:(NSString *)listName withModel:(dataModel *)model;
/**
 *  更改是否下载字段方法
 */
-(void)changeMusicFileIsLocalizeMusicOrNotWithArray:(NSArray *)deleteArray;
@end
