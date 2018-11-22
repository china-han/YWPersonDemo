//
//  XXCustomPageControl.h
//  yaoguoLive
//
//  Created by showmac on 2018/11/15.
//  Copyright © 2018年 新浪SHOW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXCustomPageControl : UIPageControl

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;


@end

NS_ASSUME_NONNULL_END
