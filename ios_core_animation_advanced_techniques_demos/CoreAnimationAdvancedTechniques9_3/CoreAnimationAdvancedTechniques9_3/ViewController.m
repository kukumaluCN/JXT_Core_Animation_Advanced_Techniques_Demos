//
//  ViewController.m
//  CoreAnimationAdvancedTechniques9_3
//
//  Created by JXT on 2017/6/23.
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
@property (nonatomic, strong) CALayer *doorLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //timeOffset一个很有用的功能在于你可以它可以让你手动控制动画进程，通过设置speed为0，可以禁用动画的自动播放，然后来使用timeOffset来来回显示动画序列。这可以使得运用手势来手动控制动画变得很简单。
    
    
    //清单9.4 通过触摸手势手动控制动画
    
    //add the door
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 0, 128, 256);
    self.doorLayer.position = CGPointMake(150 - 64, kScreenCenter.y);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"Door.png"].CGImage;
    [self.view.layer addSublayer:self.doorLayer];
    
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    //add pan gesture recognizer to handle swipes
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    //pause all layer animations
    self.doorLayer.speed = 0.0;
    //apply swinging animation (which won't play because layer is paused)
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
    [self.doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    //get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    //convert from points to animation duration //using a reasonable scale factor
    x /= 200.0f;
    //update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    //reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
