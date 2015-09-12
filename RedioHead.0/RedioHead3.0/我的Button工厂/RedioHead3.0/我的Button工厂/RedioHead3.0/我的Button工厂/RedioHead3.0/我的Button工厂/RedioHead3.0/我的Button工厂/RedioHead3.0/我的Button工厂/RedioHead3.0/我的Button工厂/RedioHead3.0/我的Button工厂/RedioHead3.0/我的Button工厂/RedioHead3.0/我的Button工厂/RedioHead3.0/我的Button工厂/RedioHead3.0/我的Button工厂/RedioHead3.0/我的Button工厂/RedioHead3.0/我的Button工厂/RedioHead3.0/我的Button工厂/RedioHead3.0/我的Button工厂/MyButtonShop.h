//
//  MyButtonShop.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MyButtonShop : NSObject
+ (UIButton *)createButtonWithFrame:(CGRect)rect andTitle:(NSString *)title andImage:(UIImage *)image andBgImage:(UIImage *)bgImage andSelecter:(SEL)sel andTarget:(id)target;
@end
