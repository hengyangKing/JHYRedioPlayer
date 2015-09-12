//
//  UITableView+isSelete.m
//  RedioHead3.0
//
//  Created by J on 15/9/11.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "UITableView+isSelete.h"
#import "MyTableViewCell.h"
@implementation UITableView (isSelete)
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    MyTableViewCell *cell = (MyTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    [cell showRank];
}

@end
