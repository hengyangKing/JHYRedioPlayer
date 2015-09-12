//
//  ListingViewController.h
//  RedioHead3.0
//
//  Created by J on 15/8/15.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ListingViewController : UIViewController
//用于再本地下载页面批量将数据写入数据库的状态选择
@property(nonatomic,strong)NSString *MyMusicListViewIsEdit;
@property(nonatomic,strong)NSMutableArray *localizeMusicList;
+ (instancetype)sharedInstance ;

//-(void)loadMusicList;
-(void)createListSuccedd;
#pragma mark 新的更新数据方法
-(void)newLoadMusicList;
@end
