//
//  FourViewController.m
//  个人主页demo
//
//  Created by hyw on 2018/11/15.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()
@property (nonatomic,strong) UIScrollView *mainScrollView;
@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     self.mainScrollView.frame = self.view.bounds;
    [self.view addSubview:self.mainScrollView];
    
  
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    redView.backgroundColor = [UIColor redColor];
    [self.mainScrollView addSubview:redView];
    
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(redView.frame), kScreenWidth, 300)];
     blueView.backgroundColor = [UIColor blueColor];
    [self.mainScrollView addSubview:blueView];
    
    UIView *yelloView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(blueView.frame), kScreenWidth, 300)];
     yelloView.backgroundColor = [UIColor yellowColor];
     [self.mainScrollView addSubview:yelloView];
    
    self.mainScrollView.contentSize = CGSizeMake(0, 900);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NAVHEIGHT - SegmentHeaderViewHeight)];
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor colorWithRed:242/255. green:242/255. blue:242/255. alpha:1.];
        
    }
    return _mainScrollView;
}

@end
