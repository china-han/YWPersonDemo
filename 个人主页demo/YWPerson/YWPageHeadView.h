//
//  YWPageHeadView.h
//  新个人主页
//
//  Created by hyw on 2018/11/19.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import <UIKit/UIKit.h>

//上下移动block  y<0为上移，y>0为下移
typedef void(^moveDirectionDownOrUpBlock)(CGFloat y);
@interface YWPageHeadView : UIView
@property (nonatomic,weak) UIView *parentView;  //手势移动的对比view
@property (nonatomic,weak) UIScrollView *parentScrollView;  //外部联动视图
@property (nonatomic,weak) UIScrollView *chidlScrollView;  //内部联动视图


@property (nonatomic,copy) moveDirectionDownOrUpBlock moveDirectionDownOrUpBlock;
@end
