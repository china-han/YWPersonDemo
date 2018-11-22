//
//  CCPagedScrollView.m
//  CCPagedScrollView
//
//  Created by robbie on 14-8-15.
//  Copyright (c) 2014年 wenri365. All rights reserved.
//

#import "CCPagedScrollView.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "XXCustomPageControl.h"

//轮播图 没有view复用 所以轮播的图片不易太多页

@interface CCPagedScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
@private
    
    BOOL            _isAutoPlay ;
    NSTimeInterval  _animationDuration;
}

@property (nonatomic, strong)NSArray *activeItemArray;

-(void)buildCCPagedScrollView ;

//设置轮播View
-(void)setupViews ;

//切换界面
-(void)switchViewItems ;

//移动到指定位置
-(void)moveToTargetPosition:(CGFloat)targetX ;

@end

@implementation CCPagedScrollView

-(void)dealloc
{
    [self stopAuto] ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildCCPagedScrollView] ;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
 animationDuration:(NSTimeInterval)animationDuration
            isAuto:(BOOL)isAuto
{
    self = [self initWithFrame:frame];
    
    _animationDuration = animationDuration ;
    _isAutoPlay = isAuto ;
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self buildCCPagedScrollView] ;
    _animationDuration = 2.0;
    _isAutoPlay = YES;
}

#pragma mark - settor
-(void)setItems:(NSArray *)items
{
    NSInteger count = [items count] ;
    
    self.activeItemArray = [NSArray arrayWithArray:items];
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:count+2];
    
    //添加最后一张图 用于循环
    if (count > 1)
    {
        CCPagedScrollViewItem *item = [items[count -1] copy] ;
        [itemArray addObject:item];
    }
    for (int i = 0; i < count; i++)
    {
        [itemArray addObject:items[i]];
    }
    //添加第一张图 用于循环
    if (count >1)
    {
        CCPagedScrollViewItem *item = [items[0] copy] ;
        [itemArray addObject:item];
    }
    _items = itemArray ;
    
    
    [self setupViews] ;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma mark - public
-(void)stopAuto
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchViewItems) object:nil];
}

-(void)restartAuto
{
    if ([_items count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchViewItems) withObject:nil afterDelay:_animationDuration];
    }
}

-(void)scrollToIndex:(NSInteger)aIndex
{
    if ([_items count]>1)
    {
        if (aIndex >= ([_items count]-2))
        {
            aIndex = [_items count]-3;
        }
        [self moveToTargetPosition:self.bounds.size.width*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
}


#pragma mark - private
-(void)buildCCPagedScrollView
{
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
//    panGesture.delegate = self;
//    [self addGestureRecognizer:panGesture];
//
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.width, self.height)];
    
    _scrollView.scrollsToTop = NO;

    _pageControl = [[XXCustomPageControl alloc] initWithFrame:CGRectMake(0,
                                                                   _scrollView.bounds.size.height -20,
                                                                   self.bounds.size.width,
                                                                   20)];
    _pageControl.userInteractionEnabled = NO;
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6"))
//    {
    
//    _pageControl.currentPageIndicatorTintColor = RGBA(0, 0, 0,.8) ;
//    _pageControl.pageIndicatorTintColor =  RGBA(255, 255, 255,.7) ;
    
    UIImage *image = [UIImage imageNamed:@"page_normal"];
    _pageControl.inactiveImage = image;
    _pageControl.inactiveImageSize = image.size;
    image = nil;
    image = [UIImage imageNamed:@"page_select"];
    _pageControl.currentImage = image;
    _pageControl.currentImageSize = image.size;
    _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor clearColor];
    


//    }
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
}

-(void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(superview)] ;
    
    _pageControl.numberOfPages = [_items count]>1?[_items count] -2:[_items count];
    _pageControl.currentPage = 0;
    CGSize pointSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    _pageControl.frame = CGRectMake(_scrollView.width-10-pointSize.width, _pageControl.y, pointSize.width, _pageControl.height);
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [_items count], _scrollView.frame.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < [_items count]; i++)
    {
        CGRect frame = CGRectMake(i * _scrollView.frame.size.width,
                                  0,
                                  _scrollView.frame.size.width,
                                  _scrollView.frame.size.height) ;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        imageView.backgroundColor = RGB(230, 230, 230);
        imageView.clipsToBounds = YES ;
        [_scrollView addSubview:imageView];
        CCPagedScrollViewItem *item = _items[i];
        imageView.tag = @"imageView".hash;
        

        
        if(item.itemImage)
        {
            imageView.image = item.itemImage ;
        }else
        {
            if(item.itemImageUrl && [item.itemImageUrl length]>0)
            {
                [imageView setBackgroundColor:[UIColor clearColor]];
//                [imageView setContentMode:UIViewContentModeCenter];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                NSLog(@"image----%@",item.itemImageUrl);
                
                __weak UIImageView *weakImageView = imageView;
                __weak CCPagedScrollView *weakSelf = self;
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.itemImageUrl]
                             placeholderImage:[UIImage imageNamed:@"project_icon_adverbg"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 
                                 if (weakSelf.isImageFit)
                                 {
                                     weakImageView.width = image.size.width/2;
                                     weakImageView.height = image.size.height/2;
                                 }
                                 
                             }];
            }
        }
    }
    if ([_items count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO] ;
        [self restartAuto] ;
    }
}

-(void)switchViewItems
{
    [self stopAuto] ;
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
//    targetX = (int)(targetX/self.bounds.size.width) * self.bounds.size.width;
    [self moveToTargetPosition:targetX];
    
    [self restartAuto] ;
}

-(void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

- (void)adjustSubViewHeight
{
    _scrollView.height = self.height;
    for (UIView *subView in _scrollView.subviews)
    {
        subView.height = _scrollView.height;
    }
    _pageControl.y = _scrollView.bounds.size.height -20;
    
}

#pragma mark -actions
-(void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSInteger page = _pageControl.currentPage;//(int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < [self.activeItemArray count])
    {
        if(self.TapActionBlock)
        {
            CCPagedScrollViewItem *item = self.activeItemArray[page] ;
            self.TapActionBlock(item) ;
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    if ([_items count]>=3)
    {
        if (targetX >= self.bounds.size.width * ([_items count] -1))
        {
            targetX = self.bounds.size.width ;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = self.bounds.size.width  *([_items count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    
    NSInteger page = (_scrollView.contentOffset.x+self.bounds.size.width /2.0) / self.bounds.size.width ;
    
    if ([_items count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
    if (page!= _pageControl.currentPage)
    {
        if(self.CurrentIndexBlock)
        {
            CCPagedScrollViewItem *item = _items[page] ;
            self.CurrentIndexBlock(item) ;
        }
    }
    _pageControl.currentPage = page;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self restartAuto];
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
//        targetX = (int)(targetX/self.bounds.size.width) * self.bounds.size.width;
        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAuto];
}

@end


//============
@implementation CCPagedScrollViewItem


-(id)initWithItemImageUrl:(NSString *)itemImageUrl itemTag:(NSInteger)tag
{
    return [self initWithItemImage:nil WithItemImageUrl:itemImageUrl itemTag:tag];
}
-(id)initWithItemImage:(UIImage *)itemImage itemTag:(NSInteger)tag
{
    return [self initWithItemImage:itemImage WithItemImageUrl:nil itemTag:tag];
}

-(id)initWithItemImage:(UIImage *)itemImage WithItemImageUrl:(NSString *)itemImageUrl itemTag:(NSInteger)tag
{
    self = [self init];
    if(self)
    {
        self.itemImage = itemImage ;
        self.itemImageUrl = itemImageUrl ;
        self.itemTag = tag ;
    }
    return self ;
}

-(id)copyWithZone:(NSZone *)zone
{
    CCPagedScrollViewItem *itemCopy = [[CCPagedScrollViewItem allocWithZone:zone]init];
    itemCopy.itemTag = _itemTag ;
    itemCopy.itemImage = [_itemImage copy] ;
    itemCopy.itemImageUrl = [_itemImageUrl copy] ;
    return itemCopy;
}

@end
