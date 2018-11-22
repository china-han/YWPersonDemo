//
//  YWPageHeadView.m
//  新个人主页
//
//  Created by hyw on 2018/11/19.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "YWPageHeadView.h"

@interface YWPageHeadView ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL isMoveDownUp;   //是否上下滑动


@end

@implementation YWPageHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark - UI
- (void)setUpView{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];


}

////1返回值是返回是否生效。此方法在gesture recognizer视图转出UIGestureRecognizerStatePossible状态时调用，如果返回NO,则转换到UIGestureRecognizerStateFailed;如果返回YES,则继续识别触摸序列
// 给加的手势设置代理, 并实现此协议方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        self.chidlScrollView.scrollEnabled = YES;
        self.parentScrollView.scrollEnabled = YES;
        //        self.isMoveDownUp = YES;
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint pos = [pan velocityInView:self.parentView];
        CGFloat absX = fabs(pos.x);
        CGFloat absY = fabs(pos.y);
        
        NSLog(@"translation === %@",NSStringFromCGPoint(pos));
        if (absX > absY ) {
            self.isMoveDownUp = NO;
            self.parentScrollView.scrollEnabled = NO;
            self.chidlScrollView.scrollEnabled = YES;
            if (pos.x<0) {
                NSLog(@"向左滑动");
            }else{
                NSLog(@"向右滑动");
            }
            
            return YES;
        } else if (absY >= absX) {
            //            self.isMoveDownUp = YES;
            self.chidlScrollView.scrollEnabled = NO;
            self.parentScrollView.scrollEnabled = YES;
            if (pos.y<0) {
                NSLog(@"向上滑动");
            }else{
                NSLog(@"向下滑动");
            }}
        return YES;
    }
    
    return NO;
}


//2
//此方法返回YES时，手势事件会一直往下传递(允许多手势触发)，不论当前层次是否对该事件进行响应。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.isMoveDownUp) {
        return YES;
//    }
//    return self.isMoveDownUp;
}


- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan){
//        self.chidlScrollView.scrollEnabled = YES;
//        self.parentScrollView.scrollEnabled = YES;
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        [self commitTranslation:[recognizer translationInView:self.parentView]];
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        self.chidlScrollView.scrollEnabled = YES;
        self.parentScrollView.scrollEnabled = YES;
    }
//    NSLog(@"recognizer.state === %ld",(long)recognizer.state);
}

/**
 *   判断手势方向
 *
 *  @param translation translation description
 */
- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
//    if (MAX(absX, absY) < 10)
//        return;
    
//    NSLog(@"translation === %@",NSStringFromCGPoint(translation));    
    if (absX > absY ) {
        
      
        if (translation.x<0) {
            NSLog(@"左移");
            //向左滑动
            self.parentScrollView.scrollEnabled = NO;
            self.chidlScrollView.scrollEnabled = YES;
        }else{
            
            //向右滑动
            NSLog(@"右移");
            self.parentScrollView.scrollEnabled = NO;
            self.chidlScrollView.scrollEnabled = YES;
        }
        
        
    } else if (absY > absX) {
         self.chidlScrollView.scrollEnabled = NO;
        self.parentScrollView.scrollEnabled = YES;
//        self.chidlScrollView.scrollEnabled = NO;
        if (translation.y<0) {
            NSLog(@"上移");
//            //向上滑动
//            self.parentScrollView.scrollEnabled = YES;
//            self.chidlScrollView.scrollEnabled = NO;
        }else{
            NSLog(@"下移");
//            self.parentScrollView.scrollEnabled = YES;
           
            //向下滑动
        }
//        self.chidlScrollView.contentOffset = self.offset;
        if (self.moveDirectionDownOrUpBlock) {
            self.moveDirectionDownOrUpBlock(translation.y);
        }
        
    }else{
        self.chidlScrollView.scrollEnabled = NO;
        self.parentScrollView.scrollEnabled = YES;
        
    }
    
    
}


@end
