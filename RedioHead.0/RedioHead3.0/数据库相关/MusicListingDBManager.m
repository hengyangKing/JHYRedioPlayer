//
//  MusicListingDBManager.m
//  RedioHead3.0
//
//  Created by J on 15/8/15.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MusicListingDBManager.h"
#import "FMDatabase.h"
#import "JHYMD5CodeTool.h"
#import "MusicBox.h"
#import "PassMusicInformation.h"
#import "RootViewController.h"
#import "DetailedListView.h"
#import "MyMusicListView.h"

static MusicListingDBManager *music_Manager = nil;
@interface MusicListingDBManager ()
@property(nonatomic,strong)FMDatabase *dataBase;
@property(nonatomic,strong)NSString *createStr;
@property(nonatomic,strong)dataModel *dataModel;
@property(nonatomic,strong)NSString *inviteeMusicName;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)RootViewController *rooVc;
@property(nonatomic,strong)NSMutableArray *listNameArray;
@property(nonatomic,strong)NSMutableArray *cupListNameArray;
@property(nonatomic,strong)NSMutableArray *cupMusicNameArray;
@end
@implementation MusicListingDBManager
#pragma mark 单例创建
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
}

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (music_Manager == nil) {
            music_Manager = [[MusicListingDBManager alloc] initPrivate];
        }
    });
    return music_Manager;
}
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }
    self.listNameArray=[[NSMutableArray alloc]init];
    self.cupListNameArray=[[NSMutableArray alloc]init];
    self.cupMusicNameArray=[[NSMutableArray alloc]init];
    return self;
}

#pragma mark 打开列表并查询数据的方法
-(NSMutableArray *)queryMusicListWithListName:(NSString *)listName
{
    self.dataArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/%@.db",NSHomeDirectory(),listName];
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    if ([_dataBase open])
    {
        NSLog(@"难道是你有问题？");
        _createStr = @"create table if not exists musicList (artist,title,picture,url,localizemusic);";
        
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        
        NSString *sql=[NSString stringWithFormat:@"select * from musicList"];

        FMResultSet *rs = [_dataBase executeQuery:sql];
        while ([rs next])
        {
            dataModel *model=[[dataModel alloc]init];
            model.artist = [rs stringForColumn:@"artist"];
            model.title = [rs stringForColumn:@"title"];
            model.picture=[rs stringForColumn:@"picture"];
            model.url=[rs stringForColumn:@"url"];
            model.localizemusic=[rs stringForColumn:@"localizemusic"];
            [self.dataArray addObject:model];
        }
    }
    NSLog(@"当前歌单中歌曲数为:%lu",(unsigned long)self.dataArray.count);
    return self.dataArray;
}
- (BOOL)isDataExistByNowPlayMusic:(NSString *)listName
{
    NSString *setstr=[NSString stringWithFormat:@"select * from musicList where (artist=?,title=?,picture=?,url=?,localizemusic=?,playList=?)"];
    FMResultSet *set = [_dataBase executeQuery:setstr,self.dataModel.artist,self.dataModel.title,self.dataModel.picture,self.dataModel.url,self.dataModel.localizemusic,listName];
    if ([set next]) {
        // 如果数据库 表里面存在
        NSLog(@"这首歌已经存在");

        return YES;
    }
    else
    {
        NSLog(@"这首歌不存在");
        return NO;
    }
}
-(void)passNowPlatMusic:(dataModel *)dataModel
{
    
    self.dataModel=dataModel;
}
#pragma mark 新的方案向列表里插入新元素的方法
-(void)createNewMusicListWithListName:(NSString *)listName andLocalizemusic:(NSString *)localizemusic
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        if (![self isDataExistByNowPlayMusic:listName])
        {
            NSString *add=@"insert into musicList (artist,title,picture,url,localizemusic,playList) values (?,?,?,?,?,?)";
            
            if ([self.dataBase executeUpdate:add,self.dataModel.artist,self.dataModel.title,self.dataModel.picture,self.dataModel.url,localizemusic,listName])//将流派添加进表单后面
            {
                if (localizemusic.length<3)
                {
                    NSLog(@"添加成功");
                    [self.delegate saveInformationSucceed];
                }
            }
        }else
        {
            [_rooVc misoperationPass:@"这首歌已经存在于列表中"];
        }
    }
 
}
#pragma mark 专门针对本地文件数组添加进已有列表的方法
-(void)addLocalizeMusicListWithListName:(NSString *)listName andDataArray:(dataModel *)model;
{
    NSLog(@"传进来的模型为%@",model);
        NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
        _dataBase = [FMDatabase databaseWithPath:dbPath];
        if ([_dataBase open])
        {
            _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
        }
        BOOL isSuc = [_dataBase executeUpdate:_createStr];
        if (isSuc)
        {
            NSLog(@"创建或打开成功");
            if (![self isDataExistByNowPlayMusic:listName])
            {
                NSString *add=@"insert into musicList (artist,title,picture,url,localizemusic,playList) values (?,?,?,?,?,?);";
                
                if ([self.dataBase executeUpdate:add,model.artist,model.title,model.picture,model.url,[self makeMarkWithArtist:model.artist andAlbumtitle:model.title],listName])//将流派添加进表单后面
                {
                    NSLog(@"本地列表添加成功");
                    [self.delegate saveInformationSucceed];
                }
                else
                {
                    NSLog(@"本地列表添加失败");
                }
             }else
             {
                 NSLog(@"这首歌已经收录在当前列表中");
             }
         }
}

#pragma mark 查询列表名方法
-(NSMutableArray *)queryMusicList
{
    [self.cupListNameArray removeAllObjects];
    [self.listNameArray removeAllObjects];
    NSLog(@"当前的列表数组内的元素个数%lu",(unsigned long)self.cupListNameArray.count);
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        NSString *querySql=@"select playList from musicList;";
        FMResultSet *rs = [_dataBase executeQuery:querySql];
        while ([rs next])
        {
            NSString *listNameStr = [rs stringForColumn:@"playList"];
            [self.listNameArray addObject:listNameStr];
        }
        NSLog(@"枚举出的列表内元素的个数为%lu",(unsigned long)self.listNameArray.count);
        for ( int i=0; i<self.listNameArray.count; i++)
        {
            for (int j=i+1; j<self.listNameArray.count; j++)
            {
                NSString *str1=self.listNameArray[i];
                NSString *str2=self.listNameArray[j];
                NSComparisonResult result=[ str1 compare:str2];
                if (result >0)
                {
                    [self.listNameArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
                
            }
        }
        NSLog(@"排序后的元素个数%lu",(unsigned long)self.listNameArray.count);
        NSString *cupListName=@"dksnandsan";
        for (int i=0; i<self.listNameArray.count; i++)
        {
               if(![self.listNameArray[i] isEqualToString:cupListName]&&![self.listNameArray[i] isEqualToString:@""])
            {
                //杜绝了重名和空列表
                NSString *foo=self.listNameArray[i];
                [self.cupListNameArray addObject:foo];
                cupListName=self.listNameArray[i];
            }
        }
       }
    NSLog(@"传出去的列表数目为%lu",(unsigned long)self.cupListNameArray.count);
    return self.cupListNameArray;
}
/**
 *  通过选择响应的列表关键字，返回所有带有关键字的模型数组
 *
 */
-(NSMutableArray *)newQueryMusicListWithListName:(NSString *)listName
{
    self.dataArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        NSString *querySql=@"select artist,title,picture,url,localizemusic from musicList where playList=?;";
        FMResultSet *rs = [_dataBase executeQuery:querySql,listName];
        while ([rs next])
        {
            dataModel *model=[[dataModel alloc]init];
            model.artist = [rs stringForColumn:@"artist"];
            model.title = [rs stringForColumn:@"title"];
            model.picture=[rs stringForColumn:@"picture"];
            model.url=[rs stringForColumn:@"url"];
            model.localizemusic=[rs stringForColumn:@"localizemusic"];
            [self.dataArray addObject:model];
        }
    }
    return self.dataArray;
}
#pragma mark 通过列表名删除整个的方法
-(void)deleteMusiclitWithListName:(NSString *)listName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"删除列表时创建或打开成功");
        NSString *deletesql=[NSString stringWithFormat:@"delete from musicList where playList=?;"];
        if ([self.dataBase executeUpdate:deletesql,listName])
        {
            NSLog(@"删除成功");
            [_rooVc misoperationPass:@"删除列表成功"];
        }
    }
}
/**
 *  通过url删除数据
 *
 */
-(void)deleteMusiclitWithListNameArray:(NSArray *)deleteMusicListName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"删除文件时创建或打开成功");
        for (int i=0; i<deleteMusicListName.count; i++)
        {
            dataModel *model=deleteMusicListName[i];
            NSString *deletesql=[NSString stringWithFormat:@"delete from musicList where url=?;"];
            if ([self.dataBase executeUpdate:deletesql,model.url])
            {
                NSLog(@"删除成功");
                NSArray *deleteArrrrrrr=@[deleteMusicListName[i]];
                [_rooVc misoperationPass:@"删除成功"];
                DetailedListView *detailedListView=[DetailedListView sharedInstance];
                [detailedListView deleteInformationSucceedYouMustRemoveData:deleteArrrrrrr];
            }
        }
    }

}
/**
 *  查询所有已下载的歌曲
 */
#pragma mark 查询所有已下载歌曲
-(NSMutableArray *)queryLocalizeMusicList
{
    NSLog(@"读取已下载歌曲前数组内的数%lu",(unsigned long)self.cupMusicNameArray.count);
    [self.cupMusicNameArray removeAllObjects];
    [self.listNameArray removeAllObjects];
    self.dataArray=[[NSMutableArray alloc]init];
    NSLog(@"读取已下载歌曲清除数组内的数%lu",self.cupMusicNameArray.count);
//    NSLog(@"传来本地列表数组内的元素个数%lu",localizeArray.count);
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");

            NSString *querySql=@"select * from musicList";
           FMResultSet *rs = [_dataBase executeQuery:querySql];
        while ([rs next])
        {
            dataModel *model=[[dataModel alloc]init];
            model.artist = [rs stringForColumn:@"artist"];
            model.title = [rs stringForColumn:@"title"];
            model.picture=[rs stringForColumn:@"picture"];
            model.url=[rs stringForColumn:@"url"];
            model.localizemusic=[rs stringForColumn:@"localizemusic"];
            model.playList=[rs stringForColumn:@"playList"];
            [self.dataArray addObject:model];
        }
        for (int i=0; i<self.dataArray.count; i++)
     {
      
         dataModel *model=self.dataArray[i];
        if (model.localizemusic.length>2)
        {
            [self.listNameArray addObject:model];
        }
     }
        for ( int i=0; i<self.listNameArray.count; i++)
        {
            for (int j=i+1; j<self.listNameArray.count; j++)
            {
                dataModel *model1=self.listNameArray[i];
                dataModel *model2=self.listNameArray[j];
                NSComparisonResult result=[ model1.title compare:model2.title];
                if (result >0)
                {
                    [self.listNameArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
                
            }
        }
        NSString *cupListName=@"dksdadasdkasnandsan";
        for (int i=0; i<self.listNameArray.count; i++)
        {
            dataModel *model=self.listNameArray[i];
            if(![model.title isEqualToString:cupListName])
            {
                //杜绝了重名和空列表
                NSString *foo=self.listNameArray[i];
                [self.cupMusicNameArray addObject:foo];
                cupListName=model.title;
            }
        }
    }
    NSLog(@"这简直是伤不起啊伤不起%lu",(unsigned long)self.cupMusicNameArray.count);
    return self.cupMusicNameArray;
}
#pragma mark 将音乐列表设为空的方法
-(void)changeMusicLictWithArray:(NSArray *)deleteArray
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        for (int i=0; i<deleteArray.count; i++)
        {
            dataModel *model=deleteArray[i];
            NSString *deleteSql=@"update musicList set playList=? where url=?;";
            if ([self.dataBase executeUpdate:deleteSql,@"",model.url])
            {
                NSLog(@"删除成功");
                NSArray *deleteArrrrrrr=@[deleteArray[i]];
                [_rooVc misoperationPass:@"删除成功"];
                DetailedListView *detailedListView=[DetailedListView sharedInstance];
                [detailedListView deleteInformationSucceedYouMustRemoveData:deleteArrrrrrr];
            }
            
        }

    }

}
#pragma mark 将是否下载设为空的方法
-(void)changeMusicFileIsLocalizeMusicOrNotWithArray:(NSArray *)deleteArray
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");
        for (int i=0; i<deleteArray.count; i++)
        {
            dataModel *model=deleteArray[i];
            NSString *deleteSql=@"update musicList set localizemusic=? where url=?;";
            if ([self.dataBase executeUpdate:deleteSql,@"1",model.url])
            {
                 NSLog(@"修改列表成功，本地文件删除");
                [_rooVc misoperationPass:@"删除成功"];
            }
            
        }
        
    }

}
#pragma mark 设为已下载的方法
-(void)makeMusicFileIsLocalizeMusicWithDataModel:(dataModel *)model
{
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/播放列表.db",NSHomeDirectory()];
    _dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([_dataBase open])
    {
        _createStr= @"create table if not exists musicList (artist,title,picture,url,localizemusic,playList);";
    }
    BOOL isSuc = [_dataBase executeUpdate:_createStr];
    if (isSuc)
    {
        NSLog(@"创建或打开成功");

            NSString *deleteSql=@"update musicList set localizemusic=? where url=?;";
            if ([self.dataBase executeUpdate:deleteSql,[self makeMarkWithArtist:model.artist andAlbumtitle:model.title],model.url])
            {
                NSLog(@"修改列表成功，将其变成已下载");
                DetailedListView *detailedListView=[DetailedListView sharedInstance];
                [detailedListView misoperationPass:@"下载成功"];
            }
    }
    
}
-(NSString *)makeMarkWithArtist:(NSString *)artist andAlbumtitle:(NSString *)albumtitle
    {
        NSString *str=[NSString stringWithFormat:@"%@%@",artist,albumtitle];
        return [JHYMD5CodeTool MD5StringFromString:str];
    }
//-(void)downlondPlayingMusicPath:(NSString *)muiscPathName;
//{
//    self.dataModel.localizemusic=muiscPathName;
//}


@end
