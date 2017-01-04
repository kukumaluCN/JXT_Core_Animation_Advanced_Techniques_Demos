//
//  ViewController.m
//  CoreAnimationAdvancedTechniques4_3
//
//  Created by JXT on 2017/1/4.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)


#define kPartEnabled 4


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    
#if kPartEnabled == 1
    UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 150, 150)];
    testView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView1];
    
    testView1.layer.shadowOpacity = 1;
    testView1.layer.shadowOffset = CGSizeMake(0, 3);
    testView1.layer.shadowRadius = 3;
    
    
    
    //和图层边框不同，图层的阴影继承自内容的外形，而不是根据边界和角半径来确定。为了计算出阴影的形状，Core Animation会将寄宿图（包括子视图，如果有的话）考虑在内，然后通过这些来完美搭配图层形状从而创建一个阴影（见图4.7）。
    //图4.7 阴影是根据寄宿图的轮廓来确定的
    UIImage *image = [UIImage imageNamed:@"snowman"];
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 300);
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityCenter;
    layerView.layer.contentsScale = 2;
    [self.view addSubview:layerView];

    layerView.layer.shadowOpacity = 1;
    layerView.layer.shadowOffset = CGSizeMake(0, 5);
    layerView.layer.shadowRadius = 5;
#endif
    
    
    
#if kPartEnabled == 2
    //图4.8 maskToBounds属性裁剪掉了阴影和内容
    UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    testView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView1];
    UIView *testView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 150, 150)];
    testView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView2];
    
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 100, 100)];
    subView1.backgroundColor = [UIColor redColor];
    [testView1 addSubview:subView1];
    UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 100, 100)];
    subView2.backgroundColor = [UIColor redColor];
    [testView2 addSubview:subView2];
    //set the corner radius on our layers
    testView1.layer.cornerRadius = 20.0f;
    testView2.layer.cornerRadius = 20.0f;
    //add a border to our layers
    testView1.layer.borderWidth = 5.0f;
    testView2.layer.borderWidth = 5.0f;
    
    //阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。
    
    //enable clipping on the second layer
    testView2.layer.masksToBounds = YES;
//    testView2.clipsToBounds = YES;
    
    testView1.layer.shadowOpacity = 0.8;
    testView1.layer.shadowOffset = CGSizeMake(0, 5);
    testView1.layer.shadowRadius = 10;
    
    testView2.layer.shadowOpacity = 0.8;
    testView2.layer.shadowOffset = CGSizeMake(0, 5);
    testView2.layer.shadowRadius = 10;
#endif
    
    
    
#if kPartEnabled == 3
    //清单4.3 用一个额外的视图来解决阴影裁切的问题
    UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    testView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView1];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 150, 150)];
    shadowView.backgroundColor = [UIColor clearColor]; //不可以填充背景色
    [self.view addSubview:shadowView];
    UIView *testView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    testView2.backgroundColor = [UIColor whiteColor];
    [shadowView addSubview:testView2];
    
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 100, 100)];
    subView1.backgroundColor = [UIColor redColor];
    [testView1 addSubview:subView1];
    UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 100, 100)];
    subView2.backgroundColor = [UIColor redColor];
    [testView2 addSubview:subView2];
    //set the corner radius on our layers
    testView1.layer.cornerRadius = 20.0f;
    testView2.layer.cornerRadius = 20.0f;
    //add a border to our layers
    testView1.layer.borderWidth = 5.0f;
    testView2.layer.borderWidth = 5.0f;
    
    //阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。
    
    //enable clipping on the second layer
    testView2.layer.masksToBounds = YES;
    //    testView2.clipsToBounds = YES;
    
    testView1.layer.shadowOpacity = 0.8;
    testView1.layer.shadowOffset = CGSizeMake(0, 5);
    testView1.layer.shadowRadius = 5;
    
    shadowView.layer.shadowOpacity = 0.8;
    shadowView.layer.shadowOffset = CGSizeMake(0, 5);
    shadowView.layer.shadowRadius = 5;
#endif
    
    
    
#if kPartEnabled == 4
    //清单4.4 创建简单的阴影形状
    UIImage *image = [UIImage imageNamed:@"snowman"];
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityCenter;
    layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:layerView];
    
    UIView *layerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    layerView2.center = CGPointMake(kScreenWidth*0.5, 400);
    layerView2.layer.contents = (__bridge id)image.CGImage;
    layerView2.layer.contentsGravity = kCAGravityCenter;
    layerView2.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:layerView2];
    
    layerView.layer.shadowOpacity = 0.5f;
//    layerView.layer.shadowOffset = CGSizeMake(0, 5);
//    layerView.layer.shadowRadius = 5;
    layerView2.layer.shadowOpacity = 0.5f;
    
    //create a square shadow
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, layerView.bounds);
    layerView.layer.shadowPath = squarePath; CGPathRelease(squarePath);
    
    //create a circular shadow
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, layerView2.bounds);
    layerView2.layer.shadowPath = circlePath; CGPathRelease(circlePath);
    
    //如果是一个矩形或者是圆，用CGPath会相当简单明了。但是如果是更加复杂一点的图形，UIBezierPath类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类。
    
#endif
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
