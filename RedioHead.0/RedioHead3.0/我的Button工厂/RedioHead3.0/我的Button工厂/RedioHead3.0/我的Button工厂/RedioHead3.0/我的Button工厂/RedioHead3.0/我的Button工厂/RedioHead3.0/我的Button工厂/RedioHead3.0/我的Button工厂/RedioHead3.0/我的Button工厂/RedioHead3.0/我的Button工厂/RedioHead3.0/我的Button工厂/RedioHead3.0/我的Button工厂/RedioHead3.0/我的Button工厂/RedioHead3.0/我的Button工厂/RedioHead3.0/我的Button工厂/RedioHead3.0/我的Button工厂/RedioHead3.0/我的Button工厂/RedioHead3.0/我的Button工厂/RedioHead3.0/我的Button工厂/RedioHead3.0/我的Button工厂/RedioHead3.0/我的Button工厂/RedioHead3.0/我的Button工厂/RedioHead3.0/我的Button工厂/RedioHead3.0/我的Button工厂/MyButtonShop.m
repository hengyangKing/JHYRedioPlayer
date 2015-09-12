//
//  MyButtonShop.m
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "MyButtonShop.h"

@implementation MyButtonShop
+ (UIButton *)createButtonWithFrame:(CGRect)rect andTitle:(NSString *)title andImage:(UIImage *)image andBgImage:(UIImage *)bgImage andSelecter:(SEL)sel andTarget:(id)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (rect.size.width) {
        btn.frame = rect;
    }
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    if (bgImage) {
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    if (sel) {
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
    
}

@end
