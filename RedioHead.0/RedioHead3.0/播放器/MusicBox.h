//
//  MusicBox.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PassMusicInformation.h"
#import <UIKit/UIKit.h>

@interface MusicBox : NSObject
@property(nonatomic,strong)NSDate *elapsedTimeDate;
@property(nonatomic,strong)NSDate *timeRemainingDate;
+(instancetype) sharedInstance;
//这个口子留给未选中列表时直接点击播放键使用
-(void)editURLWithIndex:(int )index;

-(void)playNextMusic;
-(void)playbeforeMuisc;
-(void)stopPlayMusic;
-(void)keepPlay;
-(void)playWhitMode:(int)mode;
-(void)sliderPlayWithSlider:(UISlider *)sender;
#pragma mark 暴露再外的播放接口
/**
 *  暴露再外的播放接口
 *
 *  @param urlIndex         电台下标
 *  @param urlArray         本地播放列表数组
 *  @param playIndex        本地列表的播放下标
 *  @param listMark         列表标志
 *  @param listName         列表名
 *  @param detailedPlayName 防重复播放的标志
    @param localizeListName 本地播放列表名称
 */
-(void)musicBoxWillPlayWith:(int)urlIndex orUrlArray:(NSMutableArray *)urlArray andPlayIndex:(int)playIndex andlistMark:(NSString *)listMark andListName:(NSString *)listName andDetailedPlayName:(int)detailedPlayName andLocalizeListName:(NSString *)localizeListName;
#pragma make 接受本地播放器的时间的方法
-(void)everyLocailzeMusicPlayTimePassCurrentTime:(NSTimeInterval )currentTime TimeRemainingDate:(NSTimeInterval )timeRemaining andPercentage:(int)percentage
;
-(void)LocailzeFileMusicPlayOver;
#pragma mark 外露根据下标和数组播放接口
-(void)playMusicWith:(NSMutableArray *)urlArray andIndexis:(int)playIndex;

@property(nonatomic,strong)id<PassMusicInformationDelegate>delegate;
@property(nonatomic,assign)int index;//选择的频道


@property(nonatomic,strong)NSMutableArray  *songsArray;
@property(nonatomic,assign)BOOL detaliedListView;

@end
