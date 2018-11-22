//
//  CCPagedScrollView.h
//  CCPagedScrollView
//
//  Created by robbie on 14-8-15.
//  Copyright (c) 2014年 wenri365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "directSeedingHeader.h"

@class CCPagedScrollViewItem;
@class XXCustomPageControl;
@interface CCPagedScrollView : UIView

//适配数据
@property(strong,nonatomic)NSArray *items  ;
@property (nonatomic, strong)UIScrollView  *scrollView;
@property (nonatomic, strong)XXCustomPageControl   *pageControl;
@property (nonatomic, assign)BOOL isImageFit; // 是否适应image的大小


@property (nonatomic,weak) UIView *parentView;  //手势移动的对比view
@property (nonatomic,weak) UIScrollView *parentScrollView;  //手势移动的对比view

-(id)initWithFrame:(CGRect)frame
 animationDuration:(NSTimeInterval)animationDuration
            isAuto:(BOOL)isAuto;


- (void)adjustSubViewHeight;

//重新轮播
-(void)restartAuto ;
//取消轮播
-(void)stopAuto ;
//指定移动位置
-(void)scrollToIndex:(NSInteger)aIndex ;

/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(CCPagedScrollViewItem *item);

/**
 切换界面的时候，执行的block
 **/
@property (nonatomic , copy) void (^CurrentIndexBlock)(CCPagedScrollViewItem *item);

@end

//辅助信息
@interface CCPagedScrollViewItem : NSObject<NSCopying>

@property (nonatomic, assign)NSInteger  itemTag;
@property (nonatomic, strong)NSString   *itemImageUrl ;
@property (nonatomic, strong)UIImage    *itemImage ;


-(id)initWithItemImageUrl:(NSString *)itemImageUrl defaultImage:(UIImage*)itemImage itemTag:(NSInteger)tag ;
-(id)initWithItemImageUrl:(NSString *)itemImageUrl itemTag:(NSInteger)tag ;
-(id)initWithItemImage:(UIImage *)itemImage itemTag:(NSInteger)tag ;


@end
