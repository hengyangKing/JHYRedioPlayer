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
   
    
    
    UIImage *image1=[UIImage imageNamed:@"cm2_list_loading1@3x"];
    UIImage *image2=[UIImage imageNamed:@"cm2_list_loading2@3x"];
    NSArray *arr=@[image1,image2];


    
    _playingMark =[[UIImageView alloc]init];
    _playingMark.frame=CGRectMake(320, 10, 25, 25);
    _playingMark.layer.cornerRadius=12.5;
    _playingMark.layer.masksToBounds=YES;
    _playingMark.image=[UIImage imageNamed:@"cm2_list_loading2@3x"];
    _playingMark.animationImages=arr;//将图片数组赋给动画特性属性
    _playingMark. animationRepeatCount=0;// 参数为数组内图片循环的次数，0为无限循环
    _playingMark.animationDuration=10;//每次循环需要的时间
    
    [_playingMark startAnimating];
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
