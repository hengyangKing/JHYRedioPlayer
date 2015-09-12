//
//  MyTableViewCell.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MyTableViewCell.h"
@interface MyTableViewCell()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *playingMark;


@end
@implementation MyTableViewCell

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
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 50)];
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:24];
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
   
    
    _playingMark =[[UIImageView alloc]init];
    _playingMark.frame=CGRectMake(320, 19, 10, 10);
    _playingMark.layer.cornerRadius=5;
    _playingMark.layer.masksToBounds=YES;
    _playingMark.backgroundColor=[UIColor grayColor];
    _playingMark.hidden=YES;
    [self.contentView addSubview:_playingMark];
    


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
