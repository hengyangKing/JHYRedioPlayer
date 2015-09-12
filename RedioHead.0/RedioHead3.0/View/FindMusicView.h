//
//  FindMusicView.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayFMListMusicDelegate.h"
@interface FindMusicView : UIViewController
@property(nonatomic,strong)id<PlayFMListMusicDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *FMLISTArray;
@property(nonatomic,assign)NSInteger *index;
-(void)downlondDataWithUrl:(NSString *)url;
/**
 *  关闭正在播放的列表方法
 */
-(void)closePlayingMark;



@end
