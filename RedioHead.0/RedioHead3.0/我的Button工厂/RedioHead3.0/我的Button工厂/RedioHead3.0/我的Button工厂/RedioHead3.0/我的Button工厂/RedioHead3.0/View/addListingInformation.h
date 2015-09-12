//
//  addListingInformation.h
//  RedioHead3.0
//
//  Created by J on 15/8/16.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddListingInformationDelagate.h"
@interface addListingInformation : UIViewController
@property(nonatomic,strong)id<AddListingInformationDelagate> delegate;
@end
