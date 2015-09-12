//
//  AppDelegate.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
}
@property (strong, nonatomic) UIWindow *window;
-(void)endBackgroundTask;

@end

