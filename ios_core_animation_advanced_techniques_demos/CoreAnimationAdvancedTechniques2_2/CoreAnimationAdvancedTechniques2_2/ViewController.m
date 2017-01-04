//
//  ViewController.m
//  CoreAnimationAdvancedTechniques2_2
//
//  Created by JXT on 2016/12/1.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)


//#if (__IPHONE_OS_VERSION_MAX_ALLOWED == __IPHONE_10_1) || (__IPHONE_OS_VERSION_MAX_ALLOWED == __IPHONE_10_0)
//@interface ViewController () <CALayerDelegate>
//#else
//@interface ViewController ()
//#endif

//#ifdef __IPHONE_10_1
//@interface ViewController () <CALayerDelegate>
//#elif defined __IPHONE_10_0
//@interface ViewController ()
//#else
//@interface ViewController ()
//#endif

//#if defined(__IPHONE_10_0)
//@interface ViewController () <CALayerDelegate>
//#else
//@interface ViewController ()
//#endif

//7.3.1报错
//#ifdef __IPHONE_10_0
//@interface ViewController () <CALayerDelegate>
//#else
//@interface ViewController ()
//#endif

#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
@interface ViewController () <CALayerDelegate>
#else
@interface ViewController ()
#endif

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //给contents赋CGImage的值不是唯一的设置寄宿图的方法。我们也可以直接用Core Graphics直接绘制寄宿图。能够通过继承UIView并实现-drawRect:方法来自定义绘制。
    //寄宿图的像素尺寸等于视图大小乘以 contentsScale的值。
    //如果你不需要寄宿图，那就不要创建这个方法了，这会造成CPU资源和内存的浪费，这也是为什么苹果建议：如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法。
    
    
    //清单2.5 实现CALayerDelegate
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = kScreenCenter;
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [layerView.layer addSublayer:blueLayer];
    
    //set controller as layer delegate
    blueLayer.delegate = self;
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    //force layer to redraw
    [blueLayer display];
    
    //我们在blueLayer上显式地调用了-display。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。
    //尽管我们没有用masksToBounds属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持。
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
