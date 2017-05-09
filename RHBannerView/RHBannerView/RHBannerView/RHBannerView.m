//
//  RHBannerView.m
//  RHBannerView
//
//  Created by 郭人豪 on 2017/5/4.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "RHBannerView.h"
#import "RHBannerCell.h"

#define Cell_Collection    @"Cell_Collection"
@interface RHBannerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collection;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, assign) NSInteger page;
@end
@implementation RHBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _page = 1;
        _intervalTime = 3;
        [self addSubviews];
        self.pageStyle = RHBannerViewPageStyleRight;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (instancetype)initWithModels:(NSArray<RHBannerModel *> *)models {
    
    self = [super init];
    
    if (self) {
        
        [self configBannerWithModels:models];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<RHBannerModel *> *)models {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _page = 1;
        _intervalTime = 3;
        [self addSubviews];
        self.pageStyle = RHBannerViewPageStyleRight;
        self.backgroundColor = [UIColor yellowColor];
        [self configBannerWithModels:models];
    }
    return self;
}

- (void)addSubviews {
    
    [self addSubview:self.collection];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _collection.frame = self.bounds;
    [self makeConstraintForPageControlWithPageStyle:self.pageStyle];
    if (self.dataArr.count > 1) {
        
        [_collection setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    }
    [_collection reloadData];
}

#pragma mark - public

- (void)configBannerWithModels:(NSArray<RHBannerModel *> *)models {
    
    [self.dataArr removeAllObjects];
    [self removeTimer];
    _pageControl.numberOfPages = 0;
    
    if (models.count == 0) {
        
        [_collection reloadData];
        return;
    }
    
    if (models.count == 1) {
        
        [self.dataArr addObjectsFromArray:models];
    } else {
        
        [self.dataArr addObject:models.lastObject];
        [self.dataArr addObjectsFromArray:models];
        [self.dataArr addObject:models.firstObject];
        [_collection setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        _pageControl.numberOfPages = models.count;
        [self makeConstraintForPageControlWithPageStyle:self.pageStyle];
        [self addTimer];
    }
    [_collection reloadData];
}

- (void)run {
    
    if (self.dataArr.count > 1) {
        
        [self addTimer];
    }
}

- (void)stop {
    
    [self removeTimer];
}

#pragma mark - private

- (void)makeConstraintForPageControlWithPageStyle:(RHBannerViewPageStyle)pageStyle {
    
    float interval = 15;
    switch (pageStyle) {
        case RHBannerViewPageStyleLeft:
            _pageControl.frame = CGRectMake(10, self.bounds.size.height - 50, self.dataArr.count * interval, 50);
            break;
        case RHBannerViewPageStyleMiddle:
            _pageControl.frame = CGRectMake((self.bounds.size.width - self.dataArr.count * interval) / 2 , self.bounds.size.height - 50, self.dataArr.count * interval, 50);
            break;
        case RHBannerViewPageStyleRight:
            _pageControl.frame = CGRectMake(self.bounds.size.width - 10 - self.dataArr.count * interval, self.bounds.size.height - 50, self.dataArr.count * interval, 50);
            break;
            
        default:
            break;
    }
}

#pragma mark - timer

- (void)addTimer {
    
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(bannerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    
    if (self.timer) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)bannerRun {
    
    _page++;
    [self.collection setContentOffset:CGPointMake(_page * self.bounds.size.width, 0) animated:YES];
    
    if (_page == self.dataArr.count - 1) {
        
        _page = 1;
    }
}

#pragma mark - collectionView delegate and dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RHBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell_Collection forIndexPath:indexPath];
    if (indexPath.row < self.dataArr.count) {
        
        RHBannerModel * model = self.dataArr[indexPath.row];
        [cell configCellWithImageUrl:model.picture placeholderImage:[UIImage imageNamed:model.placeholderName]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    if (index == 0) {
        
        index = self.dataArr.count - 3;
    } else if (index == self.dataArr.count - 1) {
        
        index = 0;
    } else {
        
        index -= 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectAtIndex:)]) {
        
        [self.delegate bannerView:self didSelectAtIndex:index];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _collection) {
        
        if (self.dataArr.count > 1) {
            
            _page = _collection.contentOffset.x / self.bounds.size.width;
            
            if (_collection.contentOffset.x == 0) {
                
                _pageControl.currentPage = self.dataArr.count - 3;
                [_collection setContentOffset:CGPointMake(self.bounds.size.width * (self.dataArr.count - 2), 0)];
            } else if (_collection.contentOffset.x == self.bounds.size.width * (self.dataArr.count - 1)) {
                
                _pageControl.currentPage = 0;
                [_collection setContentOffset:CGPointMake(self.bounds.size.width, 0)];
            } else if (_collection.contentOffset.x == self.bounds.size.width * _page) {
                
                _pageControl.currentPage = _page - 1;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self addTimer];
}

#pragma mark - setter and getter

- (UICollectionView *)collection {
    
    if (!_collection) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collection.dataSource = self;
        collection.delegate = self;
        collection.bounces = NO;
        collection.pagingEnabled = YES;
        collection.showsHorizontalScrollIndicator = NO;
        collection.backgroundColor = [UIColor whiteColor];
        [collection registerClass:[RHBannerCell class] forCellWithReuseIdentifier:Cell_Collection];
        _collection = collection;
    }
    return _collection;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
        pageControl.currentPageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setPageStyle:(RHBannerViewPageStyle)pageStyle {
    
    _pageStyle = pageStyle;
    [self makeConstraintForPageControlWithPageStyle:pageStyle];
}

- (void)setPageTintColor:(UIColor *)pageTintColor {
    
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}

- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor {
    
    _currentPageTintColor = currentPageTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
}

- (void)setIntervalTime:(NSTimeInterval)intervalTime {
    
    _intervalTime = intervalTime;
    
    if (self.dataArr.count > 0) {
        
        [self removeTimer];
        [self addTimer];
    }
}

@end
