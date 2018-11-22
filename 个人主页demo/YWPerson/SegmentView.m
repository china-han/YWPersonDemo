//
//  SegmentView.m
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "SegmentView.h"
#import "HMSegmentedControl.h"



#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface SegmentView () <UIScrollViewDelegate>
@property(nonatomic, strong)HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) NSArray *ChildViewControllers;
@end

@implementation SegmentView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray parentController:(UIViewController *)parentController {
    if ( self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.ChildViewControllers = controllers;
        self.segmentedControl = [[HMSegmentedControl alloc] init];
        self.segmentedControl.sectionTitles = @[@"详情",@"进度"];
        self.segmentedControl.selectedSegmentIndex = 0;
        self.segmentedControl.backgroundColor = [UIColor whiteColor];//设定背景色
        self.segmentedControl.selectionIndicatorColor = UIColorFromRGB(0xD37EFA);//设定线条的颜色
        
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x343434),
                                                  NSFontAttributeName:[UIFont systemFontOfSize:14]};//设定title的颜色和字体
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x343434),
                                                          NSFontAttributeName:[UIFont systemFontOfSize:14]};//设定选中title时的颜色和字体
        
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;//设定线条的位置
        //        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;//设定线条的宽度
        //        segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10); //设置每个title上下左右间距
        self.segmentedControl.selectionIndicatorHeight = 3.f;//设定线条的高度
        self.segmentedControl.frame = CGRectMake(0, 0, kWidth, SegmentHeaderViewHeight);
          [self addSubview:self.segmentedControl];
        
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
//        NSLog(@"segmentedControl高度 ==%f",self.segmentedControl.frame.size.height);
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SegmentHeaderViewHeight, kWidth, kHeight - SegmentHeaderViewHeight)];
        self.contentScrollView.contentSize = CGSizeMake(kWidth * controllers.count, 0);
        self.contentScrollView.delegate = self;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.bounces = NO;
        [self addSubview:self.contentScrollView];
        
//        NSLog(@"contentScrollView高度 ==%f",self.contentScrollView.frame.size.height);
        
        UIViewController *vc = [self.ChildViewControllers firstObject];
        vc.view.frame = CGRectMake(0, 0, kWidth, kHeight - SegmentHeaderViewHeight);
        [self.contentScrollView addSubview:vc.view];
        
   
        
    }
    return self;
}

#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [self.contentScrollView setContentOffset:CGPointMake(kWidth *(segmentedControl.selectedSegmentIndex), 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
//增加分页视图左右滑动和外界tableView上下滑动互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll":@"0"}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll":@"1"}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        // 获得当前需要显示的子控制器的索引
        NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        _segmentedControl.selectedSegmentIndex = index;
        UIViewController *vc = self.ChildViewControllers[index];
        // 如果子控制器的view已经在上面，就直接返回
        if (vc.view.superview) return;
        // 添加
        CGFloat vcW = scrollView.frame.size.width;
        CGFloat vcH = kHeight - SegmentHeaderViewHeight;
        CGFloat vcX = index * vcW;
        CGFloat vcY = 0;
        vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
        [scrollView addSubview:vc.view];
    }
    
}

@end
