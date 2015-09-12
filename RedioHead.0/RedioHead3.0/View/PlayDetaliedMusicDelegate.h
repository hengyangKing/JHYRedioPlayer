//
//  PlayDetaliedMusicDelegate.h
//  RedioHead3.0
//
//  Created by J on 15/8/27.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayDetaliedMusicDelegate <NSObject>
-(void)PlayAllDetaliedMusicListDelegatePassMark:(NSString *)mark;
-(void)passNowPlayMusicListName:(NSString *)nowPlayMusicListName;
@end
