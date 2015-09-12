//
//  LocalizeMusicBoxDelegate.h
//  RedioHead3.0
//
//  Created by J on 15/8/21.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalizeMusicBoxDelegate <NSObject>

-(void)LocailzeFileMusicPlayOver;
-(void)everyLocailzeMusicPlayTimePassCurrentTime:(NSTimeInterval )currentTime TimeRemainingDate:(NSTimeInterval )timeRemaining andPercentage:(int)percentage;
@end
