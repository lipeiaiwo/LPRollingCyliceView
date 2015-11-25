//
//  ViewController.m
//  LPRollingCyliceViewDemo
//
//  Created by 黎培 on 15/11/25.
//  Copyright © 2015年 LP. All rights reserved.
//

#import "ViewController.h"
#import "LPRollingCylcleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRollingCylcleView];
}

- (void)loadRollingCylcleView
{
    // 创建需要显示的view  设置好frame 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 300)/ 2, [UIScreen mainScreen].bounds.size.width, 300)];
    
    [self.view addSubview:view];
    
    // 创建图片数组
    NSArray *array = @[@"http://d.3987.com/youyi_150918/006.jpg",
                       @"http://d.3987.com/youyi_150918/007.jpg",
                       @"http://d.3987.com/youyi_150918/001.jpg",
                       @"http://d.3987.com/youyi_150918/002.jpg",
                       @"http://d.3987.com/youyi_150918/003.jpg",
                       @"http://d.3987.com/youyi_150918/004.jpg",
                       @"http://d.3987.com/youyi_150918/008.jpg"];
    
    // 调用方法
    [LPRollingCylcleView rollingCylcleViewWithView:view picArray:array placeholderImage:[UIImage imageNamed:@"loading_02"] didSelectItemAtIndexPath:^(NSUInteger index) {
        
        // 点击事件的回调
        NSLog(@"点击了第%ld张图片",index);
        
    }];
    
}

@end
