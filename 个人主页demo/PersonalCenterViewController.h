//
//  PersonalCenterViewController.h
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : UIViewController

//默认上下左右放大
@property (nonatomic, assign) BOOL isEnlarge;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, readonly, assign) BOOL isBacking;


@end
