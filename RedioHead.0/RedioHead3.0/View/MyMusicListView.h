//
//  MyMusicListView.h
//  RedioHead3.0
//
//  Created by J on 15/8/18.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayDetaliedMusicDelegate.h"
@interface MyMusicListView : UIViewController
@property(nonatomic,strong)id<PlayDetaliedMusicDelegate> delegate;
@property(nonatomic,strong)NSString *IamPlaying;

//@property(nonatomic,assign)int playListMark;
+ (instancetype)sharedInstance ;
//-(void)showMusicListWith:(NSString *)suffix;
/**
 *  根据选择读取响应的列表
 */
-(void)newShowMusicList;
/**
 *  读取本地列表的方法
 */
-(void)newShowLocalizeMusicName;
/**
 *  本地列表添加成功的方法
 */
-(void)saveInformationSucceed;

/**
 *  播放列表变化方法
 */
-(void)listNameisChange:(NSString *)listName;
/**
 *  给列表展示页下载列表的方法
 */
-(void)loadDataWhitMusicList:(NSString *)musicList;
/**
 *  选中某一列表给他一个记号的方法
 */
-(void)makeMarkWithNowPlayingList:(NSString *)nowPlayingList;

/**
 *  关闭列表显示
 */
-(void)clocePlayingMark;

@end
