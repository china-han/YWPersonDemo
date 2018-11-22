//
//  directSeedingHeader.h
//  SinaShow
//
//  Created by lurong on 16/4/6.
//  Copyright © 2016年 新浪SHOW. All rights reserved.
//

#ifndef directSeedingHeader_h
#define directSeedingHeader_h

#import <Foundation/Foundation.h>



#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS9_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_4)
#define IOS8_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0)
#define IOS7_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
#define IOS6_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0)
#define IOS5_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_5_0)
#define IOS4_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_4_0)
#define IOS3_OR_LATER	(NSFoundationVersionNumber >= NSFoundationVersionNumber_iPhoneOS_3_0)

#else

#define IOS6_OR_LATER	(NO)
#define IOS5_OR_LATER	(NO)
#define IOS4_OR_LATER	(NO)
#define IOS3_OR_LATER	(NO)

#endif

#undef	RGB
#define RGB(R,G,B)          [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)       [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define APPDELEGATE             ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGTH       ([UIScreen mainScreen].bounds.size.height)

/********** 状态栏高度 **********/
#define NAVIGATIONBARHEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
/********** 导航栏高度 **********/
#define STATUSBARHEIGHT    44
/********** 导航栏+状态栏高度 **********/
#define NAVHEIGHT       (NAVIGATIONBARHEIGHT+STATUSBARHEIGHT)

#define SegmentHeaderViewHeight  41 //标题栏高度


#define AutoSize(px) ((SCREEN_HEIGTH > SCREEN_WIDTH) ? ([UIScreen mainScreen].bounds.size.width/750)*(px) : ([UIScreen mainScreen].bounds.size.height/750)*(px))
#define BOTTOM_HEIGHT 34

#define TOP_HEIGHT ([self isIPhoneX] ? 88 : 64)

#define LIANMAI_light_BACKCOLOR [[UIColor colorWithHexString:@"414141"]colorWithAlphaComponent:0.5];
#define LIANMAI_grey_BACKCOLOR [[UIColor colorWithHexString:@"414141"]colorWithAlphaComponent:0.7];

#define WEAKSELF __block typeof(self) __weak weakSelf = self;

#define  kUIFont(size)    [UIFont systemFontOfSize:size]


#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#define  DEF_PURPLE   [UIColor colorWithHexString:@"8232ff"]




#define FONT_SIZE(n) [UIFont systemFontOfSize:n]
#define STATUSBAR_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height

#define DEFAULT_HEAD_IMAGE [UIImage imageNamed:@"Default_Image"]
#define DEFAULT_HEAD_IMAGE_BIG [UIImage imageNamed:@"Default_Image_big"]
#define DEFAULT_LIVEBG_IMAGE [UIImage imageNamed:@"voice_deafultback"]

#define DEFAULT_BG_COLOR RGB(244, 244, 244)

#define DEFAULT_MAIN_COLOR DEFAULT_BG_COLOR





#define LABEL_COLOR_1 RGB(44,47,49)
#define LABEL_COLOR_2 RGB(101,106,114)
#define LABEL_COLOR_3 RGB(171,174,179)
#define LABEL_COLOR_4 RGB(233, 175, 51)

#define LABEL_COLOR_6 RGB(255, 210, 102) // 黄色
//#define DEFAULT_COLOR   RGB(216, 61, 255)
#define DEFAULT_COLOR   [UIColor colorWithHexString:@"A686F6"]

#define DEFAULT_PURPLE   [UIColor colorWithHexString:@"A686F6"]

#define DEFAULT_PURPLE_USER   [UIColor colorWithHexString:@"a686f6"]

#define LABEL_COLOR_5 DEFAULT_COLOR

#ifdef HTTPS_SWITCH

#define ROOM_PIC_URL @"https://img.live.sinashow.com/pic/hall/%@"
#define SMALL_HEAD_URL @"https://img.live.sinashow.com/pic/avatar/%lld_%d_200*200.jpg" // 小头像地址

#else

#define ROOM_PIC_URL @"http://img.live.sinashow.com/pic/hall/%@"
#define SMALL_HEAD_URL @"http://img.live.sinashow.com/pic/avatar/%lld_%d_200*200.jpg" // 小头像地址

#endif
#define DANMU_COLOR       RGB(216, 61, 255)
#define SUPER_DANMU_COLOR RGB(255, 102, 0)
#define SUPER_LINK_DANMU_COLOR  RGB(62, 130, 255)

#define ATUSER_NOTIFY @"ATUSER_NOTIFY"
#define FOLLOW @"FOLLOW"
#define SHAREVIEWDISMISS @"SHAREVIEWDISMISS"
#define CHANGE_HEAD_IMAGE @"CHANGE_HEAD_IMAGE"
#define SHOW_PERSION_INFO @"SHOW_PERSION_INFO"
#define OPENCOMMENWEBCTRL @"OPENCOMMENWEBCTRL"
#define LOGINROOM @"LOGINROOM"
#define DOUBLELIVE_BEGIN @"DOUBLELIVE_BEGIN"
#define LAND_MODEL_CHANGED @"LAND_MODEL_CHANGED"

#define TUIJIAN_OPEN @"TUIJIAN_OPEN"

#define HOMEOBJ @"HOMEOBJ"


#define IsEnablePersonalCenterVCMainTableViewScroll @"IsEnablePersonalCenterVCMainTableViewScroll"
#define PersonalCenterVCBackingStatus @"PersonalCenterVCBackingStatus"
#define SegementViewChildVCBackToTop @"segementViewChildVCBackToTop"




#endif /* directSeedingHeader_h */
