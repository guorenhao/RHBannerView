//
//  ViewController.m
//  RHBannerView
//
//  Created by 郭人豪 on 2017/5/4.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "ViewController.h"
#import "RHBannerView.h"

@interface ViewController () <RHBannerViewDelegate>

@property (nonatomic, strong) RHBannerView * bannerView;

@property (nonatomic, strong) RHBannerView * bannerView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.bannerView2];
    [self makeConstraintsForUI];
    
    RHBannerModel * model1 = [[RHBannerModel alloc] init];
    model1.placeholderName = @"001.jpg";
    RHBannerModel * model2 = [[RHBannerModel alloc] init];
    model2.placeholderName = @"002.jpg";
    RHBannerModel * model3 = [[RHBannerModel alloc] init];
    model3.placeholderName = @"003.jpg";
    RHBannerModel * model4 = [[RHBannerModel alloc] init];
    model4.placeholderName = @"004.jpg";
    RHBannerModel * model5 = [[RHBannerModel alloc] init];
    model5.placeholderName = @"005.jpg";
    [_bannerView configBannerWithModels:@[model1, model2, model3, model4, model5]];
}

- (void)makeConstraintsForUI {
    
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        // 高/宽 = 9 / 16
        make.height.mas_equalTo(_bannerView.mas_width).multipliedBy(9/16.0);
    }];
}

#pragma mark - bannerView delegate

- (void)bannerView:(RHBannerView *)bannerView didSelectAtIndex:(NSInteger)index {
    
    if (bannerView == _bannerView) {
        
        NSLog(@"点击了上边bannerView第%@个图片", @(index));
        static int flag = 0;
        flag ^= 1;
        if (flag) {
            
            [bannerView stop];
        } else {
            
            [bannerView run];
        }
    } else {
        
        NSLog(@"点击了下边bannerView2第%@个图片", @(index));
    }
    
    
    
}


- (RHBannerView *)bannerView {
    
    if (!_bannerView) {
        
        RHBannerView * bannerView = [[RHBannerView alloc] init];
        bannerView.pageStyle = RHBannerViewPageStyleMiddle;
        bannerView.delegate = self;
        bannerView.pageTintColor = [UIColor lightGrayColor];
        bannerView.currentPageTintColor = [UIColor redColor];
        bannerView.intervalTime = 2;
        _bannerView = bannerView;
    }
    return _bannerView;
}

- (RHBannerView *)bannerView2 {
    
    if (!_bannerView2) {
        
        RHBannerModel * model1 = [[RHBannerModel alloc] init];
        model1.placeholderName = @"001.jpg";
        RHBannerModel * model2 = [[RHBannerModel alloc] init];
        model2.placeholderName = @"002.jpg";
        RHBannerModel * model3 = [[RHBannerModel alloc] init];
        model3.placeholderName = @"003.jpg";
        RHBannerModel * model4 = [[RHBannerModel alloc] init];
        model4.placeholderName = @"004.jpg";
        RHBannerModel * model5 = [[RHBannerModel alloc] init];
        model5.placeholderName = @"005.jpg";
        RHBannerView * bannerView = [[RHBannerView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200) models:@[model1, model2, model3, model4, model5]];
//        bannerView.pageStyle = RHBannerViewPageStyleMiddle;
        bannerView.delegate = self;
//        bannerView.pageTintColor = [UIColor lightGrayColor];
//        bannerView.currentPageTintColor = [UIColor redColor];
        bannerView.intervalTime = 3;
        _bannerView2 = bannerView;
    }
    return _bannerView2;
}

@end
