//
//  MyMusicListView.m
//  RedioHead3.0
//
//  Created by J on 15/8/18.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MyMusicListView.h"
#import "MusicListingDBManager.h"
#import "MyButtonShop.h"
#import "DetailedListView.h"
#import "RootViewController.h"
#import "RelondLocalizeMusicInformation.h"
#import "MusicBox.h"
#import "ListingViewController.h"
#import "MusicListingDBManager.h"
#import "DetailedListViewCell.h"
#import "FileOperateManager.h"
@interface MyMusicListView ()<UITableViewDataSource,UITableViewDelegate,MusicListDBManagerDelegate>
@property(nonatomic,strong)UITableView *myMusicListView;
@property(nonatomic,strong)UIView *editView;
@property(nonatomic,strong)UIButton *editListButton;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)NSMutableArray *myMusicListArray;
@property(nonatomic,strong)NSMutableArray *myDetaliedMusicArray;
@property(nonatomic,strong)NSMutableArray *musicArray;
@property(nonatomic,strong)DetailedListView *detailedListView;
@property(nonatomic,strong)RootViewController *rootViewController;
@property(nonatomic,strong)MusicListingDBManager *dbManager;
@property(nonatomic,strong)NSMutableArray *deleteArray;
@property(nonatomic,strong)NSMutableArray *addListArray;
@property(nonatomic,strong)NSString *titleName;


@end

@implementation MyMusicListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _myMusicListArray=[[NSMutableArray alloc]init];
    _musicArray=[[NSMutableArray alloc]init];
    _deleteArray=[[NSMutableArray alloc]init];
    _rootViewController=[RootViewController sharedInstance];
    _dbManager=[MusicListingDBManager sharedManager];
    self.detailedListView=[DetailedListView sharedInstance];
    _addListArray=[[NSMutableArray alloc]init];
    _myDetaliedMusicArray=[[NSMutableArray alloc]init];
    [self createUI];
    MusicListingDBManager *dbmanager=[MusicListingDBManager sharedManager];
    dbmanager.delegate =self;
    
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    self.myMusicListView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30,507-64-44-5) style:(UITableViewStylePlain)];
    self.myMusicListView.delegate=self;
    self.myMusicListView.dataSource=self;
    self.myMusicListView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    self.myMusicListView.separatorColor=[UIColor clearColor];
    UIView *view=[[UIView alloc]init];
    self.myMusicListView.tableFooterView=view;
    [self.view addSubview:self.myMusicListView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.titleName isEqualToString:@"我的收藏"])
    {
        return self.myMusicListArray.count;
    }
    return self.myDetaliedMusicArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark 选择cell的方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedListViewCell *cell = (DetailedListViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *str1=[NSString stringWithFormat:@"%@",cell.musicTitleLabel.text];
    NSString *musicList= [str1 substringFromIndex:0];//这里需要把添加的空格裁剪掉
    
    if (_myMusicListView.editing)
    {//        只有在编辑状态，则把删除的数据放进删除数据的数组
        
        [_addListArray addObject:[_myDetaliedMusicArray objectAtIndex:indexPath.row]];
        if (_addListArray.count>0)
        {
            _editListButton.userInteractionEnabled = YES;
            _editListButton.tintColor=[UIColor blackColor];
            NSLog(@"准备添加进列表的数组的个数为%lu",(unsigned long)_addListArray.count);
            
        }
        else if(_addListArray.count==0)
        {
            _editListButton.userInteractionEnabled = NO;
            _editListButton.tintColor=[UIColor grayColor];
            NSLog(@"防止空数组出现");
        }
    }
    else if(!_myMusicListView.editing)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.titleName isEqualToString:@"我的收藏"])
        {
            if ([_detailedListView.nowPlayMusicList isEqualToString:@""])
            {
                
            }
            else if([self.IamPlaying isEqualToString:musicList])
            {
                [_detailedListView muiscListIschangeClearPlayingMarkOrNot:@"NO"];

            }
            else if(![self.IamPlaying isEqualToString:musicList])
            {
                //             列表不同
                [_detailedListView muiscListIschangeClearPlayingMarkOrNot:@"YES"];

            }
            _detailedListView.nowPlayMusicList=musicList;
            [self loadDataWhitMusicList:musicList];
            
            
            if (_musicArray.count==0)
            {
                [_rootViewController misoperationPass:@"列表为空"];
            }else
            {
                [_rootViewController toDetailedListView];
            }
        }
        else if([self.titleName isEqualToString:@"我的下载"])
        {
            
            /**
             *  暴露再外的播放接口
             *
             *  @param urlIndex         电台下标
             *  @param urlArray         本地播放列表数组
             *  @param playIndex        本地列表的播放下标
             *  @param listMark         列表标志
             *  @param listName         列表名
             *  @param detailedPlayName 防重复播放的标志
             */
            MusicBox *musicBox=[MusicBox sharedInstance];
            musicBox.detaliedListView=NO;
            [musicBox musicBoxWillPlayWith:(int)nil orUrlArray:_myDetaliedMusicArray andPlayIndex:(int)indexPath.row andlistMark:@"DETALIEDLIST" andListName:nil andDetailedPlayName:(int)indexPath.row andLocalizeListName:musicList];
            [self.delegate PlayAllDetaliedMusicListDelegatePassMark:@"YES"];
            [_detailedListView clocePlayingMark];
        }
    }
}
#pragma mark 删除系列
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _editView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, 375-40, 30)];
    _editView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.9];
    [self makeTitleLabel];
    
        if ([self.titleName isEqualToString:@"我的下载"])
    {
        _editListButton=[MyButtonShop createButtonWithFrame:CGRectMake(255, 5,80, 30) andTitle:@"添加进列表" andImage:nil andBgImage:nil andSelecter:@selector(editLocalizeMusicList) andTarget:self];
        [_editListButton setTitle:@"添加" forState:(UIControlStateSelected)];
        _editListButton.titleLabel.textAlignment=NSTextAlignmentRight;
        _editListButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        _editListButton.tintColor=[UIColor blackColor];

        [_editView addSubview:_editListButton];
        
    }
    else{
           [_editListButton removeFromSuperview];
        }
    return _editView;
    
}
-(void)makeTitleLabel
{
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.text=_titleName;
    _titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [_editView addSubview:_titleLabel];
    //有他没我有我没他
    [_cancelButton removeFromSuperview];
}
#pragma mark 创建取消键
-(void)makeCancelButton
{
    _cancelButton=[MyButtonShop createButtonWithFrame:CGRectMake(20, 5, 40, 30) andTitle:@"取消" andImage:nil andBgImage:nil andSelecter:@selector(cancelEditMusicList) andTarget:self];
    _cancelButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    _cancelButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [_editView addSubview:_cancelButton];
    //有他没我有我没他
    [_titleLabel removeFromSuperview];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选方法（要区分选中它的效果，和反选他的效果）
    //将之前选择过的再移出要删除的数组数组
    NSLog(@"小贱人居然反选");
    if ([self.title isEqualToString:@"我的收藏"]) {
   
    [_addListArray removeObject:[_myMusicListArray objectAtIndex:indexPath.row]];
       }
    else if([self.title isEqualToString:@"我的下载"])
    {
    [_addListArray removeObject:[_myDetaliedMusicArray objectAtIndex:indexPath.row]];
     }
    NSLog(@"从addListArray中移除后剩下的数组条目为%lu",(unsigned long)_addListArray.count);

    if (_addListArray.count==0)
    {
        _editListButton.userInteractionEnabled=NO;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_editListButton.selected==YES)
    {
        return;
    }
    else
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([_titleName isEqualToString:@"我的收藏"])
        {
        //删除对应数据源的数组
            [self loadDataWhitMusicList:[_myMusicListArray objectAtIndex:indexPath.row]];
            for (int i=0; i<_musicArray.count; i++)
            {
                dataModel *model=_musicArray[i];
                if (model.localizemusic.length>2)
                {

                        [_rootViewController isDeleteMusicListWithMyMusicListORNotWithMusicListName:[_myMusicListArray objectAtIndex:indexPath.row]];
                    
                }else
                {
                    [_dbManager deleteMusiclitWithListName:[_myMusicListArray objectAtIndex:indexPath.row]];

                    
                }
            }
            
        }  else if([_titleName isEqualToString:@"我的下载"])
        {
            dataModel *model=[_myDetaliedMusicArray objectAtIndex:indexPath.row];
            NSLog(@"歌名%@和列表%@",model.title,model.playList);
            NSArray *delete=@[model];
            FileOperateManager *fileManager=[[FileOperateManager alloc]init];
            NSLog(@"%@",delete);
            [fileManager deleteLocalizeDataWith:delete];
            [_dbManager deleteMusiclitWithListNameArray:delete];

//            if (model.playList.length>3)
//            {
//               [_rootViewController isDeleteLocalizeWithListORNotWithModel:model];
//            }
        }
        if ([self.title isEqualToString:@"我的收藏"])
        {
            [_myMusicListArray removeObjectAtIndex:indexPath.row];
            
            //删除对应的cell
        }
        else if([self.title isEqualToString:@"我的下载"])
        {
            [_myDetaliedMusicArray removeObjectAtIndex:indexPath.row];
            
            //删除对应的cell
        }
        //[NSArray arrayWithObject:indexPath]  找到删掉的那行cell
        //第二个参数是动画效果
        [_myMusicListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        }
    }
    
}
#pragma mark 添加进列表键的方法
static int i=1;
-(void)editLocalizeMusicList
{
    ListingViewController *listView=[ListingViewController sharedInstance];

    if (i==1)
    {
        _editListButton.selected=YES;
        [self.myMusicListView setEditing:YES animated:YES];
        _rootViewController.MyMusicListViewIsEdit=@"MyMusicListViewIsNotEdit";
        listView.MyMusicListViewIsEdit=@"MyMusicListViewIsNotEdit";
        
        listView.localizeMusicList =_addListArray;
        [_titleLabel removeFromSuperview];//将表头隐藏
        [self makeCancelButton];
        i=0;
        _editListButton.userInteractionEnabled = NO;
    }else if(i==0)
    {
        _rootViewController.MyMusicListViewIsEdit=@"MyMusicListViewIsEdit";
        listView.MyMusicListViewIsEdit=@"MyMusicListViewIsEdit";

        [_rootViewController addListingOpen];
        //        传入参数从数据库删除数据
        //        这里应该做出删除，键值变成删除
        if (!self.myMusicListView.editing)
        {
            [self makeTitleLabel];

        }
        i=1;
        _editListButton.userInteractionEnabled = YES;

    }
    
}
#pragma mark 取消键的方法
- (void)cancelEditMusicList
{
    [self.myMusicListView setEditing:NO animated:YES];
    _editListButton.selected=NO;
    [self makeTitleLabel];
    [_rootViewController addListingCloce];
    [_addListArray removeAllObjects];
    _editListButton.userInteractionEnabled = YES;
    i=1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailedListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"musiclist"];
    
    if (cell==nil)
    {
        cell=[[DetailedListViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"musiclist"];
    }
    if ([_titleName isEqualToString:@"我的收藏"])
    {
        cell.musicTitleLabel.text=[NSString stringWithFormat:@"%@",_myMusicListArray[indexPath.row]];
        cell.subTitleLabel.text=nil;
        return cell;

    }
    else if([_titleName isEqualToString:@"我的下载"])
    {
        dataModel *model=_myDetaliedMusicArray[indexPath.row];
        cell.musicTitleLabel.text=[NSString stringWithFormat:@"%@",model.title];
        cell.subTitleLabel.text=[NSString stringWithFormat:@"%@",model.artist];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_editListButton.selected==YES)
    {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 新的读取本地列表
-(void)newShowMusicList
{
    NSLog(@"%lu,列表的个数为",(unsigned long)_myMusicListArray.count);
    NSLog(@"%lu,本地播放文件的个数为",_myDetaliedMusicArray.count);
    if ([self.titleName isEqualToString:@"我的收藏"])
    {
        _myMusicListArray=[_dbManager queryMusicList];
    }
    NSLog(@"我的收藏返回的数组个数%lu",(unsigned long)_myMusicListArray.count);
    [self.myMusicListView reloadData];
}
#pragma mark 新的读取已下载歌曲清单
-(void)newShowLocalizeMusicName
{

    if ([self.titleName isEqualToString:@"我的下载"])
    {
        _myDetaliedMusicArray=[_dbManager queryLocalizeMusicList];
    }
    NSLog(@"%@dsakldsajdnsakndasnkdnsa",_myDetaliedMusicArray);
    [self.myMusicListView reloadData];
}
#pragma mark 通过选中列表名选择出当前歌单的方法
-(void)loadDataWhitMusicList:(NSString *)musicList
{
   _musicArray=[_dbManager newQueryMusicListWithListName:musicList];
    NSLog(@"响应歌单的内的曲目个数为%lu",_musicArray.count);
    [_detailedListView relondDataWithMusicListArray:_musicArray];
}

#pragma mark 数据库回调
-(void)saveInformationSucceed
{
    NSLog(@"数据库再MyMusicListView中的回调");
    _editListButton.selected=NO;
    [self.myMusicListView setEditing:!self.myMusicListView.editing animated:YES];
    
    i=1;
    [_addListArray removeAllObjects];
    [self newShowLocalizeMusicName];
}
#pragma mark 播放列表变化方法
-(void)listNameisChange:(NSString *)listName
{
    self.titleName=listName;
    i=1;
    if (self.myMusicListView.editing)
    {
        [self.myMusicListView setEditing:!self.myMusicListView.editing animated:YES];
    }
    if ([_titleName isEqualToString:@"我的下载"])
    {
        for (int i=0; i<_myMusicListArray.count; i++)
        {
            
            NSIndexPath *xxx=[NSIndexPath indexPathForRow:i inSection:0];
            DetailedListViewCell *cell = (DetailedListViewCell *)[self.myMusicListView cellForRowAtIndexPath:xxx];
            [cell hideRank];
            [_detailedListView muiscListIschangeClearPlayingMarkOrNot:@""];
            
        }
    }


}
#pragma mark 显示正在播放的mark的方法
-(void)makeMarkWithNowPlayingList:(NSString *)nowPlayingList
{
  
    
    for (int i=0; i<_myMusicListArray.count; i++)
    {
        
        if ([_myMusicListArray[i] isEqualToString:nowPlayingList])
        {
            NSIndexPath *xxx=[NSIndexPath indexPathForRow:i inSection:0];
            DetailedListViewCell *cell = (DetailedListViewCell *)[self.myMusicListView cellForRowAtIndexPath:xxx];
                        [cell showRank];
        }else
        {
            DetailedListViewCell *allCell = (DetailedListViewCell *)[self.myMusicListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [allCell hideRank];
        }
        
    }
}
#pragma mark 关闭显示下标方法
-(void)clocePlayingMark
{
    if (_myMusicListArray.count)
    {
        for (int i = 0; i < _myMusicListArray.count; i++)
        {
            //防止复用，先关闭之前的图标
            DetailedListViewCell *allCell = (DetailedListViewCell *)[self.myMusicListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [allCell hideRank];
        }
        [self.myMusicListView reloadData];

    }
}
#pragma mark 单例创建
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static MyMusicListView *myMusicListView = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        myMusicListView = [[self alloc] initPrivate];
    });
    return myMusicListView;
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
