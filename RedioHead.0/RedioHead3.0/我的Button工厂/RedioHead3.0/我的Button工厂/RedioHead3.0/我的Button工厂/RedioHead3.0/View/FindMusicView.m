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
@interface FindMusicView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *parameterArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,stro
@end

@implementation FindMusicView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.parameterArray=[[NSMutableArray alloc]init];
    _titleArray=@[@"华语 MHz",@"欧美 MHz",@"70 MHz",@"80 MHz",@"90 MHz",@"粤语 MHz",@"摇滚 MHz",@"民谣 MHz",@"轻音乐 MHz",@"电影原声 MHz",@"爵士 MHz",@"电子 MHz",@"说唱 MHz",@"R&B MHz",@"日语 MHz",@"韩语 MHz",@"Puma Social MHz",@"女声 MHz",@"特仑苏 MHz",@"法语 MHz",@"豆瓣音乐人 MHz"];
    
    [self createUI];

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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicBox *musicBox=[MusicBox sharedInstance];
    RootViewController *rootVC=[RootViewController sharedInstance];
    [rootVC handleSwipeUp];
//    musicBox.index=(int)indexPath.row+1;//把频道传进去
    [musicBox editURLWithIndex:(int)indexPath.row+1];
    
    for (int i = 0; i < _titleArray.count; i++)
    {
        //防止复用，先关闭之前的图标
        
        MyTableViewCell *allCell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [allCell hideRank];
        
    }
//    再开启新的图标
    MyTableViewCell *cell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell showRank];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
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
        cell=[[MyTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mark"];
    }
    [self setCellTitleWithTitleArray:_titleArray];
    cell.textLabel.attributedText=_parameterArray[indexPath.row];
    return cell;
    
}
-(void)setCellTitleWithTitleArray:(NSArray *)array
{
    for (int i=0; i<array.count; i++)
    {
        NSString *str=array[i];
        NSRange range=[str rangeOfString:@"MHz"];
        NSMutableAttributedString *str1=[[NSMutableAttributedString alloc]initWithString:str];
        [str1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range];
        [_parameterArray addObject:str1];
    }
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
