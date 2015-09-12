//
//  MusicBox.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MusicBox.h"
#import "AFNetworking.h"
#import "dataModel.h"
#import "AFAudioRouter.h"
#import "AFSoundManager.h"
#import "SDWebImageManager.h"
#import "MusicListingDBManager.h"
#import "RootViewController.h"
#import "RelondLocalizeMusicInformation.h"
#import "LocalizeMusicBox.h"
#import "JHYMD5CodeTool.h"
#import "DetailedListView.h"
static int detailedPlayNameCup=10000;
static int play_mode=1;//1循环 2随机 3单曲
#define DOUBANURL @"http://douban.fm/j/mine/playlist?type=n&channel=%d"//豆瓣接口
#define NEWDOUBANURL @"http://douban.fm/j/mine/playlist?type=n&type=n&channel=%d&from=mainsite"//新豆瓣接口
@interface MusicBox ()
@property(nonatomic,copy)UIImage *nowPlayImage;
//@property(nonatomic,strong)NSMutableArray  *songArray;
@property(nonatomic,assign)int playindex;
@property(nonatomic,strong)NSString *nowPlayList;
@property(nonnull,strong)LocalizeMusicBox *localizeMusicBox;
@property(nonatomic,strong)NSString *xxoo;
@end
@implementation MusicBox

+ (void)initialize
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

- (NSMutableArray *)songsArray
{
    
    if (_songsArray == nil) {
        NSLog(@"我凭啥是nil");
        _songsArray  = [NSMutableArray array];
    }
    return _songsArray;
}
#pragma mark 总入口
-(NSString *)xxoo
{
    if(_xxoo==nil)
    {
        _xxoo=[[NSString alloc]init];
        _xxoo=@"dnkasjndksaknksa";
    }
    return _xxoo;
}
#pragma mark 总的播放音乐地址 对列表进行查重
-(void)musicBoxWillPlayWith:(int)channel_id orUrlArray:(NSMutableArray *)urlArray andPlayIndex:(int)playIndex andlistMark:(NSString *)listMark andListName:(NSString *)listName andDetailedPlayName:(int)detailedPlayName andLocalizeListName:(NSString *)localizeListName
{
//    self.songsArray=urlArray;
    /**
     *  暴露再外的播放接口
     *
     *  @param channel_id         电台下标
     *  @param urlArray         本地播放列表数组
     *  @param playIndex        本地列表的播放下标
     *  @param listMark         列表标志
     *  @param listName         列表名
     *  @param detailedPlayName 防重复播放的标志
     */
    NSLog(@"%@",listMark);
@synchronized(self)
{
    if ([listMark isEqualToString:@"FMLIST"])
    {
        [self editURLWithIndex:channel_id];
        _nowPlayList=listMark;
        detailedPlayNameCup=10000;
        self.xxoo=@"dnkasjndksaknksa";
        self.playindex=0;
    }
    else if([listMark isEqualToString:@"DETALIEDLIST"])
    {
        
        detailedPlayNameCup=playIndex;
        NSString *str=[JHYMD5CodeTool MD5StringFromString:[NSString stringWithFormat:@"%@%d",localizeListName,detailedPlayNameCup]];
        ;
        _nowPlayList=listMark;
        if ([self.xxoo isEqualToString:@"dnkasjndksaknksa"])
        {
            detailedPlayNameCup=playIndex;
            [self playMusicWith:urlArray andIndexis:playIndex];
            _xxoo=str;

        }
        else if([_xxoo isEqualToString:str])
        {
            return;
        }else if(![_xxoo isEqualToString:str])
        {
            [self playMusicWith:urlArray andIndexis:playIndex];
            detailedPlayNameCup=playIndex;
            _xxoo =str;

        }
    }
}
}
#pragma mark 解析传来的包地址
-(void)editURLWithIndex:(int )index 
{

    NSArray *cateChannel = [NEWDOUBANURL componentsSeparatedByString:@"channel=%d&from=mainsite"];
    self.index=index;
    NSString *str1 = [cateChannel firstObject];
    NSString *url=[NSString stringWithFormat:@"%@channel=%d&from=mainsite",str1,index];
    [self downlondDataWithUrl:url];

}
-(void)downlondDataWithUrl:(NSString *)url
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^ void(AFHTTPRequestOperation * operation, id resultObject)
     {
         self.songsArray=[dataModel parsingDateFromResultDict:resultObject];
         [self playMusicWith:self.songsArray andIndexis:_playindex];
         
     } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
    
         RootViewController*rootvc=[RootViewController sharedInstance];
         [rootvc misoperationPass:@"当前网络不佳，请检查网络"];

         NSLog(@"%@",error);
         
     }];
}
#pragma mark 集合对包操作,也可对现有播放列表
-(void)playMusicWith:(NSMutableArray *)urlArray andIndexis:(int)playIndex
{
    [self PlayPause];
    self.playindex=playIndex;
    [self.delegate playerIsChange];
    DetailedListView *detaliedListView=[DetailedListView sharedInstance];
    if (self.detaliedListView)
    {
        [detaliedListView playerIsChangeWith:self.playindex];
    }
    self.songsArray=urlArray;//在这里从新赋值一遍，这样就能给新来的数组留条后路
    MusicListingDBManager *dbManager=[MusicListingDBManager sharedManager];
    dataModel *model=urlArray[self.playindex];

    if (model.localizemusic.length>3)
    {
        self.songsArray=urlArray;
        NSLog(@"进入本地播放模式");
        _localizeMusicBox=[LocalizeMusicBox sharedInstance];
        if ([model.url hasSuffix:@".mp3"])
        {
            [_localizeMusicBox startPlayingLocalFileWithName:[NSString stringWithFormat:@"%@.mp3",model.localizemusic]];
        }
        else if([model.url hasSuffix:@".mp4"])
        {
            [_localizeMusicBox startPlayingLocalFileWithName:[NSString stringWithFormat:@"%@.mp4",model.localizemusic]];
        }
        NSLog(@"本地存储歌名为 %@",model.localizemusic);
    }
    else
    {
        [self useAFSoundManagerPlayMusicWith:model.url];
    }
    [dbManager passNowPlatMusic:model];
    [self.delegate PassMusicInformation:model];
    [self.delegate PassNowPlayMusicUrl:model.url];
    [self.delegate PassMusicArtist:model.artist andAlbumtitle:model.title];
    [self downlondMusicImageWithUrl:model.picture];
  
}
#pragma mark 解析音频
-(void)useAFSoundManagerPlayMusicWith:(NSString *)url
{
    [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        if (!error) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"mm:ss"];
            
            _elapsedTimeDate = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
            _timeRemainingDate = [NSDate dateWithTimeIntervalSince1970:timeRemaining];
            [self.delegate PassMusicElapsedTime:_elapsedTimeDate andTimeRemainingDate:_timeRemainingDate andPercentage:percentage];
            if (timeRemaining ==0.0)
            {
                if (play_mode==1)
                {
                   [self playNextMusic];
                }
                else if(play_mode==2)
                {
                    [self stochasticPlay];
                }
                else if(play_mode==3)
                {
                    //只有在自己播放完毕后才调用重复播放方法
                    [self repeatPlay];
                }
            }
            
        } else {
            
            RootViewController*rootvc=[RootViewController sharedInstance];
            [rootvc misoperationPass:@"当前网络不佳，请检查网络"];
            NSLog(@"There has been an error playing the remote file: %@", [error description]);

        }
        
    }];
   
}
#pragma mark 下载专辑图片
-(void)downlondMusicImageWithUrl:(NSString *)url
{
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    NSURL *imageUrl=[NSURL URLWithString:url];
    [manager downloadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
//         UIProgressView *progress=(id)[self.view viewWithTag:1000];
//         progress.progress=(double)receivedSize/expectedSize;
     }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         [self.delegate PassMusicImage:image];
     }
];
}
#pragma mark 接受本地音乐器的信息
-(void)everyLocailzeMusicPlayTimePassCurrentTime:(NSTimeInterval )currentTime TimeRemainingDate:(NSTimeInterval )timeRemaining andPercentage:(int)percentage
{
    
    _elapsedTimeDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    _timeRemainingDate = [NSDate dateWithTimeIntervalSince1970:timeRemaining];
    [self.delegate PassMusicElapsedTime:_elapsedTimeDate  andTimeRemainingDate:_timeRemainingDate andPercentage:percentage];
    
}
//播放下一首方法
#pragma mark 控制方法
-(void)playNextMusic
{
    //歌单和下标变化都需要切歌，那么做两个通知中心对其实时监控
//    歌单做通知中心，下标做代理
//    [self.delegate playerIsChange];
    if ([_nowPlayList isEqualToString:@"DETALIEDLIST"])
    {
        if (play_mode==2)
        {
            //随机模式
            [self stochasticPlay];
        }
        else
        {
            NSLog(@"正常播放下一首");
            if (_playindex<self.songsArray.count-1)
            {
                _playindex++;
                detailedPlayNameCup=_playindex;
                [self playMusicWith:self.songsArray andIndexis:_playindex];
            }
            else if(_playindex==self.songsArray.count-1)
            {
                [[AFSoundManager sharedManager]stop];
                detailedPlayNameCup=_playindex;
                RootViewController *rootVC=[RootViewController sharedInstance];
                [rootVC isMusicListLastMusic:self.songsArray];
                return;
            }
        }
    
    }else if([_nowPlayList isEqualToString:@"FMLIST"])
    {
        if (self.playindex<self.songsArray.count-1)
        {
            
            _playindex++;
            [self playMusicWith:self.songsArray andIndexis:_playindex];
        }
        else if(self.playindex==self.songsArray.count-1)
        {
            self.playindex=0;
            [self editURLWithIndex:self.index];
        }
        
    }
}
//       只有再随机模式下前进后退才会不同
-(void)playbeforeMuisc
{
    [self PlayPause];
    if(play_mode==2)
   {
       [self stochasticPlay];
   }
    else
    {
        NSLog(@"正常播放上一首");
        if(_playindex>0)
        {
            _playindex--;
            detailedPlayNameCup=_playindex;
            detailedPlayNameCup=(int)self.songsArray[_playindex];
            [self playMusicWith:self.songsArray andIndexis:_playindex];
        }
        else if(_playindex==0)
        {
            detailedPlayNameCup=_playindex;
            RootViewController *rootVC=[RootViewController sharedInstance];
            [rootVC isMusicListLastMusic:self.songsArray];

            return;
        }

    }
}
-(void)stopPlayMusic
{
    [[AFSoundManager sharedManager]pause];
    [self.localizeMusicBox musicPlayTimeOut];
}
-(void)PlayPause
{
    [[AFSoundManager sharedManager]stop];
    [self.localizeMusicBox musicPausePlay];

}
-(void)keepPlay
{
    [[AFSoundManager sharedManager]resume];
    [self.localizeMusicBox musicStartPlay];
}
-(void)sliderPlayWithSlider:(UISlider *)sender
{
        [[AFSoundManager sharedManager]moveToSection:sender.value];

}
-(void)playWhitMode:(int)mode
{
    play_mode=mode;
}
#pragma mark 三种播放模式
-(void)stochasticPlay
{
    [_localizeMusicBox musicStopPlay];
    NSLog(@"随机播放");
    _playindex=arc4random()%self.songsArray.count;
    detailedPlayNameCup=_playindex;
    [self playMusicWith:self.songsArray andIndexis:_playindex];
    detailedPlayNameCup=(int)self.songsArray[_playindex];
}
-(void)repeatPlay
{
    NSLog(@"单曲循环");
    [_localizeMusicBox musicStopPlay];
    [[AFSoundManager sharedManager]stop];
    [self playMusicWith:self.songsArray andIndexis:_playindex];
    detailedPlayNameCup=_playindex;
    detailedPlayNameCup=(int)self.songsArray[_playindex];
}
#pragma mark 本地播放器代理方法
-(void)LocailzeFileMusicPlayOver
{
    NSLog(@"本地文件播放完毕");
    if (play_mode==1)
    {
        [self playNextMusic];
    }
    else if(play_mode==2)
    {
        [self stochasticPlay];
    }
    else if(play_mode==3)
    {
        //只有在自己播放完毕后才调用重复播放方法
        [self repeatPlay];
    }
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        
//        self.tenSongsArray  = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static MusicBox *musicBox = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        musicBox = [[self alloc] initPrivate];
//        musicBox.delegate=self;
    
    });
    
    return musicBox;
}



@end
