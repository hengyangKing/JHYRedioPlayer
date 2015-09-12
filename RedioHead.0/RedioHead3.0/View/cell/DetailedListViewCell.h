//
//  DetailedListViewCell.h
//  RedioHead3.0
//
//  Created by J on 15/8/19.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataModel.h"

@interface DetailedListViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *downlondMark;
@property(nonatomic,strong)UIImageView *playingMark;
@property(nonatomic,strong)UILabel *musicTitleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
- (void)showRank;
- (void)hideRank;
- (void)isDownloadWithModel:(dataModel *)model;

@end
