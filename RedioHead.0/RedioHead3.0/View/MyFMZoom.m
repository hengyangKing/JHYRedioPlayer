//
//  MyFMZoom.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MyFMZoom.h"
#import "MyButtonShop.h"
#import "MyMusicListView.h"
@interface MyFMZoom ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIImageView *playingMark;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MyMusicListView *myMusicListView;

@end

@implementation MyFMZoom

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, 155) style:(UITableViewStylePlain)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorColor=[UIColor clearColor];
    UIView *view=[[UIView alloc]init];
    self.tableView.tableFooterView=view;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    

    self.myMusicListView=[MyMusicListView sharedInstance];
    self.myMusicListView.view.frame=CGRectMake(0, self.tableView.frame.size.height+0, self.view.frame.size.width, self.view.frame.size.height-self.tableView.frame.size.height);
    [self.view addSubview:self.myMusicListView.view];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0)
    {
    return 60;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 1;
    }
    
        return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1)
    {
        return 20;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:iden];
    }
    if (indexPath.section==0)
    {
        cell.textLabel.text=@"   我的收藏";
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
        cell.imageView.image=[UIImage imageNamed:@"cm2_rdi_btn_love@3x"];
        
    }else if(indexPath.section==1)
    {
        cell.textLabel.text=@"   我的下载";
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
        cell.imageView.image=[UIImage imageNamed:@"cm2_list_detail_icn_faved@3x"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            NSLog(@"我的收藏");
            [_myMusicListView listNameisChange:@"我的收藏"];

            [self popView];
            [_myMusicListView newShowMusicList];
            
        }
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            [self popView];
            [_myMusicListView listNameisChange:@"我的下载"];
            [_myMusicListView newShowLocalizeMusicName];
            NSLog(@"本地音乐");
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 显示本地文件的方法

#pragma mark 来个小动画
-(void)popView
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
        _myMusicListView.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        
                       
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{

                        _myMusicListView.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                       } completion:^(BOOL finished) {
                           _myMusicListView.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

                       }];
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
