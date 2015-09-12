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
#import "addListingInformation.h"
@interface ListingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *listingTabelView;
@property(nonatomic,strong)NSMutableArray *muiscListArray;
@property(nonatomic,strong)UIButton *addListButton;
@property(nonatomic,strong)UIView *addListView;
@property(nonatomic,strong)UIImageView *addImageView;
@property(nonatomic,strong)UIButton *cloceButton;

@end

@implementation ListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.muiscListArray=[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets=NO;

//    for (int i=1; i<10; i++)
//    {
//        [_muiscListArray addObject:[NSString stringWithFormat:@"%d",i]];
//    }
    [self createUI];
    [self loadMusicList];
    
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    self.listingTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) style:(UITableViewStylePlain)];
    self.listingTabelView.delegate=self;
    self.listingTabelView.dataSource=self;
    self.listingTabelView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [self.view addSubview:self.listingTabelView];
}
-(void)loadMusicList
{
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray *cupArr=[[NSArray alloc]init];
    cupArr = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
    for (int i=0; i<cupArr.count; i++)
    {
        NSString *nameStr=cupArr[i];
        if ([nameStr hasSuffix:@"db"])
        {
            [_muiscListArray addObject:nameStr];
        }
    }
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
    NSLog(@"888");
    
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
    _addImageView.image=[UIImage imageNamed:@"55024"];
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
    NSLog(@"数据库操作，模态对话框，弹出键盘，创建列表，添加歌曲");
    [self cloceButtonClick];
    RootViewController *rootVC=[RootViewController sharedInstance];
    addListingInformation *addList=[[addListingInformation alloc]init];
    [rootVC presentViewController:addList animated:YES completion:^{
        NSLog(@"已经转跳完成，准备写入数据库名");
    }];
    //数据库操作，模态对话框，弹出键盘，创建列表，添加歌曲
}
-(void)cloceButtonClick
{
    NSLog(@"发消息关闭页面");
    RootViewController *rootVC=[RootViewController sharedInstance];
    [rootVC addListingCloce];
    
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
