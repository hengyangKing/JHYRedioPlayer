//
//  UITableView+isSelete.h
//  RedioHead3.0
//
//  Created by J on 15/9/11.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (isSelete)
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
