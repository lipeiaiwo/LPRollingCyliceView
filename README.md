
![正在加载图片](http://img1.ph.126.net/3X5JLZyWh15kWrC7NyBp4g==/6631292066073133948.gif)

非常简单就可以添加一个图片轮播器,正常使用只需要一个类方法就可以了
还可以定制图片下面可以有描述文字,还有页码孔子器的位置,颜色都是可以自定义的,详细的可以进LPRollingCylcleView 头文件里面看,都写了非常详细的注释了.

1.项目中需要 SDWebImage

2.调用类方法,有点击图片事件的回调

[LPRollingCylcleView rollingCylcleViewWithView:view picArray:array placeholderImage:[UIImage imageNamed:@"loading_02"] didSelectItemAtIndexPath:^(NSUInteger index) {

    // 点击事件的回调
    NSLog(@"点击了第%ld张图片",index);

}];
