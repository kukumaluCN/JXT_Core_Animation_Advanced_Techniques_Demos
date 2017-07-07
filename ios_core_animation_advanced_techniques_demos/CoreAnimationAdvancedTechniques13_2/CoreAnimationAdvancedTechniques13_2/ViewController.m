//
//  ViewController.m
//  CoreAnimationAdvancedTechniques13_2
//
//  Created by JXT on 2017/7/7.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import "DrawingView.h"
#import "NewDrawingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //清单13.1 用Core Graphics实现一个简单的绘图应用
    //这样实现的问题在于，我们画得越多，程序就会越慢。因为每次移动手指的时候都会重绘整个贝塞尔路径（UIBezierPath），随着路径越来越复杂，每次重绘的工作就会增加，直接导致了帧数的下降。看来我们需要一个更好的方法了。
    
//    DrawingView *drawView = [[DrawingView alloc] initWithFrame:self.view.bounds];
//    drawView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:drawView];
    
    
    
    //清单13.2 用CAShapeLayer重新实现绘图应用
    //Core Animation为这些图形类型的绘制提供了专门的类，并给他们提供硬件支持（第六章『专有图层』有详细提到）。CAShapeLayer可以绘制多边形，直线和曲线。CATextLayer可以绘制文本。CAGradientLayer用来绘制渐变。这些总体上都比Core Graphics更快，同时他们也避免了创造一个寄宿图。
    NewDrawingView *drawView = [[NewDrawingView alloc] initWithFrame:self.view.bounds];
    drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
