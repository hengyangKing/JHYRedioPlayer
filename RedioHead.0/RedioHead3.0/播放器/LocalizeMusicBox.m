//
//  LocalizeMusicBox.m
//  RedioHead3.0
//
//  Created by J on 15/8/21.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "LocalizeMusicBox.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioFile.h>//新增头文件库
#import "AppDelegate.h"
#import "MusicBox.h"
@interface LocalizeMusicBox()<AVAudioPlayerDelegate>
@property(nonatomic,strong)NSMutableArray *musicArr;
@property(nonatomic,strong)NSTimer *time;
@property(strong,nonatomic)AVAudioPlayer *player;

@property(nonatomic,strong)MusicBox *mosicBox;

@end
@implementation LocalizeMusicBox
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        self.mosicBox=[MusicBox sharedInstance];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static LocalizeMusicBox *localizeMusicBox = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        localizeMusicBox = [[self alloc] initPrivate];
        
    });
    return localizeMusicBox;
}
-(void)startPlayingLocalFileWithName:(NSString *) fileName
{
    [_time invalidate];
    _time=nil;
    
    NSString *str=[NSString stringWithFormat:@"%@/Documents/music/%@",NSHomeDirectory(),fileName];
    NSLog(@"本地播放文件为%@",str);
    NSError *error=nil;
    NSURL *url=[NSURL fileURLWithPath:str];
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url
                                                      error:&error];
    self.player.delegate=self;
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //支持后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //支持远程控制
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
    _time= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playProgress)userInfo:nil repeats:YES];
    
    [self.player play];
}
-(void)playProgress
{
    //每秒一次回调

    int percentage=self.player.currentTime*100/self.player.duration;
    [self.mosicBox everyLocailzeMusicPlayTimePassCurrentTime:self.player.currentTime TimeRemainingDate:self.player.duration andPercentage:percentage];

}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    [_mosicBox LocailzeFileMusicPlayOver];
    [_time invalidate];
    _time=nil;
}
-(void)musicStopPlay
{
    [self.player pause];
    [_time invalidate];
    _time=nil;
}
-(void)musicStartPlay
{
    [self.player play];
    [_time setFireDate:[NSDate date]];//从现在开始

}
-(void)musicPlayTimeOut
{
    [self.player pause];
    [_time setFireDate:[NSDate distantFuture]];
}
-(void)musicPausePlay
{
    [self.player stop];
    self.player =nil;
}
-(void)sliderPlayWithSlider:(UISlider *)sender
{
    self.player.currentTime=sender.value*self.player.duration;
}
@end
