//
//  RootViewController.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
//@property(nonatomic,assign)int on_off;
-(void)handleSwipeUp;
-(void)addListingCloce;
+ (instancetype)sharedInstance;
@end
