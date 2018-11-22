# YWPersonDemo

# 介绍
仿简书微博等个人主页，在此基础上加上头部轮播及下拉轮播放大效果，并且允许左右滑动，如果手势在轮播上，允许左右滑动轮播滚动，上下滑动整体视图滚动，并且附带导航栏渐变效果，本demo下面的可滚动区域支持UITableView，UiScrollView，UICollectionView等视图，瀑布流等也允许


#### 视图显示

* 整体效果  

![image](https://github.com/china-han/YWPersonDemo/blob/master/image/%E4%B8%AA%E4%BA%BA%E4%B8%BB%E9%A1%B5.gif) 


* 下部分滑动切换效果 及导航栏渐变效果  

![image](https://github.com/china-han/YWPersonDemo/blob/master/image/person1.gif) 

* 轮播器滑动效果，允许上下滑动整体页面滑动 左右滑动轮播滑动   

![image](https://github.com/china-han/YWPersonDemo/blob/master/image/person1.gif) 


# Requirements
* Xcode 9.4.1
* iOS 8.0


# 用法
 因为当时只是想写的demo，所以并没有严格封装 各位可以自己下载demo看一下  这里简单说一下用法
 其中CenterTouchTableView这个类是下面要滑动的各个子类的父类，并且保证各个类存在UITableView，UiScrollView，UICollectionView等可滚动视图
 
 
 例如demo中下面的UITableView
```
@interface FirstViewController : SegmentViewController

@end

```
```

#import "FirstViewController.h"


@interface FirstViewController () < UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHeader;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    NSLog(@"tableView  %f",self.tableView.frame.size.height);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NAVHEIGHT - SegmentHeaderViewHeight)];
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = 50;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const FirstViewControllerTableViewCellIdentifier = @"FirstViewControllerTableViewCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:FirstViewControllerTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstViewControllerTableViewCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"快点我%ld -> 进入我的消息",indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

@end
```

你可以 自定义上半部分视图，如果你也想像我一样支持轮播，并且需要滑动左右轮播，上下滑动整体的话那你需要想我一样把轮播加在YWPageHeadView上面
例如
```
//这是轮播
- (CCPagedScrollView*)imageScrollView{
    if (!_imageScrollView)
    {

        _imageScrollView = [[CCPagedScrollView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, self.HeaderImageViewHeight) animationDuration:0 isAuto:NO];
      
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
        _pageHeadView.parentView = self.view;  //这个必须设置
        _pageHeadView.frame = CGRectMake(0, -self.offHeight,kScreenWidth, self.HeaderImageViewHeight);
    }
    return _pageHeadView;
}
```
```
     self.pageHeadView.parentScrollView = self.mainTableView;  //这个必须设置
     self.pageHeadView.chidlScrollView = self.imageScrollView.scrollView; //这个必须设置

    
     [self.mainTableView addSubview:self.pageHeadView];
     [self.pageHeadView addSubview:self.imageScrollView];
     [self.view addSubview:self.naviView];
```
但是如果你不需要轮播的额外处理，上面只是一个图片存在下拉放大等效果，可以不用YWPageHeadView这个类 直接定义视图加在mainTableView上


另外我为了定义的更加灵活，把轮播视图和下面的红色视图分开定义，加在了mainTableView上，这个可以按需求来，你可以灵活使用



#### 因为时间原因，里面的类名什么的就没有进行规范化处理了，如果使您阅读不便，请原谅一下，如果您有什么更好的建议也可以直接联系我，
#### 最后如果您能点下star支持一下，我会非常感谢😁


