//
//  RelondLocalizeMusicInformation.m
//  RedioHead3.0
//
//  Created by J on 15/8/21.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "RelondLocalizeMusicInformation.h"
#import <UIKit/UIKit.h>
@implementation RelondLocalizeMusicInformation
+(NSMutableArray *)LoadingMusicInformationWithMusicArr:(NSArray *)musicArr
{
    
    NSLog(@"传进来的东西是%@",musicArr);
    NSMutableArray *dataArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<musicArr.count; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%@/Documents/music/%@",NSHomeDirectory(),musicArr[i]];
        NSURL *url=[NSURL fileURLWithPath:str];
        AVURLAsset *asset=[[AVURLAsset alloc]initWithURL:url options:nil];
        NSArray *arr=[asset metadataForFormat:@"org.id3"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        for (AVMetadataItem *item in arr)
        {
            if (item.commonKey)
            {
                [dic setObject:item.value forKey:item.commonKey];
            }
        }
            dataModel *model=[[dataModel alloc]init];
        model.title=dic[@"title"];
        model.artist=dic[@"artist"];
        model.albumPic=[UIImage imageWithData:[dic objectForKey:@"artwork"]];
        NSLog(@"+++++++%@",dic);

        [dataArr addObject:model];
    }
    return dataArr;
    
}

@end
