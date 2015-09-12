//
//  DetailedListView.h
//  RedioHead3.0
//
//  Created by J on 15/8/18.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayMyMusicListDelegate.h"
@interface DetailedListView : UIViewController
@property(nonatomic,copy)NSString *nowPlayMusicList;
@property(nonatomic,strong)id<PlayMyMusicListDelegate>delegate;
+ (instancetype)sharedInstance ;
-(void)relondDataWithMusicListArray:(NSMutableArray *)musicArray;
-(void)deleteInformationSucceedYouMustRemoveData:(NSArray *)deleteDataArray;
/**万用模态对话框*/
-(void)misoperationPass:(NSString *)note;
/**播放下标发生变化*/
-(void)playerIsChangeWith:(int)indexPath;
/**
 *  再透明播放界面做出删除后的判断方法
 */
-(void)deleteNowPlayMusicJudgeList;
/**
 *  当列表发生变化对标识的清除方法
 */
-(void)muiscListIschangeClearPlayingMarkOrNot:(NSString *)change;


/**
 *  关闭当前播放的下标
 */
-(void)clocePlayingMark;

@end
