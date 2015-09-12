//
//  DetailedListViewCell.m
//  RedioHead3.0
//
//  Created by J on 15/8/19.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "DetailedListViewCell.h"
@interface DetailedListViewCell()

@end
@implementation DetailedListViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createCell];
    }
    return self;
}
-(void)createCell
{
    self.musicTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 300, 28)];
    
    _musicTitleLabel.backgroundColor = [UIColor clearColor];
    _musicTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    _musicTitleLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_musicTitleLabel];
    
    
    _subTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 34, 200, 13)];
    _subTitleLabel.textAlignment=NSTextAlignmentLeft;
    _subTitleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_subTitleLabel];
    
        
    _playingMark =[[UIImageView alloc]init];
    _playingMark.frame=CGRectMake(320, 19, 10, 10);
    _playingMark.layer.cornerRadius=5;
    _playingMark.layer.masksToBounds=YES;
    _playingMark.backgroundColor=[UIColor grayColor];
    _playingMark.hidden=YES;
    [self.contentView addSubview:_playingMark];
    
    _downlondMark=[[UIImageView alloc]initWithFrame:CGRectMake(20, 19, 10, 10)];
    _downlondMark.image=[UIImage imageNamed:@"cm2_act_checkbox_fg_prs@3x.png"];
    _downlondMark.layer.cornerRadius=5;
    _downlondMark.layer.masksToBounds=YES;
    _downlondMark.hidden=YES;
    [self.contentView addSubview:_downlondMark];
    
}

- (void)isDownloadWithModel:(dataModel *)model
{
    if (![model.localizemusic isEqualToString:@"1"]) {
        _downlondMark.hidden = NO;
    }else {
        _downlondMark.hidden = YES;
    }
}
- (void)showRank
{
    
    _playingMark.hidden = NO;
    
}
- (void)hideRank
{
    
    _playingMark.hidden = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
