//
//  PassMusicInformation.h
//  RedioHead3.0
//
//  Created by J on 15/8/14.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "dataModel.h"
@protocol PassMusicInformationDelegate <NSObject>
@optional
-(void)PassMusicImage:(UIImage *)image;
-(void)PassMusicElapsedTime:(NSDate *)elapsedTimeDate andTimeRemainingDate:(NSDate *)timeRemainingDate andPercentage:(int)percentage;
-(void)PassMusicArtist:(NSString *)artist andAlbumtitle:(NSString *)title;
-(void)playerIsChange;
-(void)PassMusicInformation:(dataModel *)data;
-(void)PassNowPlayMusicUrl:(NSString *)url;
@end
