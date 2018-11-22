//
//  SegmentViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "SegmentViewController.h"
@interface SegmentViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation SegmentViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //子控制器视图到达顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    //子控制器视图离开顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //返回顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:SegementViewChildVCBackToTop object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        } else {
            self.canScroll = NO;
        }
    } else if ([notificationName isEqualToString:@"leaveTop"]){
        self.canScroll = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }else if ([notificationName isEqualToString:SegementViewChildVCBackToTop]) {
        [self.scrollView setContentOffset:CGPointZero];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    self.scrollView = scrollView;
}



@end
