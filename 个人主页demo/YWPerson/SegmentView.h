//
//  SegmentView.h
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray parentController:(UIViewController *)parentController;
@end
