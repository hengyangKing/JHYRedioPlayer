//
//  AppDelegate.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    RootViewController *rootVC=[RootViewController sharedInstance];
    self.window.rootViewController=rootVC;
    [self.window makeKeyAndVisible];
    NSLog(@"%@",[NSString stringWithFormat:@"%@",NSHomeDirectory()]);
    [self createMusicFile];
    
    // Override point for customization after application launch.
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}
-(void)createMusicFile
{
    NSFileManager *fm=[NSFileManager defaultManager];//创建文件管理器
    //    1.如何给一个字符串增加一个目录
//    NSString *path=[ stringByAppendingPathComponent:@"File1"];//拼接路径
    NSString *path=[NSString stringWithFormat:@"%@/Documents/music",NSHomeDirectory()];
    //注意一定要选择stringByAppendingPathComponent
    NSError *error=nil;
    if (![fm fileExistsAtPath:path])
    {
        BOOL tag=[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (tag)
        {
            NSLog(@"创建本地文件夹成功");
        }
        else
            NSLog(@"创建本地文件夹失败");
    }
    else
    {
        NSLog(@"文件夹已存在");
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
//    NSLog(@"我进入了后台");
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    bgTask=[application beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];

}
-(void)endBackgroundTask
{
    [[UIApplication sharedApplication]endBackgroundTask:bgTask];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
