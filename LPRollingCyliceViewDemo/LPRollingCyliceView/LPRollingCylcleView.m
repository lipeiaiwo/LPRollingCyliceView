//
//  LPRollingCylcleView.m
//  LPRollingCylcleView
//
//  Created by yc on 15/4/29.
//  Copyright (c) 2015年 wghl. All rights reserved.
//

#import "LPRollingCylcleView.h"
#import "UIImageView+WebCache.h"

#define CCMAXSECTION 100

@interface LPRollingCylcleView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSTimer *myTiemer;
@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic,weak) UILabel *textLabel;

@property (nonatomic,weak) UIView *backgroundView;

/**
 *  本地图片组
 */
@property (nonatomic,strong)NSArray *testDataAry;

/**
 *  网络图片组
 */
@property (nonatomic,strong)NSArray *picUrlAry;

@end

@implementation LPRollingCylcleView

+ (instancetype)rollingCylcleViewWithView:(UIView *)view picArray:(NSArray *)picArray placeholderImage:(UIImage *)placeholderImage didSelectItemAtIndexPath:(RollingCylcleViewBlock)block;
{
    CGRect tempR = view.bounds;

//    tempR.size.height += 1;
    
    LPRollingCylcleView *rolling = [[LPRollingCylcleView alloc] initWithFrame:tempR];
    
    rolling.picAry = picArray;
    
    rolling.placeholderImage = placeholderImage;
    
    rolling.block = [block copy];
    
    [view addSubview:rolling];
    
    return rolling;
}

- (void)setTextPageBackgroundColor:(UIColor *)textPageBackgroundColor
{
    _textPageBackgroundColor = textPageBackgroundColor;

    self.backgroundView.backgroundColor = textPageBackgroundColor;
    
}

#pragma mark - 一堆堆的懒加载
- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

- (UIImageView *)imageView2
{
    if (!_imageView2) {
        
        _imageView2 = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView2;
}

- (void)setPicAry:(NSArray *)picAry
{
    _picAry = picAry;
    
    if (!picAry.count) {
        return;
    }
    
    NSString *url = picAry[0];
        
    if ([url containsString:@"http"]){
        
        self.picUrlAry = picAry;
        
    }else
    {
        self.testDataAry = picAry;
    }
    
    [self createCollectionView];
}

- (void)setTextAry:(NSArray *)textAry
{
    _textAry = textAry;
    
    CGFloat backgroundViewX = 0;
    CGFloat backgroundViewW = self.frame.size.width;
    CGFloat backgroundViewH = 20;
    CGFloat backgroundViewY = self.frame.size.height - backgroundViewH;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH)];
    self.backgroundView = backgroundView;
    [self addSubview:backgroundView];
    
    
    CGFloat tempTextX = 0;
    CGFloat tempTextW = 16;
    CGFloat tempTextH = backgroundView.frame.size.height;
    CGFloat tempTextY = 0;
    
    UILabel *tempTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempTextX, tempTextY, tempTextW, tempTextH)];
    [backgroundView addSubview:tempTextLabel];
    
    
    CGFloat textX = tempTextW;
    CGFloat textW = self.frame.size.width - self.pageControl.frame.size.width - textX;
    CGFloat textH = backgroundView.frame.size.height;
    CGFloat textY = tempTextY;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    self.textLabel = textLabel;
    textLabel.text = self.textAry[0];
    textLabel.font = [UIFont boldSystemFontOfSize:12];
    textLabel.textColor = [UIColor whiteColor];
    [backgroundView addSubview:textLabel];
    

    CGRect tempFrame = self.pageControl.frame;
    
    tempFrame.origin.y = 0;
    
    self.pageControl.frame = tempFrame;
    
    [backgroundView addSubview:self.pageControl];
    
}

- (void)setPageType:(PageType)PageType
{
    _PageType = PageType;
    
    if (PageType == PageTypeAlignmentLeft) {
        
        CGRect tempFrame = self.pageControl.frame;
        
        tempFrame.origin.x = 0;
        
        self.pageControl.frame = tempFrame;
        
    }else if (PageType == PageTypeAlignmentCenter){
        
        CGRect tempFrame = self.pageControl.frame;
        
        tempFrame.origin.x = self.frame.size.width / 2 - tempFrame.size.width / 2;
        
        self.pageControl.frame = tempFrame;
        
    }else if (PageType == PageTypeAlignmentRight){
        
        CGRect tempFrame = self.pageControl.frame;
        
        tempFrame.origin.x = self.frame.size.width - tempFrame.size.width;
        
        self.pageControl.frame = tempFrame;
    }
}

#pragma mark - 创建collectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    
    [self addSubview:_myCollectionView];
    
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    //设置分页
    _myCollectionView.scrollEnabled = YES;
    _myCollectionView.pagingEnabled = YES;
    
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    
    //注册
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //设置初始位置
    [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:CCMAXSECTION/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    
    // 添加page 设置位置
    
    CGFloat pageW = self.picAry.count * 20;
    CGFloat pageH = 20;
    CGFloat pageX = self.frame.size.width - pageW;
    CGFloat pageY = self.frame.size.height - pageH;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX,pageY,pageW,pageH)];
    
    _pageControl.numberOfPages = self.picAry.count;
    
    [self addSubview:_pageControl];
    
    //添加定时器
    [self addNSTimer];
}

#pragma mark - 添加与删除定时器.开始与暂停
//添加定时器
- (void)addNSTimer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        //添加到runloop中
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        
        [[NSRunLoop currentRunLoop] run];
        
        _myTiemer = timer;
    });
}

#pragma mark - 定时器恢复启动
- (void)begingRunningNSTimer
{
    [self.myTiemer setFireDate:[NSDate distantPast]];
}

#pragma mark -定时器暂停
- (void)stopRunningNSTimer
{
    [self.myTiemer setFireDate:[NSDate distantFuture]];
}

//删除定时器
- (void)removeNSTimer
{
    [_myTiemer invalidate];
    _myTiemer = nil;
}

#pragma mark - 滚动到下一页
- (void)nextPage
{
    //获取当前页
    NSIndexPath *currentIndexPath = [[_myCollectionView indexPathsForVisibleItems] lastObject];
    
    //重置会初始中间页数据
    NSIndexPath *currentIndexPathRest = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:CCMAXSECTION/2];
    
    [_myCollectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    //下一个页面
    NSInteger nextItem = currentIndexPathRest.item + 1;
    NSInteger nextSection = currentIndexPathRest.section;
    
    if (nextItem == self.picAry.count) {
        
        nextItem = 0;
        nextSection++;
    }
    
    //动画下一页
    [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:nextSection] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

#pragma mark - uicollecitonViewDataSoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return CCMAXSECTION;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.picAry.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    NSUInteger index = indexPath.item;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //判断是否是网络数组还是本地数组
    if (self.picUrlAry.count > 0) {
        //网络数组时候设置imageurl
        self.imageUrl = [NSURL URLWithString:self.picUrlAry[index]];
        
    }else
    {
        //本地图片是时候设置imageurl为nil
        //同时修改缓存图片为本地图片
        self.imageUrl = nil;
        self.placeholderImage = [UIImage imageNamed:self.testDataAry[index]];
    }
    
    //交替显示图片
    if (self.imageView.image != Nil) {
        
        self.imageView = nil;
        
        [self.imageView2 sd_setImageWithURL:self.imageUrl placeholderImage:self.placeholderImage];
        
        cell.backgroundView = self.imageView2;
        
    }else{
        
        self.imageView2 = nil;
        
        [self.imageView sd_setImageWithURL:self.imageUrl  placeholderImage:self.placeholderImage];
        
        cell.backgroundView = self.imageView;
        
    }
    
    return cell;
}

#pragma mark - 选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        
        self.block(indexPath.item+1);
    }
}

#pragma mark - 拖动时移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}

#pragma mark - 结束拖动时.启动定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    [self addNSTimer];
}

#pragma mark - 设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width+0.5) % self.picAry.count;
    
    self.pageControl.currentPage = page;
    
    self.textLabel.text = self.textAry[page];
}

#pragma mark - 设置页码颜色与当前页码颜色
/**
 *  页码指示器颜色
 */
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

/**
 *  当前页码指示器颜色
 */
- (void)setPageCurrentTintColor:(UIColor *)pageCurrentTintColor
{
    _pageCurrentTintColor = pageCurrentTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = pageCurrentTintColor;
}

/**
 *  隐藏或显示页码控制器
 */
- (void)setPageControlIsHidden:(BOOL)pageControlIsHidden
{
    _pageControlIsHidden = pageControlIsHidden;
    
    self.pageControl.hidden = pageControlIsHidden;
}

- (void)didSelectItemAtIndexPath:(RollingCylcleViewBlock)block
{
    self.block = [block copy];
}

@end
