//
//  PlayMyMusicListDelegate.h
//  RedioHead3.0
//
//  Created by J on 15/8/19.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayMyMusicListDelegate <NSObject>
-(void)PlayDetaliedMusicListDelegatePassMark:(NSString *)mark;
-(void)passNowPlayMusicListName:(NSString *)nowPlayMusicListName;
@end
