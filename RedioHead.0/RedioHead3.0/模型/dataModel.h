//
//  dataModel.h
//  RedioHead3.0
//
//  Created by J on 15/8/13.
//  Copyright (c) 2015年 J. All rights reserved.
//

////"aid" : "1876585",
//"album" : "/subject/1876585/",
//"albumtitle" : "Demanufacture",
//"alert_msg" : "",
//"artist" : "Fear Factory",
//"company" : "Roadrunner Records",
//"file_ext" : "mp3",
//"kbps" : "128",
//"length" : 253,
//"like" : "0",
//"picture" : "http://img3.douban.com/lpic/s3260332.jpg",
//"public_time" : "1995",
//"rating_avg" : 4.2247,
//"sha256" : "175fe81b7d9cee2c64222d28a50bbf7de749a903ca1369f5c1211cd32767fa1f",
//"sid" : "2502109",
//"singers" : [
//             {
//                 "id" : "11588",
//                 "is_site_artist" : false,
//                 "name" : "Fear Factory",
//                 "related_site_id" : 0
//             }
//             ],
//"songlists_count" : 0,
//"ssid" : "11cc",
//"status" : 0,
//"subtype" : "",
//"title" : "Demanufacture",
//"url" : "http://mr3.douban.com/201508121347/bb4f37d009b06be7aca19dc982318731/view/song/small/p2502109_128k.mp3"
//},

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface dataModel : NSObject
@property(nonatomic,strong)NSString *artist;
@property(nonatomic,strong)NSString *picture;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *localizemusic;
@property(nonatomic,strong)NSString *playList;
@property(nonatomic,strong)UIImage *albumPic;
+ (NSMutableArray *)parsingDateFromResultDict:(NSDictionary *)dict;

@end
