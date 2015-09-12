//
//  DownLondMusicAndSave.m
//  RedioHead3.0
//
//  Created by J on 15/8/19.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "DownLondMusicAndSave.h"
#import "AFNetworking.h"
#import "RootViewController.h"
#import "DetailedListView.h"
@interface DownLondMusicAndSave()
@property(nonatomic,strong)NSMutableArray *musicNameArray;
@property(nonatomic,strong)RootViewController *rootvc;
@property(nonatomic,strong)NSString *saveMusicPath;
@end
@implementation DownLondMusicAndSave
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"不能调用单例类的初始化方法" userInfo:nil];
}
-(NSMutableArray *)musicNameArray
{
    if (_musicNameArray == nil) {
        _musicNameArray  = [NSMutableArray array];
    }
    return _musicNameArray;

}
- (instancetype)initPrivate {
    if(self = [super init]) {
        
    }
    _rootvc=[RootViewController sharedInstance];
    return self;
}

+ (instancetype)sharedInstance {
    static DownLondMusicAndSave *downlondMuiscAndSaveManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        downlondMuiscAndSaveManager = [[self alloc] initPrivate];
    });
    
    return downlondMuiscAndSaveManager;
}
//查看是否下载
-(BOOL)opinionFileName:(NSString *)fileName
{
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
            if ([str1 isEqualToString:fileName])
            {
                [_rootvc misoperationPass:@"这首歌已下载"];
                return NO;
            }
        }else if([nameStr hasSuffix:@".mp4"])
        {
            NSArray *cateName = [nameStr componentsSeparatedByString:@".mp4"];
            NSString *str1 = [cateName firstObject];
            if ([str1 isEqualToString:fileName])
            {
                [_rootvc misoperationPass:@"这首歌已下载"];
                return NO;
            }

        }
    }
    
    return YES;
}
- (void)downloadMusicFileWithDataModel:(dataModel *)model  andFileNameIs:(NSString *)fileName;
{
    NSLog(@"已进入下载方法");
    if ([model.url hasSuffix:@".mp3"])
    {
        _saveMusicPath = [NSString stringWithFormat:@"%@/Documents/music/%@.mp3",NSHomeDirectory(),fileName];
        NSLog(@"mp3文件");
    }
    else if([model.url hasSuffix:@".mp4"])
    {
        _saveMusicPath = [NSString stringWithFormat:@"%@/Documents/music/%@.mp4",NSHomeDirectory(),fileName];
        NSLog(@"mp4文件");
    }
    
    
    NSURL *requestUrl=[NSURL URLWithString:model.url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:_saveMusicPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"is downlond%f",(float)totalBytesRead/totalBytesExpectedToRead);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        [self.delegate DownLondMusicSucceed:model];
    } failure:^ (AFHTTPRequestOperation *operation, NSError *error) {
    
        [_rootvc misoperationPass:@"下载失败"];

    }];
    
    [operation start];
}
@end
