//
//  RHBannerCell.m
//  RHBannerView
//
//  Created by 郭人豪 on 2017/5/4.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "RHBannerCell.h"

@interface RHBannerCell ()

@property (nonatomic, strong) UIImageView * imageView;
@end
@implementation RHBannerCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1.0];
    }
    return self;
}

- (void)addSubviews {
    
    [self addSubview:self.imageView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}


- (void)configCellWithImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)image {
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
    }
    return _imageView;
}

@end
