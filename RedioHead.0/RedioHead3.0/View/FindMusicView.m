//
//  FindMusicView.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "FindMusicView.h"
#import "MyTableViewCell.h"
#import "MusicBox.h"
#import"RootViewController.h"
#import "AFNetworking.h"
#import "FmDataModel.h"
#import "UITableView+isSelete.h"

#define DOUBANFMLIST @"http://www.douban.com/j/app/radio/channels"

@interface FindMusicView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *parameterArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RootViewController *rootVC;
@property(strong,nonatomic)NSIndexPath *lastSelected;
@end

@implementation FindMusicView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.parameterArray=[[NSMutableArray alloc]init];
    self.FMLISTArray=[[NSMutableArray alloc]init];
    [self createUI];
    [self downlondDataWithUrl:DOUBANFMLIST];
    _rootVC=[RootViewController sharedInstance];

//    _titleArray=@[@"华语 MHz",@"欧美 MHz",@"七零 MHz",@"八零 MHz",@"九零 MHz",@"粤语 MHz",@"摇滚 MHz",@"民谣 MHz",@"轻音乐 MHz",@"电影原声 MHz",@"爵士 MHz",@"电子 MHz",@"说唱 MHz",@"R&B MHz",@"日语 MHz",@"韩语 MHz",@"女声 MHz",@"法语 MHz",@"古典 MHz",@"动漫 MHz",@"咖啡馆 MHz",@"圣诞 MHz",@"豆瓣好歌曲 MHz"];
    

    // Do any additional setup after loading the view.
}


-(void)createUI
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 110) style:(UITableViewStylePlain)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorColor=[UIColor clearColor];
    UIView *view=[[UIView alloc]init];
    self.tableView.tableFooterView=view;
    [self.view addSubview:self.tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    /**
     *  这一堆都是没研究出来的防止复用的方法
     */
//    model.isSelect=YES;
//    for (int i = 0; i < _FMLISTArray.count; i++)
//    {
//        //防止复用，先关闭之前的图标
//        MyTableViewCell *allCell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        [allCell hideRank];
//        
//    }
//    
//    //    再开启新的图标
////    if (model.isSelect)
////    {
//////
////    for (int i=0; i<self.FMLISTArray.count; i++)
////    {
////        FmDataModel *model=self.FMLISTArray[i];
////       //    }
////    
////
////    }
//     NSIndexPath *temp = self.lastSelected;//暂存上一次选中的行
//    if(temp && temp!=indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一样,则让上一行不选中
//    {
//        FmDataModel *model = _FMLISTArray[temp.row];
//        model.isSelect = NO;
//        //修改之前选中的cell的数据为不选中
//        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新该行
//    }
//    self.lastSelected = indexPath;//选中的修改为当前行
//
//    model.isSelect = YES;//修改这个被选中的一行choon
////    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//重新刷新这一行
//    NSLog(@"%@选中的一行是",self.lastSelected);
//    if (model.isSelect)
//    {
//    MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:temp];
//        [cell showRank];
//    }

    

//    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
//    
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];



    FmDataModel *model=self.FMLISTArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MusicBox *musicBox=[MusicBox sharedInstance];
    musicBox.detaliedListView=NO;
    [_rootVC handleSwipeUp];
    [self.delegate PlayFMMusicListDelegatePassMark:@"NOT"];

    
    
    [musicBox musicBoxWillPlayWith:model.channel_id orUrlArray:nil andPlayIndex:(int)nil andlistMark:@"FMLIST" andListName:model.name andDetailedPlayName:(int)nil andLocalizeListName:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FMLISTArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
#pragma mark 填充cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell)
    {
        cell=[[MyTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[NSString stringWithFormat:@"mark"]];
        
    }
//    FmDataModel *model=self.FMLISTArray[indexPath.row];
    [self setCellTitleWithTitleArray:self.FMLISTArray];
    cell.textLabel.attributedText=_parameterArray[indexPath.row];
    return cell;
    
}
-(void)setCellTitleWithTitleArray:(NSArray *)array
{
    for (int i=0; i<array.count; i++)
    {
        FmDataModel *model=array[i];
        NSString *str=[NSString stringWithFormat:@"   %@ MHz",model.name];
        NSRange range=[str rangeOfString:@"MHz"];
        NSMutableAttributedString *str1=[[NSMutableAttributedString alloc]initWithString:str];
        [str1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range];
        [_parameterArray addObject:str1];
    }
}
-(void)downlondDataWithUrl:(NSString *)url
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^ void(AFHTTPRequestOperation * operation, id resultObject)
     {
         self.FMLISTArray=[FmDataModel parsingDateFromResultDict:resultObject];
         NSLog(@"FMLISTArray.count==%lu",(unsigned long)self.FMLISTArray.count);
         [self.tableView reloadData];
         
     } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
         
         NSLog(@"%@",error);
         if (error)
         {
             [_rootVC theNetorkIsUnstable:DOUBANFMLIST];
         }
         
     }];
}
-(void)closePlayingMark
{
    for (int i = 0; i < _FMLISTArray.count; i++)
    {
        //防止复用，先关闭之前的图标
        MyTableViewCell *allCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [allCell hideRank];
    }
    [self.tableView reloadData];


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
