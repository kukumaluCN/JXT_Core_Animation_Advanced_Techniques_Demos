//
//  ViewController.m
//  CoreAnimationAdvancedTechniques10_1
//
//  Created by JXT on 2017/6/26.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kScreenScale [UIScreen mainScreen].scale

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 3

@interface ViewController ()
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *colorView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
#if kPartEnabled == 1
    //清单10.1 缓冲函数的简单测试
    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
#endif
    
    
    
    
#if kPartEnabled == 2
    //清单10.2 使用UIKit动画的缓冲测试工程
    //create a red layer
    self.colorView = [[UIView alloc] init];
    self.colorView.bounds = CGRectMake(0, 0, 100, 100);
    self.colorView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.colorView];
#endif
    
    
    
    
#if kPartEnabled == 3
    //CAKeyframeAnimation有一个NSArray类型的timingFunctions属性，我们可以用它来对每次动画的步骤指定不同的计时函数。但是指定函数的个数一定要等于keyframes数组的元素个数减一，因为它是描述每一帧之间动画速度的函数。
    
    //清单10.3 对CAKeyframeAnimation使用CAMediaTimingFunction
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
#if kPartEnabled == 1
    //configure the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //set the position
    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
    //commit transaction
    [CATransaction commit];
#endif
    
    
    
    
#if kPartEnabled == 2
    //perform the animation
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //set the position
                         self.colorView.center = [[touches anyObject] locationInView:self.view];
                     }
                     completion:NULL];
#endif
    
    
    
    
#if kPartEnabled == 3
    //create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    //add timing function
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn, fn, fn];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
#endif
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
