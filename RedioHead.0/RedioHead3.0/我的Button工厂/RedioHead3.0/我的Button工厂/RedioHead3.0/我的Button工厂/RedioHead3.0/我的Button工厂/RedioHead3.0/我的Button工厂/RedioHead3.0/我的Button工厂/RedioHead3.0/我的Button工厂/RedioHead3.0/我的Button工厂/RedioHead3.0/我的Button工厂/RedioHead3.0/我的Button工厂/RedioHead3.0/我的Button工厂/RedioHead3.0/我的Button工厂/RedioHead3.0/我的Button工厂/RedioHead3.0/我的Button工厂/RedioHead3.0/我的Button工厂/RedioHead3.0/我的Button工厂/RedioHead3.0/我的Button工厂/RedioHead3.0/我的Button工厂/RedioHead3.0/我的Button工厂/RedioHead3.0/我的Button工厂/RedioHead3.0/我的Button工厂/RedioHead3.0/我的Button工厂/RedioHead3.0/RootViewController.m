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
#import "ListingViewController.h"
#define MENUBAR_DISTANCE 559.f
#define LISTING_DISTANCE 150.f
static int nowtime=1000.0;
static float angle=0.0;
@interface RootViewController ()<UIGestureRecognizerDelegate,PassMusicInformationDelegate>
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *findMusic;
@property(nonatomic,strong)UIButton *myFM;
@property(nonatomic,strong)UIImageView *titleMark;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)FindMusicView *findMusicView;
@property(nonatomic,strong)MyFMZoom *myFMZoom;
@property(nonatomic,strong)ListingViewController *listingViewController;
@property(nonatomic,strong)UIView *playView;
@property(nonatomic,strong)UIButton *playbutton;
@property(nonatomic,strong)UIButton *collectbutton;
@property(nonatomic,strong)UIButton *trashbutton;
@property(nonatomic,strong)UIButton *nextOnebutton;
@property(nonatomic,strong)UIImageView *picImageView;
@property(nonatomic,strong)UILabel *artist;
@property(nonatomic,strong)UILabel *albumtitle;
@property(nonatomic,strong)UIView *listingView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createTitleUI];
    [self createBodyUI];
    [self createToolBar];
    [self createShowListingUI];
    MusicBox *musicBox=[MusicBox sharedInstance];
    musicBox.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)createTitleUI
{
    _titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 64)];
    _titleView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:_titleView];
    
    _findMusic=[MyButtonShop createButtonWithFrame:CGRectMake(20, 20, 375/2-20, 44-10) andTitle:@"发现音乐" andImage:nil andBgImage:nil andSelecter:@selector(toFindMusic) andTarget:self];
    _findMusic.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_findMusic];

    _myFM=[MyButtonShop createButtonWithFrame:CGRectMake(375/2, 20, 375/2-20, 44-10) andTitle:@"我的FM" andImage:nil andBgImage:nil andSelecter:@selector(toMyZoom) andTarget:self];
    _myFM.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_myFM];
    
    _titleMark =[[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 375/2-30-70, 2)];
    _titleMark.backgroundColor=[UIColor redColor];
    [_titleView addSubview:_titleMark];
    _findMusic.userInteractionEnabled=YES;
    _myFM.userInteractionEnabled=YES;
    

}
-(void)createBodyUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;

    _bodyView= [[UIView alloc] initWithFrame:CGRectMake(10, 66, self.view.frame.size.width-20 , self.view.frame.size.height - 110)];
//    _scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_bodyView];
    

//    _bodyView.contentSize=  CGSizeMake(_scrollView.frame.size.width * 2, 0);
//    _scrollView.pagingEnabled = YES;
    _findMusicView=[[FindMusicView alloc]init];
    _findMusicView.view.frame =_bodyView.bounds;
    
//    self.automaticallyAdjustsScrollViewInsets=NO;

    _myFMZoom= [[MyFMZoom alloc] init];
    _myFMZoom.view.frame = CGRectMake(CGRectGetWidth(_bodyView.frame)+10, 0, CGRectGetWidth(_bodyView.frame)-20, CGRectGetHeight(_bodyView.frame));
    
    [_bodyView addSubview:_findMusicView.view];
    [_bodyView addSubview:_myFMZoom.view];
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
    
    _playbutton =[MyButtonShop createButtonWithFrame:CGRectMake(47, 3, 37, 37) andTitle:nil andImage: nil andBgImage:[UIImage imageNamed:@"cm2_play_btn_pause@3x"] andSelecter:@selector(playButtonClick) andTarget:self];
    [_playbutton setBackgroundImage:[UIImage imageNamed:@"cm2_play_btn_play@3x"]forState:UIControlStateSelected];
    _playbutton.backgroundColor=[UIColor whiteColor];
    _playbutton.layer.cornerRadius=18.5;
    _playbutton.layer.masksToBounds=YES;
    
    
    [_playView addSubview:_playbutton];
    
    
    _collectbutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+2*x, 3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_rdi_btn_loved@3x"] andSelecter:@selector(addListingOpen) andTarget:self];
    _collectbutton.layer.cornerRadius=18.5;
    _collectbutton.layer.masksToBounds=YES;
    
    [_playView addSubview:_collectbutton];
    
    
    _trashbutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+3*x, 3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_rdi_btn_dlt@3x"] andSelecter:@selector(moveToTrash) andTarget:self];
    _trashbutton.layer.cornerRadius=18.5;
    _trashbutton.layer.masksToBounds=YES;
    
    [_playView addSubview:_trashbutton];
    
    _nextOnebutton=[MyButtonShop createButtonWithFrame:CGRectMake(47+4*x,3, 37, 37) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_skin_btn_del@3x"] andSelecter:@selector(playNextOne) andTarget:self];
    _nextOnebutton.layer.cornerRadius=18.5;
    _nextOnebutton.layer.masksToBounds=YES;
    [_playView addSubview:_nextOnebutton];
    
    
    _picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_playView.frame.size.width/2-100, 110, 200, 200)];
    _picImageView.layer.cornerRadius=100;
    _picImageView.clipsToBounds=YES;
    _picImageView.backgroundColor=[UIColor blackColor];
    [_playView addSubview:_picImageView];
    
    _artist=[[UILabel alloc]initWithFrame:CGRectMake(40,60, 375-80, 40)];
    _artist.font=[UIFont boldSystemFontOfSize:18];
    _artist.textAlignment=NSTextAlignmentCenter;
    _artist.numberOfLines=0;
//    _artist.tintColor=[UIColo
    _artist.alpha=0;
    [_playView addSubview:_artist];
    
    _albumtitle=[[UILabel alloc]initWithFrame:CGRectMake(10,330, 375-10, 40)];
    _albumtitle.font=[UIFont boldSystemFontOfSize:18];
    _albumtitle.textAlignment=NSTextAlignmentCenter;
    _albumtitle.numberOfLines=0;
    _albumtitle.alpha=0;
    [_playView addSubview:_albumtitle];

}
-(void)createShowListingUI
{
    
    _listingView=[[UIView alloc]initWithFrame:CGRectMake(0, _playView.frame.size.height+250, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_listingView];
    _listingView.userInteractionEnabled=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _listingView.backgroundColor=[UIColor clearColor];
    _listingViewController=[[ListingViewController alloc]init];
    _listingViewController.view.frame=_listingView.bounds;
    [_listingView addSubview:_listingViewController.view];
    
}
-(void)toFindMusic
{
    [self closeMenu];
    [self addListingCloce];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.5 animations:^{
            _titleMark.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 170,0);

         _bodyView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -_bodyView.frame.size.width,0);

         }];
        });
    });
}
static int i=1;
-(void)playButtonClick
{
    MusicBox *musicBox=[MusicBox sharedInstance];
    if (i==1) {
        _playbutton.selected=!_playbutton.selected;
        [musicBox stopPlayMusic];
        i=0;
    }else if(i==0)
    {
        _playbutton.selected=!_playbutton.selected;
        [musicBox keepPlay];
        i=1;
    }
}
-(void)moveToTrash
{
    
    
}
-(void)playNextOne
{
    MusicBox *musicBox=[MusicBox sharedInstance];
    [musicBox playNextMusic];
}
-(void)addListingOpen
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _listingView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0,-450+64);
            }];
        });
    });

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
    float i=0.02;
    //    回到主线程中刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
//        _playbutton.alpha=0;
        [UIView animateWithDuration:25*i animations:^{
            //            _menuButton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -MENUBAR_DISTANCE, 0);
            //            _menuButton.alpha=0;
            //           2.显示MenuBar
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 120.5, MENUBAR_DISTANCE-150);
            _collectbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
            _trashbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
            _nextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -80.5, MENUBAR_DISTANCE-60);
//            _nextOnebutton.transform=CGAffineTransform
            _picImageView.alpha=0.75;
            _albumtitle.alpha=0.9;
            _artist.alpha=0.9;

            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -MENUBAR_DISTANCE);
        }];
    });
}
-(void)closeMenu
{
    float x=0.01;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:15*x animations:^{
        _picImageView.alpha=x;
            }];
        [UIView animateWithDuration:0.5 animations:^{
            _playbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _collectbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0 , 0);
            _trashbutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _nextOnebutton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            _playView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            
        }];
        
    });
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // Recognizers of this class are the first priority
}
#pragma mark 音乐网址读出回调信息
-(void)PassMusicArtist:(NSString *)artist andAlbumtitle:(NSString *)albumtitle
{   
    _artist.text=artist;
    _albumtitle.text=albumtitle;
}
-(void)PassMusicImage:(UIImage *)musicImage
{
    _picImageView.image=musicImage;
}
-(void)PassMusicElapsedTime:(NSDate *)elapsedTimeDate andTimeRemainingDate:(NSDate *)timeRemainingDate
{
    CGAffineTransform at = CGAffineTransformMakeRotation(angle);//M_PI
    if (nowtime!=(int)timeRemainingDate)
    {
        nowtime=(int)timeRemainingDate;
        angle = angle + 0.03;//angle角度 double angle;
        if (angle > 6.28)
        {//大于 M_PI*2(360度) 角度再次从0开始
                 angle = 0;
        }
        [_picImageView setTransform:at];
    }
}

-(void)playerIsChange
{
    angle = 0;
    dispatch_async(dispatch_get_main_queue(),
        ^{
            //            先让btn往左偏移20
        _picImageView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -15, 0);
            _artist.alpha=0.0;
            _albumtitle.alpha=0.0;
                       //            动画时间0.3，延迟0.3
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            _albumtitle.alpha=0.9;
            _artist.alpha=0.9;
            _picImageView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                       } completion:^(BOOL finished) {
                           
        }];
    });

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
    // Dispose of any resources that can be recreated.
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
