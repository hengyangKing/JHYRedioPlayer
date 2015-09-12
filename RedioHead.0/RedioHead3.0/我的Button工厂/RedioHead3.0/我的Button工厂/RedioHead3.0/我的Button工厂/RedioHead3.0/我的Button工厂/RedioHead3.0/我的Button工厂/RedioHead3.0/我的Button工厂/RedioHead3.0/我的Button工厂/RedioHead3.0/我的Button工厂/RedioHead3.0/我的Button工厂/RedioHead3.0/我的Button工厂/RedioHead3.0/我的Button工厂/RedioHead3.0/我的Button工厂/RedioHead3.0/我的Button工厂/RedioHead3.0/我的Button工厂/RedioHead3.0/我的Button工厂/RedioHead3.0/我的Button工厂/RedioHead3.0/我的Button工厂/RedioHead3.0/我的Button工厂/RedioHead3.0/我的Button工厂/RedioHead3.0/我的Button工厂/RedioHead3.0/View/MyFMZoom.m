//
//  MyFMZoom.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MyFMZoom.h"

@interface MyFMZoom ()
@property(nonatomic,strong)UIImageView *playingMark;
@end

@implementation MyFMZoom

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    UIImage *image1=[UIImage imageNamed:@"cm2_list_loading1@3x"];
    UIImage *image2=[UIImage imageNamed:@"cm2_list_loading2@3x"];
    NSArray *arr=@[image1,image2];

    _playingMark =[[UIImageView alloc]init];
    
    _playingMark.frame=CGRectMake(320, 10, 25, 25);
    _playingMark.layer.cornerRadius=12.5;
    _playingMark.layer.masksToBounds=YES;
//    _playingMark.image=[UIImage imageNamed:@"cm2_list_loading2@3x"];
    _playingMark.animationImages=arr;//将图片数组赋给动画特性属性
    _playingMark. animationRepeatCount=0;// 参数为数组内图片循环的次数，0为无限循环
    _playingMark.animationDuration=0.5;//每次循环需要的时间
    
    [_playingMark startAnimating];
    _playingMark.hidden=NO;
    [self.view addSubview:_playingMark];

    // Do any additional setup after loading the view.
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
