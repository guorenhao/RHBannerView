//
//  RHBannerView.h
//  RHBannerView
//
//  Created by 郭人豪 on 2017/5/4.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHBannerModel.h"

// pageControl 所在位置
typedef NS_ENUM (NSInteger, RHBannerViewPageStyle) {
    
    RHBannerViewPageStyleLeft = 0,  // 左边
    RHBannerViewPageStyleMiddle,    // 中间
    RHBannerViewPageStyleRight      // 右边
};

@protocol RHBannerViewDelegate;
@interface RHBannerView : UIView
// 代理
@property (nonatomic, weak) id<RHBannerViewDelegate> delegate;
// PageControl所在位置样式  默认靠右
@property (nonatomic, assign) RHBannerViewPageStyle pageStyle;
// PageControl未选中圆点颜色 默认灰色
@property (nonatomic, strong) UIColor * pageTintColor;
// PageControl选中圆点颜色  默认白色
@property (nonatomic, strong) UIColor * currentPageTintColor;
// 轮播间隔时间  默认3秒
@property (nonatomic, assign) NSTimeInterval intervalTime;

// 定义构造方法快速创建对象
- (instancetype)initWithModels:(NSArray<RHBannerModel *> *)models;
// 定义构造方法快速创建对象
- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<RHBannerModel *> *)models;


/**
 根据model配置bannerView

 @param models 存储RHBannerModel对象的数组
 */
- (void)configBannerWithModels:(NSArray<RHBannerModel *> *)models;


@end
@protocol RHBannerViewDelegate <NSObject>

@optional
// 点击图片
- (void)bannerView:(RHBannerView *)bannerView didSelectAtIndex:(NSInteger)index;

@end
