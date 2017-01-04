//
//  ViewController.m
//  CoreAnimationAdvancedTechniques3_1
//
//  Created by JXT on 2016/12/2.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //视图的frame，bounds和center属性仅仅是存取方法，当操纵视图的frame，实际上是在改变位于视图下方CALayer的frame，不能够独立于图层之外改变视图的frame。
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 200)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 200);
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    
    NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(layerView.frame), NSStringFromCGRect(layerView.bounds), NSStringFromCGPoint(layerView.center));
    NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(layerView.layer.frame), NSStringFromCGRect(layerView.layer.bounds), NSStringFromCGPoint(layerView.layer.position));
    
    //对于视图或者图层来说，frame并不是一个非常清晰的属性，它其实是一个虚拟属性，是根据bounds，position和transform计算而来，所以当其中任何一个值发生改变，frame都会变化。相反，改变frame的值同样会影响到他们当中的值
    //记住当对图层做变换的时候，比如旋转或者缩放，frame实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域，也就是说frame的宽高可能和bounds的宽高不再一致了
    
    layerView.transform = CGAffineTransformMakeRotation(kDegreesToRadian(45));
    NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(layerView.frame), NSStringFromCGRect(layerView.bounds), NSStringFromCGPoint(layerView.center));
    NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(layerView.layer.frame), NSStringFromCGRect(layerView.layer.bounds), NSStringFromCGPoint(layerView.layer.position));
    
    UIView *maskView = [[UIView alloc] init];
    maskView.center = layerView.center;
    maskView.bounds = CGRectMake(0, 0, layerView.frame.size.width, layerView.frame.size.height);
    maskView.backgroundColor = [UIColor grayColor];
    [self.view insertSubview:maskView belowSubview:layerView];
    
    
    
    printf("\n\n***\n\n\n");
    
    
    UIView *layerView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 200)];
    layerView2.center = CGPointMake(kScreenWidth*0.5, 500);
    layerView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView2];
    
    
    NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(layerView2.frame), NSStringFromCGRect(layerView2.bounds), NSStringFromCGPoint(layerView2.center));
    NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(layerView2.layer.frame), NSStringFromCGRect(layerView2.layer.bounds), NSStringFromCGPoint(layerView2.layer.position));
    
    layerView2.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(layerView2.frame), NSStringFromCGRect(layerView2.bounds), NSStringFromCGPoint(layerView2.center));
    NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(layerView2.layer.frame), NSStringFromCGRect(layerView2.layer.bounds), NSStringFromCGPoint(layerView2.layer.position));
    
    UIView *maskView2 = [[UIView alloc] init];
    maskView2.center = CGPointMake(kScreenWidth*0.5+100, 500);
    maskView2.bounds = CGRectMake(0, 0, layerView2.frame.size.width, layerView2.frame.size.height);
    maskView2.backgroundColor = [UIColor grayColor];
    [self.view insertSubview:maskView2 belowSubview:layerView2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
