//
//  RootViewController.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataModel.h"
@interface RootViewController : UIViewController
//@property(nonatomic,assign)int on_off;
-(void)handleSwipeUp;

+ (instancetype)sharedInstance;
//外部调用滑动至我的播放页面
-(void)toDetailedListView;
//外部调用滑动至我的播放列表页面
-(void)toMyZoom;

-(void)saveInformationSucceed;
//抛出提示方法
-(void)misoperationPass:(NSString *)note;
//创建列表方法
-(void)makeNewDetailedListView;
//是否下载方法
-(void)ifDownlondNowPlayMusicOrNotWith:(NSString *)listName;
//打开添加列表界面
-(void)addListingOpen;
//关闭刷新列表界面
-(void)addListingCloce;

///**并将现有本地文件添加进列表的方法*/
//-(void)addLocalizeMusicToMusicListWithArtist:(NSString *)artist andAlbumtitle:(NSString *)albumtitle;

/**创建列表，并将本地音乐集合添加进列表的方法*/
-(void)addLocalizeMusicToMusicListWithLocalizeMusic:(NSArray *)localizeArray;
/**删除本地文件时的模态对话框*/
-(void)isDeleteLocalizeWithListORNotWithModel:(dataModel *)model;

/**删除本地列表是的模态对话框*/
-(void)isDeleteMusicListWithMyMusicListORNotWithMusicListName:(NSString *)listName;
/**已经播放到列表最后一首歌曲的模态对话框*/
-(void)isMusicListLastMusic:(NSMutableArray *)array;
/**
 *  网络不佳对话框
 */
-(void)theNetorkIsUnstable:(NSString *)url;

@property(nonatomic,strong)NSString *nowPlayMusic;
@property(nonatomic,strong)NSString *nowPlayMusicListName;
@property(nonatomic,strong)NSString *MyMusicListViewIsEdit;
@end
