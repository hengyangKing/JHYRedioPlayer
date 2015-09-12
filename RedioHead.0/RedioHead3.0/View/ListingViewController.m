//
//  ListingViewController.m
//  RedioHead3.0
//
//  Created by J on 15/8/15.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "ListingViewController.h"
#import "MyButtonShop.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MusicListingDBManager.h"
#import "MyMusicListView.h"
@interface ListingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *listingTabelView;
@property(nonatomic,strong)NSMutableArray *muiscListArray;
@property(nonatomic,strong)UIButton *addListButton;
@property(nonatomic,strong)UIView *addListView;
@property(nonatomic,strong)UIImageView *addImageView;
@property(nonatomic,strong)UIButton *cloceButton;
@property(nonatomic,strong)RootViewController *rootVC;
@property(nonatomic,strong)MusicListingDBManager *musicListDBManager;


@end

@implementation ListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self newLoadMusicList];
    self.muiscListArray=[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.musicListDBManager=[MusicListingDBManager sharedManager];
    _rootVC=[RootViewController sharedInstance];
    _localizeMusicList=[[NSMutableArray alloc]init];
    self.MyMusicListViewIsEdit=@"MyMusicListViewIsNotEdit";
    
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    self.listingTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) style:(UITableViewStylePlain)];
    self.listingTabelView.delegate=self;
    self.listingTabelView.dataSource=self;
    self.listingTabelView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [self.view addSubview:self.listingTabelView];
}

#pragma mark 新写的装载数据的方法
-(void)newLoadMusicList
{
    [_muiscListArray removeAllObjects];
    _muiscListArray=[self.musicListDBManager queryMusicList];
    [self.listingTabelView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muiscListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *musicList=[NSString stringWithFormat:@"%@",cell.textLabel.text];
    if ([self.MyMusicListViewIsEdit isEqualToString:@"MyMusicListViewIsEdit"])
    {
        //只有再本地文件选择列表调用时不需要对是否下载进行判断
//        直接将选择的数据包传过去写入
        for (int i=0; i<self.localizeMusicList.count; i++)
        {
            @synchronized(self)
            {
            dataModel *model=self.localizeMusicList[i];
            [_musicListDBManager addLocalizeMusicListWithListName:musicList andDataArray:model];
            }
            if (i==self.localizeMusicList.count-1)
            {
                MyMusicListView *myMusicListView=[MyMusicListView sharedInstance];
                [myMusicListView saveInformationSucceed];
            }
        }
        
    }
    else if([self.MyMusicListViewIsEdit isEqualToString:@"MyMusicListViewIsNotEdit"])
    {
//        播放网络文件是需要对下载列表进行判断
        [_rootVC ifDownlondNowPlayMusicOrNotWith:musicList];

    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _addListView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, 375-40, 50)];
    _addListView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    
    _cloceButton=[MyButtonShop createButtonWithFrame:CGRectMake(20, 20, 24, 12) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_act_icn_arr@3x"] andSelecter:@selector(cloceButtonClick) andTarget:self];
    [_addListView addSubview:_cloceButton];
    
    _addListButton=[MyButtonShop createButtonWithFrame:CGRectMake(195, 5,120, 40) andTitle:@"创建新列表" andImage:nil andBgImage:nil andSelecter:@selector(makeNowMusicList) andTarget:self];
    _addListButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    _addListButton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_addListView addSubview:_addListButton];
    
    _addImageView=[[UIImageView alloc]initWithFrame:CGRectMake(375-20-40, 5, 40, 40)];
    _addImageView.image=[UIImage imageNamed:@"cm2_artist_fav_icon@3x"];
    [_addListView addSubview:_addImageView];
    
    return _addListView;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"musiclist"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"musiclist"];
    }
    cell.textLabel.text=_muiscListArray[indexPath.row];
    
    return cell;
}
-(void)makeNowMusicList
{
    if ([self.MyMusicListViewIsEdit isEqualToString:@"MyMusicListViewIsNotEdit"])
    {
        [_rootVC makeNewDetailedListView];
    }else if([self.MyMusicListViewIsEdit isEqualToString:@"MyMusicListViewIsEdit"])
    {
        [_rootVC addLocalizeMusicToMusicListWithLocalizeMusic:self.localizeMusicList];
    }
}

-(void)cloceButtonClick
{
    [_rootVC addListingCloce];
}
-(void)createListSuccedd
{
    [self newLoadMusicList];
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
    static ListingViewController *listViewController = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        listViewController = [[self alloc] initPrivate];
    });
    return listViewController;
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
