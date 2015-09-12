//
//  saveInformationSucceed.h
//  RedioHead3.0
//
//  Created by J on 15/8/17.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataModel.h"
@protocol MusicListDBManagerDelegate <NSObject>
@optional
-(void)saveInformationSucceed;
//-(void)deleteInformationSucceedYouMustRemoveData:(NSArray *)deleteDataArray;
@end
