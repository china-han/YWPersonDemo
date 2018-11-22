//
//  PersonalCenterViewController.m
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CenterTouchTableView.h"
#import "SegmentView.h"


#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"


#import "CCPagedScrollView.h"

#import "YWPageHeadView.h"

@interface PersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>


@property (nonatomic, strong) CenterTouchTableView *mainTableView;
//自定义导航栏
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) SegmentView *segmentView;
//@property (nonatomic, strong) UIImageView *headerImageView;
//@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, assign) BOOL canScroll;//mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isBacking;//是否正在pop



//@property (nonatomic, strong) headBackView *headView;
//空白view，可以加空间
@property (nonatomic, strong) UIView *tabHeadView;
//空白view高度
@property (nonatomic, assign) CGFloat tabHeadViewHeight;
//头部图片高度
@property (nonatomic, assign) CGFloat HeaderImageViewHeight;
//头部总高度
@property (nonatomic, assign) CGFloat offHeight;



@property(nonatomic,strong)CCPagedScrollView *imageScrollView;
@property (nonatomic,strong) YWPageHeadView *pageHeadView;
@end


@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人中心";
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //如果使用自定义的按钮去替换系统默认返回按钮，会出现滑动返回手势失效的情况
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //注册允许外层tableView滚动通知-解决和分页视图的上下滑动冲突问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //分页的scrollView左右滑动的时候禁止mainTableView滑动，停止滑动的时候允许mainTableView滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:IsEnablePersonalCenterVCMainTableViewScroll object:nil];
    
    
    
    //这三个高度必须先算出来，建议请求完数据知道高度以后再调用下面代码
    self.tabHeadViewHeight = AutoSize(318);
    self.HeaderImageViewHeight = AutoSize(667);
    self.offHeight = self.tabHeadViewHeight + self.HeaderImageViewHeight;
    [self setupSubViews];
    

    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.naviView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isBacking = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isBacking = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.naviView.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    self.mainTableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.tabHeadView];

    
     self.pageHeadView.parentScrollView = self.mainTableView;
    self.pageHeadView.chidlScrollView = self.imageScrollView.scrollView;

    
     [self.mainTableView addSubview:self.pageHeadView];
    [self.pageHeadView addSubview:self.imageScrollView];
     [self.view addSubview:self.naviView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)acceptMsg:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([notification.name isEqualToString:@"leaveTop"]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
    } else if ([notification.name isEqualToString:IsEnablePersonalCenterVCMainTableViewScroll]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.mainTableView.scrollEnabled = YES;
        } else if([canScroll isEqualToString:@"0"]) {
            self.mainTableView.scrollEnabled = NO;
        }
    }
}

#pragma mark - UiScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    //通知分页子控制器列表返回顶部
    [[NSNotificationCenter defaultCenter] postNotificationName:SegementViewChildVCBackToTop object:nil];
    return YES;
}

/**
 * 处理联动
 * 因为要实现下拉头部放大的问题，tableView设置了contentInset，所以试图刚加载的时候会调用一遍这个方法，所以要做一些特殊处理，
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当前y轴偏移量
    CGFloat currentOffsetY  = scrollView.contentOffset.y;
    //临界点偏移量
    CGFloat mainy = [self.mainTableView rectForSection:0].origin.y;
//    NSLog(@"mainy====%f",mainy);
    CGFloat criticalPointOffsetY = [self.mainTableView rectForSection:0].origin.y - NAVHEIGHT;
//    NSLog(@"criticalPointOffsetY====%f",criticalPointOffsetY);
//    NSLog(@"NAVHEIGHT====%f",NAVHEIGHT);
    //第一部分: 更改导航栏的背景图的透明度
    CGFloat alpha = 0;
    if (-currentOffsetY <= NAVHEIGHT) {
        alpha = 1;
    } else if ((-currentOffsetY > NAVHEIGHT) && -currentOffsetY < self.offHeight) {
        alpha = (self.offHeight + currentOffsetY) / (self.offHeight - NAVHEIGHT);
    } else {
        alpha = 0;
    }
    self.naviView.backgroundColor = kRGBA(255, 126, 15, alpha);
    
    //第二部分：
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (currentOffsetY >= criticalPointOffsetY) {
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
        self.canScroll = NO;
    } else {
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        }
    }
    
    //第三部分：
    /**
     * 处理头部自定义背景视图 (如: 下拉放大)
     * 图片会被拉伸多出状态栏的高度
     */
//     NSLog(@"currentOffsetY === %f",currentOffsetY);
    if(currentOffsetY <= -self.offHeight) {

        if (self.isEnlarge) {

            _pageHeadView.y  = currentOffsetY;
            _pageHeadView.height = -currentOffsetY-self.tabHeadViewHeight;
   
            
             _imageScrollView.height = -currentOffsetY-self.tabHeadViewHeight;
            [_imageScrollView adjustSubViewHeight];

        }else{
            scrollView.contentOffset = CGPointMake(0, -self.offHeight);
            scrollView.bounces = NO;

        }
        

    }else {
//        _imageScrollView.y = -(currentOffsetY + self.offHeight);
        scrollView.bounces = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:self.setPageViewControllers];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight - NAVHEIGHT;
}

#pragma mark - Lazy
- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVHEIGHT)];
        _naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        //添加返回按钮
        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
        backButton.frame = CGRectMake(5, 8 + NAVIGATIONBARHEIGHT, 28, 25);
        backButton.adjustsImageWhenHighlighted = YES;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:backButton];
        
        //添加消息按钮
        UIButton *messageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [messageButton setImage:[UIImage imageNamed:@"shareIcon"] forState:(UIControlStateNormal)];
        messageButton.frame = CGRectMake(kScreenWidth - 35, 8 + NAVIGATIONBARHEIGHT, 25, 25);
        messageButton.adjustsImageWhenHighlighted = YES;
        [messageButton addTarget:self action:@selector(gotoShare) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:messageButton];
    }
    return _naviView;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoShare {
    NSLog(@"点击分享");
}

/*
 * 这里可以设置替换你喜欢的segmentView
 */
- (UIView *)setPageViewControllers {
    if (!_segmentView) {
        //设置子控制器
        FirstViewController *firstVC  = [[FirstViewController alloc] init];
        FourViewController *forVC  = [[FourViewController alloc]init];
        NSArray *controllers = @[firstVC, forVC];
        NSArray *titleArray = @[@"华盛顿", @"夏威夷"];
        SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NAVHEIGHT) controllers:controllers titleArray:(NSArray *)titleArray parentController:self];
        //注意：不能通过初始化方法传递selectedIndex的初始值，因为内部使用的是Masonry布局的方式, 否则设置selectedIndex不起作用
        
        _segmentView = segmentView;
    }
    return _segmentView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        //⚠️这里的属性初始化一定要放在mainTableView.contentInset的设置滚动之前, 不然首次进来视图就会偏移到临界位置，contentInset会调用scrollViewDidScroll这个方法。
        //初始化变量
        self.canScroll = YES;
        
        self.mainTableView = [[CenterTouchTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        //注意：这里不能使用动态高度_headimageHeight, 不然tableView会往下移，在iphone X下，头部不放大的时候，上方依然会有白色空白
        _mainTableView.contentInset = UIEdgeInsetsMake(self.offHeight, 0, 0, 0);//内容视图开始正常显示的坐标为(0, HeaderImageViewHeight)
    }
    return _mainTableView;
}
//这是红色视图
-(UIView *)tabHeadView{
    if (!_tabHeadView) {
        _tabHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, -self.tabHeadViewHeight, kScreenWidth, self.tabHeadViewHeight)];
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"上部是无限轮播器\n整个标题栏上部都可以自定义";
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = _tabHeadView.bounds;
        [_tabHeadView addSubview:lable];
        _tabHeadView.backgroundColor = [UIColor redColor];
        
    }
    return _tabHeadView;
}


//这是轮播
- (CCPagedScrollView*)imageScrollView{
    if (!_imageScrollView)
    {

        _imageScrollView = [[CCPagedScrollView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, self.HeaderImageViewHeight) animationDuration:0 isAuto:NO];
        _imageScrollView.parentView = self.view;
        NSArray *imagesURLStrings = @[
                                      @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                      @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1542851892&di=0e59ba3566a6124310a0a94a7fe1d3d6&src=http://imgsrc.baidu.com/imgad/pic/item/d52a2834349b033b142032f71ece36d3d539bd77.jpg"
                                      ];

        NSMutableArray *array = [NSMutableArray array];
        for (NSString *imgUrl in imagesURLStrings) {
              [array addObject:[[CCPagedScrollViewItem alloc] initWithItemImageUrl:imgUrl itemTag:@(0)]];
        }


        _imageScrollView.items = array;
    }

    return _imageScrollView;
}

//这是轮播的父控件
-(YWPageHeadView *)pageHeadView{
    if (!_pageHeadView) {
        _pageHeadView = [[YWPageHeadView alloc]init];
        _pageHeadView.frame = CGRectMake(0, -self.offHeight,kScreenWidth, self.HeaderImageViewHeight);
    }
    return _pageHeadView;
}

@end
