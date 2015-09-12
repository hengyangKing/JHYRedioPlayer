//
//  FileOperateManager.m
//  RedioHead3.0
//
//  Created by J on 15/8/29.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "FileOperateManager.h"
#import "dataModel.h"
@interface FileOperateManager()
@property(nonatomic,strong)NSString *filePath;
@end
@implementation FileOperateManager
-(void)deleteLocalizeFileWith:(NSString *)musicName
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *path=[NSString stringWithFormat:@"%@/Documents/music/%@.mp3",NSHomeDirectory(),musicName];
    if ([fm fileExistsAtPath:path])
    {
        BOOL tag5=[fm removeItemAtPath:path error:nil];
        if (tag5)
        {
            NSLog(@"删除成功");
            
        }
        else
        {
            NSLog(@"删除又失败了");
            
        }
        
    }
}
-(void)deleteLocalizeDataWith:(NSArray *)dataArray
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *path=[NSString stringWithFormat:@"%@/Documents/music/",NSHomeDirectory()];
    
    for (int i=0; i<dataArray.count; i++)
       
    {
        dataModel *model=dataArray[i];
//        if ([model.url hasSuffix:@"mp3"])
//        {
//             _filePath=[NSString stringWithFormat:@"%@%@.mp3",path,model.localizemusic];
//            
//        }
//        else if([model.url hasPrefix:@"mp4"])
//        {
            _filePath=[NSString stringWithFormat:@"%@%@.mp4",path,model.localizemusic];
            NSLog(@"%@",_filePath);
   
//        }
       
        NSLog(@"mp3文件地址为%@",_filePath);
        if ([fm fileExistsAtPath:_filePath])
        {
            BOOL tag5=[fm removeItemAtPath:_filePath error:nil];
            if (tag5)
            {
                NSLog(@"删除成功");
            }
            else
            {
                NSLog(@"删除又失败了");
                
            }
            
        }
    }
}
-(NSMutableArray *)loadMusicFile
{
    NSMutableArray *localizeFileArray=[[NSMutableArray alloc]init];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray *cupArr=[[NSArray alloc]init];
    cupArr = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/music/",NSHomeDirectory()] error:nil];
    for (int i=0; i<cupArr.count; i++)
    {
        NSString *nameStr=cupArr[i];
        if ([nameStr hasSuffix:@".mp3"])
        {
            NSArray *cateName = [nameStr componentsSeparatedByString:@".mp3"];
            NSString *str1 = [cateName firstObject];
            [localizeFileArray addObject:str1];
        }
    }
    NSLog(@"查询出本地文件夹内的mp3个数为%lu",(unsigned long)localizeFileArray.count);
    NSLog(@"%@",localizeFileArray);
    return localizeFileArray;
}

@end
