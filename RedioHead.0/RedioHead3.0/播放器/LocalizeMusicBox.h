//
//  LocalizeMusicBox.h
//  RedioHead3.0
//
//  Created by J on 15/8/21.
//  Copyright (c) 2015年 J. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LocalizeMusicBoxDelegate.h"
@interface LocalizeMusicBox : NSObject
+ (instancetype)sharedInstance;

-(void)startPlayingLocalFileWithName:(NSString *) fileName;
-(void)musicStopPlay;
-(void)musicStartPlay;
-(void)musicPausePlay;
-(void)musicPlayTimeOut;
-(void)sliderPlayWithSlider:(UISlider *)sender;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,strong)id<LocalizeMusicBoxDelegate> delegate;
@end
