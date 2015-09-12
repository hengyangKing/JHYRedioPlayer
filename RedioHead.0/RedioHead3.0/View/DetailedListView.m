//
//  DetailedListView.m
//  RedioHead3.0
//
//  Created by J on 15/8/18.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "DetailedListView.h"
#import "MyTableViewCell.h"
#import "MyMusicListView.h"
#import "RootViewController.h"
#import "MusicBox.h"
#import "MyButtonShop.h"
#import "dataModel.h"
#import "DetailedListViewCell.h"
#import "MusicListingDBManager.h"
#import "JHYMD5CodeTool.h"
#import "FileOperateManager.h"
#import "DownLondMusicAndSave.h"

@interface DetailedListView ()<UITableViewDataSource,UITableViewDelegate,DownLondMusicSucceed>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *editView;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)NSMutableArray *musicArray;
@property(nonatomic,strong)NSMutableArray *deleteArray;
@property(nonatomic,strong)RootViewController *rootViewController;
@property(nonatomic,strong)MusicListingDBManager *dbManager;
@property(nonatomic,strong)MyMusicListView *myMusicListView;
@property(nonatomic,assign)NSInteger NowIndexPath;

@end

@implementation DetailedListView

- (void)viewDidLoad {
    [super viewDidLoad];
    _musicArray=[[NSMutableArray alloc]init];
    _deleteArray=[[NSMutableArray alloc]init];
    _rootViewController=[RootViewController sharedInstance];
    _dbManager=[MusicListingDBManager sharedManager];
    _myMusicListView=[MyMusicListView sharedInstance];
    self.nowPlayMusicList=@"";
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, self.view.frame.size.height - 110) style:(UITableViewStylePlain)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorColor=[UIColor clearColor];
    UIView *view=[[UIView alloc]init];
    self.tableView.tableFooterView=view;
    [self.view addSubview:self.tableView];
    

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return self.musicArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _editView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, 375-40, 30)];
    _editView .backgroundColor=[UIColor whiteColor];
    
    _backButton=[MyButtonShop createButtonWithFrame:CGRectMake(0, 3, 12, 24) andTitle:nil andImage:nil andBgImage:[UIImage imageNamed:@"cm2_act_icn_arrback@3x"] andSelecter:@selector(backButtonClick) andTarget:self];
    [_editView addSubview:_backButton];
    
    _editButton=[MyButtonShop createButtonWithFrame:CGRectMake(295, 0,40, 30) andTitle:@"编辑" andImage:nil andBgImage:nil andSelecter:@selector(editMusicList) andTarget:self];
    [_editButton setTitle:@"删除" forState:(UIControlStateSelected)];
    _editButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    _editButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [_editView addSubview:_editButton];
    
    return _editView;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *iden = @"musicList";
    DetailedListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell)
    {
        cell=[[DetailedListViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:iden];
    }
    NSLog(@"当前歌单中有%lu首歌",(unsigned long)_musicArray.count);
    dataModel *model=_musicArray[indexPath.row];
    [cell isDownloadWithModel:model];
    
    cell.musicTitleLabel.text=model.title;
    cell.subTitleLabel.text=model.artist;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tableView.editing)
    {//        只有在编辑状态，则把删除的数据放进删除数据的数组
        [_deleteArray addObject:[self.musicArray objectAtIndex:indexPath.row]];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //将列表数组内容全部传本地播放器，再播放器内判断若是本地已有的音乐则调取本地数据，若是没有就流媒体加载
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
        musicBox.detaliedListView=YES;
        [musicBox musicBoxWillPlayWith:(int)nil orUrlArray:self.musicArray andPlayIndex:(int)indexPath.row andlistMark:@"DETALIEDLIST" andListName:nil andDetailedPlayName:(int)indexPath.row andLocalizeListName:self.nowPlayMusicList];

        [self.delegate passNowPlayMusicListName:self.nowPlayMusicList];
        _myMusicListView.IamPlaying=self.nowPlayMusicList;
        [_myMusicListView makeMarkWithNowPlayingList:self.nowPlayMusicList];
        [self.delegate PlayDetaliedMusicListDelegatePassMark:@"YES"];
        
    //打包发送数据给播放器，
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选方法（要区分选中它的效果，和反选他的效果）
    //将之前选择过的再移出要删除的数组数组
    NSLog(@"小贱人居然反选");
    [_deleteArray removeObject:[_musicArray objectAtIndex:indexPath.row]];
    
}
#pragma mark 从数据库读取数据
-(void)relondDataWithMusicListArray:(NSMutableArray *)musicArray
{
    self.musicArray=musicArray;
    NSLog(@"这个列表中的数据个数为%lu",(unsigned long)musicArray.count);
    [_tableView reloadData];
}
-(void)backButtonClick
{

    [_rootViewController toMyZoom];
    [self.tableView setEditing:NO animated:YES];
}
static int i=1;
#pragma mark 编辑键方法
-(void)editMusicList
{
    if (i==1) {
//      现在需变成勾选状态 键值变为完成
        _editButton.selected=!_editButton.selected;
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        i=0;
    }else if(i==0)
    {
//        传入参数从数据库删除数据 
//        这里应该做出删除，键值变成删除
        //先判断是否有本地文件
        NSMutableArray *cupArray=[[NSMutableArray alloc]init];
        for (int i=0; i<_deleteArray.count; i++)
        {
            dataModel *model=_deleteArray[i];
            if (model.localizemusic.length>3)
            {
                [cupArray addObject:model];
                //先将带有本地文件的条目装进数组
            }
        }
        if (cupArray.count==0)
        {
            //不提示直接删除
            //他没有下载本地歌曲，这时需要移出列表则是需要彻底的删除条目
        [_dbManager deleteMusiclitWithListNameArray:_deleteArray];

        }
        else if(cupArray.count==1)
        {
        //提示有1首本地歌曲是否删除
        [self deleteLocalizeMusicFile:cupArray andMessage:@"是否删除本地音乐文件"];
        
        }
        else if(cupArray.count>1)
        {
            //有多首本地歌曲需要删除
            [self deleteLocalizeMusicFile:cupArray andMessage:@"是否删除多个本地文件"];
        }
        [_musicArray removeObjectsInArray:_deleteArray];
        [self.tableView reloadData];
        _editButton.selected=!_editButton.selected;
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        i=1;
    }
}
#pragma mark 将选中数据删除的方法
/**删除成功后的回调*/
-(void)deleteInformationSucceedYouMustRemoveData:(NSArray *)deleteDataArray
{
    
    if (_musicArray.count!=1)
    {
        [_musicArray removeObjectsInArray:deleteDataArray];

    }
    else if(_musicArray.count)
    [_tableView reloadData];
    if (_musicArray.count==0)
    {
        [_rootViewController toMyZoom];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_editButton.selected==YES)
    {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"下载";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{
    
}
#pragma mark ios8定义的新方法做cell的多键操作
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
       UITableViewRowAction *downlondRowMusicAction=[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"下载" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
           dataModel *model=_musicArray[indexPath.row];
           if (model.localizemusic.length>3)
           {
               [self misoperationPass:@"这首歌已下载"];
           }else if(model.localizemusic.length<3)
           {
               DownLondMusicAndSave *downLoneManager=[DownLondMusicAndSave sharedInstance];
               downLoneManager.delegate=self;
               [downLoneManager downloadMusicFileWithDataModel:model andFileNameIs:[JHYMD5CodeTool MD5StringFromString:[NSString stringWithFormat:@"%@%@",model.artist,model.title]]];
               
               
           }
       }];
    dataModel *model=_musicArray[indexPath.row];
    if (model.localizemusic.length>3)
    {
        downlondRowMusicAction.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
        downlondRowMusicAction.title=@"已下载";
        
    }else if(model.localizemusic.length<3)
    {
        downlondRowMusicAction.backgroundColor=[UIColor colorWithWhite:0.65 alpha:1];

    }
    NSArray *arr=@[downlondRowMusicAction];
    return arr;
}
#pragma mark 下载成功的回调
-(void)DownLondMusicSucceed:(dataModel *)model
{
    
    [_dbManager makeMusicFileIsLocalizeMusicWithDataModel:model];
    [_myMusicListView loadDataWhitMusicList:self.nowPlayMusicList];
    [_myMusicListView newShowLocalizeMusicName];

}
#pragma mark 万用模态对话框
-(void)misoperationPass:(NSString *)note
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: nil message:[NSString stringWithFormat:@"%@",note]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 以模态方式显示警告视图控制器
    [self presentViewController:alertController animated:YES
                     completion:^{
                         
                         
                     }];

}
#pragma mark 选择是否删除本地文件方法
-(void)deleteLocalizeMusicFile:(NSArray*)deleteArray andMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        FileOperateManager *fileManager=[[FileOperateManager alloc]init];
        [fileManager deleteLocalizeDataWith:deleteArray];
        
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"保留" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        //        只有下载过的音乐才调用这个方法，只将音乐从歌单中抹去，保留其播放信息
        [_dbManager changeMusicLictWithArray:_deleteArray];
        
    }];
    
}
#pragma mark 开启示意图标的方法
-(void)playerIsChangeWith:(int)indexPath
{
    //这里需要对列表名进行判断，如果变换列表那么需要将正在播放标志清空

//    self.NowIndexPath=[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:indexPath]];
    self.NowIndexPath=indexPath;
    
        //第一次
        for (int i = 0; i < _musicArray.count; i++)
        {
            //防止复用，先关闭之前的图标
            DetailedListViewCell *allCell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [allCell hideRank];
        }
        //        再开启新的图标
        NSIndexPath *xxx=[NSIndexPath indexPathForRow:self.NowIndexPath inSection:0];
        DetailedListViewCell *cell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:xxx];
        [cell showRank];
    

}
#pragma mark 打开了新列表清空当前播放示意
-(void)muiscListIschangeClearPlayingMarkOrNot:(NSString *)change
{
  
    for (int i = 0; i < _musicArray.count; i++)
    {
        //防止复用，先关闭之前的图标
        DetailedListViewCell *allCell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [allCell hideRank];
    }
    
    if ([change isEqualToString:@"YES"])
    {
      return;

    }
    else if([change isEqualToString:@"NO"])
    {
        NSIndexPath *xxx=[NSIndexPath indexPathForRow:self.NowIndexPath inSection:0];
        DetailedListViewCell *cell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:xxx];
        [cell showRank];
    }

}
-(void)clocePlayingMark
{
    self.NowIndexPath=-1;
    for (int i = 0; i < _musicArray.count; i++)
    {
        //防止复用，先关闭之前的图标
        DetailedListViewCell *allCell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [allCell hideRank];
    }
    [self.tableView reloadData];
}
#pragma mark 播放页面做出删除后对当前列表进行判断
-(void)deleteNowPlayMusicJudgeList
{
    if (_musicArray.count==0)
    {
//        for (int i = 0; i < _musicArray.count; i++)
//        {
            //防止复用，先关闭之前的图标
            DetailedListViewCell *allCell = (DetailedListViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [allCell hideRank];
        
//        }
        [self backButtonClick];
        
        
    }
}
#pragma mark 单例创建方法
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
    
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static DetailedListView *detailedListView = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        detailedListView = [[self alloc] initPrivate];
    });
    return detailedListView;
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
