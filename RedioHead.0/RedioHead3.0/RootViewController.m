//
//  RootViewController.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "RootViewController.h"
#import "MyButtonShop.h"
#import "FindMusicView.h"
#import "MyFMZoom.h"
#import "MusicBox.h"
#import "DetailedListView.h"
#import "ListingViewController.h"
#import "MusicListingDBManager.h"
#import "JHYMD5CodeTool.h"
#import "DownLondMusicAndSave.h"
#import "UMSocial.h"
#import "LocalizeMusicBox.h"
#import "MyMusicListView.h"
#import "FileOperateManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#define MENUBAR_DISTANCE 559.f
#define LISTING_DISTANCE 150.f
static int nowtime=1000.0;
static float angle=0.0;
#define DOUBANFMLIST @"http://www.douban.com/j/app/radio/channels"

@interface RootViewController ()<UIGestureRecognizerDelegate,PassMusicInformationDelegate,PlayMyMusicListDelegate,PlayFMListMusicDelegate,UMSocialUIDelegate,PlayDetaliedMusicDelegate,DownLondMusicSucceed>
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *findMusic;
@property(nonatomic,strong)UIButton *myFM;
@property(nonatomic,strong)UIImageView *titleMark;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)FindMusicView *findMusicView;
@property(nonatomic,strong)DetailedListView *detailedListView;
@property(nonatomic,strong)MyFMZoom *myFMZoom;
@property(nonatomic,strong)ListingViewController *listingViewController;
@property(nonatomic,strong)UIView *playView;
@property(nonatomic,strong)UIButton *playbutton;
@property(nonatomic,strong)UIButton *collectbutton;
@property(nonatomic,strong)UIButton *trashbutton;
@property(nonatomic,strong)UIImageView *playingMark;
@property(nonatomic,strong)UIButton *stochasticbutton;
@property(nonatomic,strong)UIButton *playlastOnebutton;
@property(nonatomic,strong)UIButton *playnextOnebutton;
@property(nonatomic,strong)UIButton *sharebutton;
@property(nonatomic,strong)UIButton *nextOnebutton;
@property(nonatomic,strong)UIImageView *picImageView;
@property(nonatomic,strong)UILabel *artist;
@property(nonatomic,strong)UILabel *songtitle;
@property(nonatomic,strong)UIView *listingView;
@property(nonatomic,strong)MusicBox *musicBox;
@property(nonatomic,strong)MusicListingDBManager *dbManager;
@property(nonatomic,strong)NSString *md5PlayingMusicName;
@property(nonatomic,strong)NSString *nowPlayMusicURL;
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)NSString *ifDetailedornot;
@property(nonatomic,strong)NSString *mode;
@property(nonatomic,strong)NSMutableArray *deleteArray;
@property(nonatomic,strong)NSArray *playMarkImageArr;
@property(nonatomic,strong)LocalizeMusicBox *localizeMusicBox;
@property(nonatomic,strong)UIAlertAction *secureTextAlertAction;
@property(nonatomic,strong)NSString *cupNewListName;
@property(nonatomic,strong)NSString *playLocalizeFlieMusicMark;
@property(nonatomic,strong)MyMusicListView *musicLictView;
@property(nonatomic,strong)FileOperateManager *fileManager;
@property(nonatomic,strong)MyMusicListView *myMusicListView;
@property(nonatomic,strong)UIImageView *redView;
@property(nonatomic,assign)CGFloat degree;
@property(nonatomic,strong)NSTimer *coverTime;
@property(nonatomic,copy)NSString *saveListName;

@end
static int play_button_click=1;
@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createTitleUI];
    [self createBodyUI];
    [self createToolBar];
    [self createShowListingUI];
    _musicBox=[MusicBox sharedInstance];
    _musicBox.delegate=self;
    _dbManager =[MusicListingDBManager sharedManager];
    _dbManager.delegate=self;
    _localizeMusicBox=[LocalizeMusicBox sharedInstance];
//    _localizeMusicBox.delegate=self;
    self.ifDetailedornot=@"NOT";
    self.deleteArray=[[NSMutableArray alloc]initWithCapacity:1];
    _musicLictView=[MyMusicListView sharedInstance];
    _musicLictView.delegate=self;
    _fileManager=[[FileOperateManager alloc]init];
    self.MyMusicListViewIsEdit=@"MyMusicListViewIsNotEdit";
    // Do any additional setup after loading the view.
    

    
    //开启第一响应
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self configPlayingInfo];

    
    [self askForAppBackGroundTime];
    
}

-(void)createTitleUI
{
    _titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 64)];
    _titleView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:_titleView];
    
    _findMusic=[MyButtonShop createButtonWithFrame:CGRectMake(92.5-20-20+10, 20, 80, 44-10) andTitle:@"发现音乐" andImage:nil andBgImage:nil andSelecter:@selector(toFindMusic) andTarget:self];
    _findMusic.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_findMusic];

    _myFM=[MyButtonShop createButtonWithFrame:CGRectMake(232.5, 20, 80, 44-10) andTitle:@"我的FM" andImage:nil andBgImage:nil andSelecter:@selector(toMyZoom) andTarget:self];
    _myFM.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_myFM];
    
    UIImage *image1=[UIImage imageNamed:@"cm2_list_loading1@3x"];
    UIImage *image2=[UIImage imageNamed:@"cm2_list_loading2@3x"];
    _playMarkImageArr=@[image1,image2];
    _playingMark =[[UIImageView alloc]init];
    _playingMark.frame=CGRectMake(330, 23.5, 25, 25);
    _playingMark.layer.cornerRadius=12.5;
    _playingMark.layer.masksToBounds=YES;
    _playingMark.hidden=YES;
    _playingMark.backgroundColor=[UIColor clearColor];
    _playingMark.animationImages=_playMarkImageArr;//将图片数组赋给动画特性属性
    _playingMark. animationRepeatCount=0;// 参数为数组内图片循环的次数，0为无限循环
    _playingMark.animationDuration=0.5;//每次循环需要的时间
    [_titleView addSubview:_playingMark];
    NSLog(@"_playMarkImageArr%lu",(unsigned long)_playMarkImageArr.count);

    
    
    
    _titleMark =[[UIImageView alloc]initWithFrame:CGRectMake(47.5+10, 60, 90, 2)];
    _titleMark.backgroundColor=[UIColor redColor];
    [_titleView addSubview:_titleMark];
    _findMusic.userInteractionEnabled=YES;
    _myFM.userInteractionEnabled=YES;
    
    
    
}
-(void)createBodyUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    float x=self.view.frame.size.width-20;
    float y= self.view.frame.size.height - 110;
    _bodyView= [[UIView alloc] initWithFrame:CGRectMake(10, 66, x*3 ,y)];
    

    _findMusicView=[[FindMusicView alloc]init];
    _findMusicView.view.frame =CGRectMake(0, 0,x,y);
    _findMusicView.delegate=self;
    _myFMZoom= [[MyFMZoom alloc] init];
    _myFMZoom.view.frame = CGRectMake(x+10, 0,x, y);
    //具体单曲的选择页面也添加在这里
    
    _detailedListView =[DetailedListView sharedInstance];
    _detailedListView.view.frame=CGRectMake(2*x+20,0,x,y);
    
    [_bodyView addSubview:_findMusicView.view];
    [_bodyView addSubview:_myFMZoom.view];
    [_bodyView addSubview:_detailedListView.view];
    _detailedListView.delegate=self;
    [self.view addSubview:_bodyView];

}
-(void)createToolBar
{
    _playView=[[UIView alloc]initWithFrame:CGRectMake(0, 667-44, 375, MENUBAR_DISTANCE+44)];//先把下面半截隐藏
    
    _playView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];//定义底色图层
//    _playView.backgroundColor=[UIColor grayColor];
    _playView.userInteractionEnabled=YES;
    [self.view addSubview:_playView];
    /**
     添加滑动手势
     
     */
       UISwipeGestureRecognizer *up= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp)];
    up.delegate=self;
    [up setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [_playView addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *down=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    down.delegate=self;
    [down setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [_playView addGestureRecognizer:down];

    float x=335.0/5.0;
    
    _playbutton =[MyButtonShop createButtonWithFrame:CGRectMake(47, 3, 37, 37) andTitle:nil andImage: nil andBgImage:[UIImage imageNamed:@"cm2_play_btn_play@3x"] andSelecter:@selector(playButtonClick) andTarget:self];
    
    [_playbutton setBackgroundImage:[UIImage imageNamed:@"cm2_play_btn_pause@3x"]forState:UIControlStateSelected];
    _playbutton.backgroundColor=[UIColor whiteColor];
    _playbutton.layer.cornerRadius=18.5;
    _playbutton.layer.masksToBounds=YES;
    
    
    [_playView addSubview:_playbutton];
    
    
    _collectbutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+2*x, 3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_rdi_btn_loved@3x"] andSelecter:@selector(addListingOpen) andTarget:self];
    _collectbutton.layer.cornerRadius=18.5;
    _collectbutton.layer.masksToBounds=YES;
    [_playView addSubview:_collectbutton];
    
    
    _sharebutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+3*x, 3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"share_normal"] andSelecter:@selector(shareMusic) andTarget:self];
//    _sharebutton.layer.cornerRadius=18.5;
    _sharebutton.layer.masksToBounds=YES;
    
    [_playView addSubview:_sharebutton];
    
    _nextOnebutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+4*x,3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_skin_btn_del@3x"] andSelecter:@selector(playNextOne) andTarget:self];
    _nextOnebutton.layer.cornerRadius=18.5;
    _nextOnebutton.layer.masksToBounds=YES;
    [_playView addSubview:_nextOnebutton];
    
    
    _picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_playView.frame.size.width/2-100, 110, 200, 200)];
    _picImageView.layer.cornerRadius=100;
    _picImageView.clipsToBounds=YES;
    _picImageView.backgroundColor=[UIColor blackColor];
    [_playView addSubview:_picImageView];
    
    _redView=[[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 80, 80)];
    _redView.layer.cornerRadius=40;
    _redView.clipsToBounds=YES;
    _redView.image=[UIImage imageNamed:@"cm2_act_checkbox_fg_prs@3x"];
    
    [_picImageView addSubview:_redView];
    
    
    
    _artist=[[UILabel alloc]initWithFrame:CGRectMake(40,60, 375-80, 40)];
    _artist.font=[UIFont boldSystemFontOfSize:18];
    _artist.textAlignment=NSTextAlignmentCenter;
    _artist.numberOfLines=0;
    _artist.alpha=0;    
    [_playView addSubview:_artist];
    
    _songtitle=[[UILabel alloc]initWithFrame:CGRectMake(20,330, 375-40, 40)];
    _songtitle.font=[UIFont boldSystemFontOfSize:18];
    _songtitle.textAlignment=NSTextAlignmentCenter;
    _songtitle.numberOfLines=0;
    _songtitle.alpha=0;
    [_playView addSubview:_songtitle];

}
-(void)createShowListingUI
{
    
    _listingView=[[UIView alloc]initWithFrame:CGRectMake(0, _playView.frame.size.height+250, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_listingView];
    _listingView.userInteractionEnabled=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _listingView.backgroundColor=[UIColor clearColor];
    _listingViewController=[ListingViewController sharedInstance];
    _listingViewController.view.frame=_listingView.bounds;
    [_listingView addSubview:_listingViewController.view];
    
}
-(void)toFindMusic
{
    [self closeMenu];
    [self addListingCloce];
    _myMusicListView=[MyMusicListView sharedInstance];
    [_myMusicListView newShowLocalizeMusicName];
    [_myMusicListView newShowMusicList];
    [_musicLictView setEditing:NO animated:YES];
    if (_findMusicView.FMLISTArray.count==0)
    {
        [_findMusicView downlondDataWithUrl:DOUBANFMLIST];

    }
    self.titleMark.alpha=1.0;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _titleMark.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0,0);
                _bodyView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0,0);
                
            }];
        });
    });
  
}
-(void)toMyZoom
{
//滑动界面
    [self closeMenu];
    [self addListingCloce];
    _myMusicListView=[MyMusicListView sharedInstance];
    [_myMusicListView newShowLocalizeMusicName];
    [_myMusicListView newShowMusicList];
    self.titleMark.alpha=1.0;
    [_musicLictView setEditing:NO animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.5 animations:^{
            _titleMark.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 170,0);

         _bodyView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -_bodyView.frame.size.width/3-10,0);

         }];
        });
    });
}
-(void)toDetailedListView
{
    [self closeMenu];
    [self addListingCloce];
    self.titleMark.alpha=0.0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                
                _bodyView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -_bodyView.frame.size.width*2/3-10,0);
            }];
        });
    });

}
#pragma mark 播放键的方法
-(void)playButtonClick
{
    if (_artist.text.length==0)
    {
        [_musicBox editURLWithIndex:0];
        _playbutton.selected=!_playbutton.selected;
        
    }
    else
    {
      if (play_button_click==1)
      {
        _playbutton.selected=!_playbutton.selected;
          [_playingMark stopAnimating];
        [_musicBox stopPlayMusic];
        play_button_click=0;
          NSLog(@"第一次点击功能为暂停 图标为播放");
          [_coverTime setFireDate:[NSDate distantFuture]];//无限远开始

          
    }
    
      else if(play_button_click==0)
     {
         NSLog(@"第二次点击功能为播放 图标为暂停");

        _playbutton.selected=!_playbutton.selected;
        [_musicBox keepPlay];
        [_playingMark startAnimating];
        play_button_click=1;
         [_coverTime setFireDate:[NSDate date]];//从现在开始

     }
}
}

-(void)shareMusic
{
    if (_artist.text.length==0)
    {
        [self misoperationPass:@"请选择播放列表"];
    }
    else
    {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55bf7d1ee0f55a3ccc002b2c" shareText:@"嗯。。。这首歌不错" shareImage:[UIImage imageNamed:@"cm2_rcd_icn_artist@3x"] shareToSnsNames:@[UMShareToSina,UMShareToRenren,UMShareToYXSession,UMShareToWechatSession] delegate:self];
    }
}
-(void)playNextOne
{
    
    if (_artist.text.length==0)
    {
        [self misoperationPass:@"请选择播放列表"];
    }
    else
    {
    [_coverTime setFireDate:[NSDate distantFuture]];//无限远开始
//    [self makeCoverSpin];
    [_musicBox playNextMusic];
    }
//    if (play_button_click==1)
//    {
//        _playbutton.selected=YES;
//
//        play_button_click=0;
//
//    }
//    else
//    {
//        _playbutton.selected=NO;
//        play_button_click=1;
//    }

}

-(void)addListingOpen
{
    [_listingViewController createListSuccedd];
    NSLog(@"MyMusicListViewIsEdit=%@",self.MyMusicListViewIsEdit);
    if (_artist.text.length>0||(_artist.text.length==0&&[self.MyMusicListViewIsEdit isEqualToString:@"MyMusicListViewIsEdit"]))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    _listingView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0,-450+64);
                }];
            });
        });

    }
    else
    {
        [self misoperationPass:@"没有音乐播放，无法添加"];
    }
}
-(void)addListingCloce
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _listingView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0,0);
            }];
        });
    });

}
#pragma mark 本地列表键方法
-(void)playLastOneMusic
{
    [_coverTime setFireDate:[NSDate distantFuture]];//无限远开始

    //    新的键播放上一首歌
    if (_artist.text.length==0)
    {
        [self misoperationPass:@"请选择播放列表"];
    }
    else
    {
        [_musicBox playbeforeMuisc];
    }

}
-(void)stochasticPlayMusic
{

    //1循环 2随机 3单曲
    if ([self.mode isEqualToString:@"循环"])
    {
        [_stochasticbutton setImage:[UIImage imageNamed:@"cm2_play_btn_shuffle@3x"] forState:(UIControlStateNormal)];
        [_musicBox playWhitMode:2];
        NSLog(@"图片从循环变成随机,当前应该是随机模式");
        self.mode=@"随机";
    }
    else if ([self.mode isEqualToString:@"随机"])
    {
        NSLog(@"图片从随机变成单曲,当前应该是单曲模式");
        [_stochasticbutton setImage:[UIImage imageNamed:@"cm2_play_btn_one@3x"] forState:(UIControlStateNormal)];
        [_musicBox playWhitMode:3];
        self.mode=@"单曲";
    }
    else if ([self.mode isEqualToString:@"单曲"])
    {
        NSLog(@"图片从单曲变成循环,当前应该是循环模式");
        [_stochasticbutton setImage:[UIImage imageNamed:@"cm2_play_btn_loop@3x"] forState:(UIControlStateNormal)];
        [_musicBox playWhitMode:1];
        self.mode=@"循环";
    }
    //新的键随机播放方法
}

-(void)sliderChange:(UISlider *)slider
{
   //滑动条滑动调用
    if (self.playLocalizeFlieMusicMark.length>3)
    {
//        self.localizeMusicBox.progress=slider.value;
        [_localizeMusicBox sliderPlayWithSlider:slider];
    }else
    {
        [_musicBox sliderPlayWithSlider:slider];
    }
}

#pragma mark 手势方法
-(void)handleSwipeUp
{
    [self performSelectorInBackground:@selector(openMenu) withObject:nil];
    
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer
{

    [self performSelectorInBackground:@selector(closeMenu) withObject:nil];
    
}
#pragma mark 动画方法
-(void)openMenu
{
    [_musicLictView setEditing:NO animated:YES];
    if ([_ifDetailedornot isEqualToString:@"NOT"])
    {
        [self openFMlistPlayMenu];
        [_myMusicListView clocePlayingMark];
        [_detailedListView clocePlayingMark];
        
    }
    if([_ifDetailedornot isEqualToString:@"YES"])
    {
        [self openDetailedListMenu];
        [_findMusicView closePlayingMark];
    }
}
-(void)closeMenu
{
    [_musicLictView setEditing:NO animated:YES];
    NSLog(@"当前的频道为：%@",_ifDetailedornot);
    if ([_ifDetailedornot isEqualToString:@"NOT"])
    {
        [self closeFMlistPlayMenu];
    }
    if([_ifDetailedornot isEqualToString:@"YES"])
    {
        [self closeDetailedPlayMenu];
    }

}
-(void)closeDetailedPlayMenu
{
       float x=0.01;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:15*x animations:^{
            _picImageView.alpha=x;
            _slider.alpha=x;
            _songtitle.alpha=x;
            _artist.alpha=x;

        }];
        [UIView animateWithDuration:0.5 animations:^{
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _playlastOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _stochasticbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _trashbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _playnextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);

        }];
    });

}
-(void)closeFMlistPlayMenu
{
    float x=0.01;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:15*x animations:^{
            _picImageView.alpha=x;
            _slider.alpha=x;
            _songtitle.alpha=x;
            _artist.alpha=x;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _collectbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _sharebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _nextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        }];
        
    });

}
-(void)openFMlistPlayMenu
{
    float i=0.02;
    //    回到主线程中刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addListingCloce];
        [_playlastOnebutton removeFromSuperview];
        [_stochasticbutton removeFromSuperview];
        [_trashbutton removeFromSuperview];
        [_playnextOnebutton removeFromSuperview];
        [_slider removeFromSuperview];
        _playlastOnebutton = nil;
        
        self.mode=@"循环";
        [_playView addSubview:_collectbutton];
        [_playView addSubview:_sharebutton];
        [_playView addSubview:_nextOnebutton];

        [UIView animateWithDuration:25*i animations:^{
           
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 120.5, MENUBAR_DISTANCE-150);
            _collectbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
            _sharebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
            _nextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
            //            _nextOnebutton.transform=CGAffineTransform
            _picImageView.alpha=0.75;
            _songtitle.alpha=0.9;
            _artist.alpha=0.9;
            
            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -MENUBAR_DISTANCE);
        }];
    });

}
-(void)openDetailedListMenu
{
    float i=0.02;
    float x=44;
//    float y=self.
    //    回到主线程中刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addListingCloce];
        [_collectbutton  removeFromSuperview];
        [_sharebutton removeFromSuperview];
        [_nextOnebutton removeFromSuperview];

        [UIView animateWithDuration:25*i animations:^{
            //
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 120.5, MENUBAR_DISTANCE-150);
            _playlastOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -x, MENUBAR_DISTANCE-75);
            _stochasticbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -x, MENUBAR_DISTANCE-75);
            _trashbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -x, MENUBAR_DISTANCE-75);
            _playnextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -x+3.5, MENUBAR_DISTANCE-75);
            _picImageView.alpha=0.75;
            _songtitle.alpha=0.9;
            _artist.alpha=0.9;
            _slider.alpha=0.9;
            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -MENUBAR_DISTANCE);
        }];
    });

}
-(void)makeCoverSpin
{
    [_coverTime invalidate];
    _coverTime=nil;
    _coverTime=[NSTimer scheduledTimerWithTimeInterval:1.0/15.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

}
-(void)timerAction
{
//    NSLog(@"这是新的封面时钟");
    _degree += 1;
    [UIView animateWithDuration:0.1 animations:^
     {
         CGAffineTransform at = CGAffineTransformMakeRotation(M_PI / 180 * _degree);//M_PI
         [_picImageView setTransform:at];
         
     }];
}
#pragma mark 这是手势小布丁
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // Recognizers of this class are the first priority
}
#pragma mark 音乐网址读出回调信息
-(void)PassMusicArtist:(NSString *)artist andAlbumtitle:(NSString *)albumtitle
{   
    _artist.text=artist;
    _songtitle.text=albumtitle;
    if (_artist.text.length==0)
    {
        _playingMark.hidden=YES;
    }
    else
    {
        _playingMark.hidden=NO;
        [_playingMark startAnimating];

    }
    if (play_button_click==1)
    {
        return;
    }
    else
    {
        _playbutton.selected=NO;
        play_button_click=1;
    }

    [self makeMarkWithArtist:artist andAlbumtitle:albumtitle];
}
-(void)PassMusicImage:(UIImage *)musicImage
{
    [_redView removeFromSuperview];
    _picImageView.image=musicImage;
    if (!musicImage)
    {
        [_picImageView addSubview:_redView];
    }
    
}
-(void)PassMusicElapsedTime:(NSDate *)elapsedTimeDate andTimeRemainingDate:(NSDate *)timeRemainingDate andPercentage:(int)percentage
{
//    NSLog(@"dnasidsa");
    _slider.value = percentage * 0.01;
    
//    [UIView animateWithDuration:0.1 animations:^
//    {
//        CGAffineTransform at = CGAffineTransformMakeRotation(angle);//M_PI
//        [_picImageView setTransform:at];
//
//    }];
    if (nowtime!=(int)timeRemainingDate)
    {
//        nowtime=(int)timeRemainingDate;
//        angle = angle+0.03;//angle角度 double angle;
//        if (angle > 6.28)
//        {//大于 M_PI*2(360度) 角度再次从0开始
//                 angle = 0;
//        }
//        [self makeCoverSpin];
        
        
    }
}
-(void)PassNowPlayMusicUrl:(NSString *)url
{
    self.nowPlayMusicURL=url;
}
-(void)PassMusicInformation:(dataModel *)data
{
    _playbutton.selected=YES;
    play_button_click=1;
    self.playLocalizeFlieMusicMark=data.localizemusic;
    [self.deleteArray removeAllObjects];
    [self.deleteArray addObject:data];
}
#pragma mark 利用md5给文件写个编号
-(NSString *)makeMarkWithArtist:(NSString *)artist andAlbumtitle:(NSString *)albumtitle
{
    NSString *str=[NSString stringWithFormat:@"%@%@",artist,albumtitle];
    return [JHYMD5CodeTool MD5StringFromString:str];
}
-(void)playerIsChange
{
//    angle = 0;
    _slider.value=0;
//    [_coverTime setFireDate:[NSDate distantFuture]];//无限远开始

    [self makeCoverSpin];
    dispatch_async(dispatch_get_main_queue(),
        ^{
            //            先让btn往左偏移20
        _picImageView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -15, 0);
            _degree=0;
            _artist.alpha=0.0;
            _songtitle.alpha=0.0;
                       //            动画时间0.3，延迟0.3
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            _songtitle.alpha=0.9;
            _artist.alpha=0.9;
            _picImageView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                       } completion:^(BOOL finished) {
                           
        }];
    });
}

#pragma mark 数据库存储完成的回调
-(void)saveInformationSucceed
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"完成" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:cancelAction];
  // 以模态方式显示警告视图控制器
    [self presentViewController:alertController animated:YES
        completion:^{
            [self addListingCloce];
        
        }];
}
#pragma mark 万用模态提示框
-(void)misoperationPass:(NSString *)note
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",note]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 以模态方式显示警告视图控制器
    [self presentViewController:alertController animated:YES
                     completion:^{
                         [self addListingCloce];
                         
                     }];
}
#pragma mark 网络不佳提示框
-(void)theNetorkIsUnstable:(NSString *)url
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查网络"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 以模态方式显示警告视图控制器
    [self presentViewController:alertController animated:YES
                     completion:^{
                         [self addListingCloce];
                         [_findMusicView downlondDataWithUrl:url];
                         NSLog(@"网差请求一次");
                     }];
}
-(void)isMusicListLastMusic:(NSMutableArray *)array
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是列表的最后一首歌"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 以模态方式显示警告视图控制器
    [self presentViewController:alertController animated:YES
                     completion:^{
                         [self addListingCloce];
                         if (array.count>0)
                         {
                             [_musicBox playMusicWith:array andIndexis:0];
                         }else if(array.count==0)
                         {
                             return ;
                         }
                         
                     }];

}
#pragma mark 开启模态视窗 输入列表名
-(void)makeNewDetailedListView
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入列表名" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定键的回调
        [self addListingCloce];
        UITextField *cupTF=alertController.textFields.firstObject;
        self.cupNewListName=cupTF.text;
        [self ifDownlondNowPlayMusicOrNotWith:self.cupNewListName];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        //        取消键的回调 移除通知中心
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"列表名称";
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    okAction.enabled =NO;
    self.secureTextAlertAction = okAction;
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
#pragma mark 创建新列表 并将现有本地文件添加进列表的方法
/**并将现有本地文件添加进列表的方法*/
-(void)addLocalizeMusicToMusicListWithLocalizeMusic:(NSArray *)localizeArray
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入列表名" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定键的回调

        [self addListingCloce];
        UITextField *cupTF=alertController.textFields.firstObject;
        self.cupNewListName=cupTF.text;
        for (int i=0; i<localizeArray.count; i++)
        {
            @synchronized(self)
            {
                //锁定内容
                dataModel *model=localizeArray[i];
                [_dbManager addLocalizeMusicListWithListName:cupTF.text andDataArray:model];
            }
            if (i==localizeArray.count-1)
            {
                [_myMusicListView saveInformationSucceed];
            }
           
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        //        取消键的回调 移除通知中心
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"列表名称";
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];

    okAction.enabled=NO;
    okAction.enabled=_secureTextAlertAction.enabled;
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
    
    }];

}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {

    UITextField *textField = notification.object;
    self.secureTextAlertAction.enabled=textField.text.length>0;
}
-(void)ifDownlondNowPlayMusicOrNotWith:(NSString *)listName
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否下载音乐到本地" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        //确定键的回调
        DownLondMusicAndSave *downlondManager=[DownLondMusicAndSave sharedInstance];
        downlondManager.delegate=self;
        if ([downlondManager opinionFileName:[self makeMarkWithArtist:self.artist.text andAlbumtitle:self.songtitle.text]])
        {
            //只有在这首歌没有下载过的情况下下载单曲
            self.saveListName=listName;
            [downlondManager downloadMusicFileWithDataModel:self.deleteArray[0] andFileNameIs:[self makeMarkWithArtist:self.artist.text andAlbumtitle:self.songtitle.text]];
        }

}];

    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"仅添加" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {

        [_dbManager createNewMusicListWithListName:listName andLocalizemusic:@"1"];
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:^{
        [_listingViewController newLoadMusicList];
        [self addListingCloce];
        
    }];
}
#pragma make 下载成功的回调
-(void)DownLondMusicSucceed:(dataModel *)model
{
    [self misoperationPass:@"下载成功"];
    
    [_dbManager createNewMusicListWithListName:self.saveListName andLocalizemusic:[self makeMarkWithArtist:self.artist.text andAlbumtitle:self.songtitle.text]];
    MyMusicListView *myMusicListView=[MyMusicListView sharedInstance];
    [myMusicListView newShowLocalizeMusicName];
}
#pragma mark 删除本地文件时的模态对话框
-(void)isDeleteLocalizeWithListORNotWithModel:(dataModel *)model
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否同时从列表中删除歌曲" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        NSArray *delete=@[model];
        [_dbManager deleteMusiclitWithListNameArray:delete];
        [_fileManager deleteLocalizeFileWith:model.localizemusic];
        
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"保留" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSArray *delete=@[model];
        [_dbManager changeMusicFileIsLocalizeMusicOrNotWithArray:delete];
        [_fileManager deleteLocalizeFileWith:model.localizemusic];
        
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        [_musicLictView newShowLocalizeMusicName];
        [_detailedListView deleteNowPlayMusicJudgeList];
        
        
    }];
    
}
#pragma mark 在我的列表界面的删除提示
-(void)isDeleteMusicListWithMyMusicListORNotWithMusicListName:(NSString *)listName
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保留列表中的下载歌曲" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
       //查找出这个列表下的所有歌曲名抹掉列表并且删除本地音乐
        NSArray *localizeMusicArray=[[NSArray alloc]init];
        localizeMusicArray=[_dbManager newQueryMusicListWithListName:listName];
        [_fileManager deleteLocalizeDataWith:localizeMusicArray];
    //删除将列表中的歌曲都移除
        [_dbManager deleteMusiclitWithListName:listName];
        [_musicLictView newShowMusicList];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"保留" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
    //保留的同时需要将其列表名抹去，但是保证其必须能被查找到
        
        NSArray *localizeMusicArray=[[NSArray alloc]init];
        localizeMusicArray=[_dbManager newQueryMusicListWithListName:listName];
        [_dbManager changeMusicLictWithArray:localizeMusicArray];
        [_musicLictView newShowMusicList];
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        
    }];

}
#pragma mark 删除当前正在播放的歌曲的方法
-(void)deleteNowMusic
{
    
    dataModel *model=_deleteArray[0];
    if (model.localizemusic.length>3)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除本地音乐" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            //确定键的回调
            NSFileManager * fm = [NSFileManager defaultManager];
            NSString *filePath=[NSString stringWithFormat:@"%@/Documents/music/%@.mp4",NSHomeDirectory(),model.localizemusic];
            if ([fm fileExistsAtPath:filePath])
            {
                BOOL tag5=[fm removeItemAtPath:filePath error:nil];
                if (tag5)
                {
                    [self misoperationPass:@"删除成功"];
                }
                else
                {
                    [self misoperationPass:@"删除失败"];
                }
            }
            [_dbManager deleteMusiclitWithListNameArray:self.deleteArray];
            [self deleteNowPlayMusicDone:model];
            
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"保留" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            [_dbManager changeMusicLictWithArray:self.deleteArray];
            NSLog(@"保留本地音乐");
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:^{
                   }];
        
    }else if (model.localizemusic.length<3)
    {
        [_dbManager deleteMusiclitWithListNameArray:self.deleteArray];
        [self deleteNowPlayMusicDone:model];
    }
    

    
}
-(void)deleteNowPlayMusicDone:(dataModel *)model
{
    [self playLastOneMusic];
    _myMusicListView=[MyMusicListView sharedInstance];
    [_myMusicListView newShowLocalizeMusicName];
    [_myMusicListView newShowMusicList];
    [_myMusicListView loadDataWhitMusicList:self.nowPlayMusicListName];
    [_detailedListView deleteNowPlayMusicJudgeList];

}
#pragma mark 选择FM比方列表的回调
-(void)PlayFMMusicListDelegatePassMark:(NSString *)mark
{
    self.ifDetailedornot=mark;
}
#pragma mark 选择本地播放列表是调用
//若本地列表点击调用，变换页码方法
-(void)PlayDetaliedMusicListDelegatePassMark:(NSString *)mark
{
    [self popPlayView];
    self.ifDetailedornot=mark;
    if (_playlastOnebutton == nil) {
        [self createNowToolBarUI];
    }
    [self openMenu];
}
-(void)PlayAllDetaliedMusicListDelegatePassMark:(NSString *)mark
{
    [self PlayDetaliedMusicListDelegatePassMark:mark];
}
-(void)passNowPlayMusicListName:(NSString *)nowPlayMusicListName
{
    self.nowPlayMusicListName=nowPlayMusicListName;
}
-(void)createNowToolBarUI
{
    float x=335.0/5.0;
    //新增上一首键
    _playlastOnebutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+x-3.5, 3+3.5, 30, 30) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_skin_btn_arr_right@3x"] andSelecter:@selector(playLastOneMusic) andTarget:self];
    _playlastOnebutton.layer.cornerRadius=15;
    _playlastOnebutton.layer.masksToBounds=YES;
    [_playView addSubview:_playlastOnebutton];
    
    
    //移除本地存储，添加前进后退垃圾箱和进度条
    //新增随机播放键
    _stochasticbutton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [_stochasticbutton setImage:[UIImage imageNamed:@"cm2_play_btn_loop@3x"] forState:(UIControlStateNormal)];
    _stochasticbutton.frame=CGRectMake(47+2*x, 3, 37, 37);
    [_stochasticbutton addTarget:self action:@selector(stochasticPlayMusic) forControlEvents:(UIControlEventTouchUpInside)];
    _stochasticbutton.layer.cornerRadius=18.5;
    _stochasticbutton.layer.masksToBounds=YES;
    self.mode=@"循环";

    
    [_playView addSubview:_stochasticbutton];
    
//    新增垃圾桶键
    _trashbutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+3*x, 3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_rdi_btn_dlt@3x"] andSelecter:@selector(deleteNowMusic) andTarget:self];
    _trashbutton.layer.cornerRadius=18.5;
    _trashbutton.layer.masksToBounds=YES;
    [_playView addSubview:_trashbutton];
    
    //新增下一首键
    _playnextOnebutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+4*x-3.5,3+3.5, 30, 30) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_skin_btn_arr_right@3x副本"] andSelecter:@selector(playNextOne) andTarget:self];
    _playnextOnebutton.layer.cornerRadius=15;
    _playnextOnebutton.layer.masksToBounds=YES;
    [_playView addSubview:_playnextOnebutton];
    //新增滑条
    _slider=[[UISlider alloc]initWithFrame:CGRectMake(47,545,_playView.frame.size.width-47-47, 15)];//长度有效，高度无效，固定高度20，0时不能移动
    _slider.tintColor=[UIColor whiteColor];
    //    是否实时变化continuous
    _slider.continuous=YES;//为动态值，no时只有松手后的最终值
    //  添加事件
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [_playView addSubview:_slider];
}
-(void)popPlayView
{
//    dispatch_async(dispatch_get_main_queue(),
//                   ^{
//                       _playView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                       [_collectbutton removeFromSuperview];
                       [_sharebutton removeFromSuperview];
                       [_nextOnebutton removeFromSuperview];
//                       [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//                           
                           _playView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
//                       } completion:^(BOOL finished) {
                           _playView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                           
//                       }];
//                   });
//
}

#pragma mark 单例
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static RootViewController *rootViewController = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        rootViewController = [[self alloc] initPrivate];
    });
    return rootViewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存警告");
    
    // Dispose of any resources that can be recreated.
}
#pragma mark 后台播放系列
//设置锁屏状态，显示的歌曲信息
- (void)configPlayingInfo
{
    if (self.deleteArray.count==0)
    {
        return;
    }
    else{
    dataModel *model= self.deleteArray[0];
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        if (model.title.length>1)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:model.title
                     forKey:MPMediaItemPropertyTitle];
            [dict setObject:model.artist
                     forKey:MPMediaItemPropertyArtist];
            UIImage *tempImage = _picImageView.image;
            if (tempImage != nil) {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:tempImage] forKey:MPMediaItemPropertyArtwork];
            }
            [dict
             setObject:[NSNumber numberWithInt:nowtime]
             forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
   }
}

#pragma mark - 设置控制中心
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
                [self playButtonClick]; // 切换播放、暂停按钮
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self playNextOne]; // 播放下一曲按钮
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                
            if([_ifDetailedornot isEqualToString:@"YES"])
                {
                    [self playLastOneMusic];
                }
                else if([_ifDetailedornot isEqualToString:@"No"])
                {
                    NSLog(@"9999");
                }

                break;
            default:
                break;
        }
    }
}
static int shake =0;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (event.subtype==UIEventSubtypeMotionShake)
    {
        
       [self playNextOne];
        shake ++;
        NSLog(@"%d",shake);
    }

}
-(BOOL)canBecomeFirstResponder
{
    NSLog(@"摇一摇");
    return YES;
}


-(void)viewDidDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [self configPlayingInfo];
}
#pragma mark 延时方法
-(void)askForAppBackGroundTime
{
//    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    dispatch_queue_t queue=
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int i=0;
        NSLog(@"[%d],%.0f",i,[UIApplication sharedApplication].backgroundTimeRemaining);
        [NSThread sleepForTimeInterval:1.0];
        while (i)
        {
            [(AppDelegate *)[[UIApplication sharedApplication]delegate] endBackgroundTask];
        }
    });
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
