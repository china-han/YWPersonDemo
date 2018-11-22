//
//  CenterTouchTableView.m
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "CenterTouchTableView.h"

@implementation CenterTouchTableView
//允许接收多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


////代理方法
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    // 点击的view的类名
//      NSLog(@"%@", NSStringFromClass([touch.view class]));
//    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CycScrollView"]) {
//        return NO;
//    }
//    return  YES;
//}

@end
