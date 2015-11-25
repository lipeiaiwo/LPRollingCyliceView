//
//  LPRollingCylcleView.h
//  LPRollingCylcleView
//
//  Created by yc on 15/4/29.
//  Copyright (c) 2015年 wghl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RollingCylcleViewBlock)(NSUInteger index);

typedef enum{
    PageTypeAlignmentLeft   = 0,
    PageTypeAlignmentCenter = 1,
    PageTypeAlignmentRight  = 2,
}PageType;

@interface LPRollingCylcleView : UIView

@property (strong, nonatomic) RollingCylcleViewBlock block;

/**
 *  图片名称组
 */
@property (strong, nonatomic) NSArray *picAry;

/**
 *  描述文字数组
 */
@property (strong, nonatomic) NSArray *textAry;

/**
 *  描述文字背景颜色
 */
@property (weak, nonatomic) UIColor *textBackgroundColor;

/**
 *  占位图片
 */
@property (strong, nonatomic) UIImage *placeholderImage;

/**
 *  页码指示器颜色
 */
@property (weak, nonatomic) UIColor *pageIndicatorTintColor;

/**
 *  当前页码指示器颜色
 */
@property (weak, nonatomic) UIColor *pageCurrentTintColor;

/**
 *  描述文字页码指示器背景颜色
 */
@property (weak, nonatomic) UIColor *textPageBackgroundColor;

/**
 *  隐藏或显示页码控制器
 */
@property (assign, nonatomic) BOOL pageControlIsHidden;

/**
 *  页码指示器的位置  (默认居右)
 */
@property (nonatomic) PageType PageType;

/**
 *  点击图片
 */
- (void)didSelectItemAtIndexPath:(RollingCylcleViewBlock)block;

/**
 *  定时器恢复启动
 */
- (void)begingRunningNSTimer;

/**
 *  暂停定时器
 */
- (void)stopRunningNSTimer;

/**
 *  创建,本地图片网络图片都可以
 *
 *  @param view             添加到那个View上  view就可以
 *  @param picArray         图片数组,网络图片请传urlStr数组
 *  @param placeholderImage 占位图片
 *  @param block            点击了图片的回调 返回点击了第几张图片
 */
+ (instancetype)rollingCylcleViewWithView:(UIView *)view picArray:(NSArray *)picArray placeholderImage:(UIImage *)placeholderImage didSelectItemAtIndexPath:(RollingCylcleViewBlock)block;

@end
