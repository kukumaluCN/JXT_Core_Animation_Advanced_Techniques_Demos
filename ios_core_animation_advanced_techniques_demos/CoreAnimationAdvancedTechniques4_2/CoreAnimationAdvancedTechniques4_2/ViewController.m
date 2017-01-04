//
//  ViewController.m
//  CoreAnimationAdvancedTechniques4_2
//
//  Created by JXT on 2017/1/4.
//  Copyright © 2017年 JXT. All rights reserved.
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
    
    
    //清单4.2 加上边框
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
    
    //enable clipping on the second layer
    testView2.layer.masksToBounds = YES;
    
    
    //CGColorRef 在引用/释放时候的行为表现得与 极其相 似。但是Objective-C语法并不支持这一做法，所以 属性即便是强引 用也只能通过assign关键字来声明。
    
    //边框是绘制在图层边界里面的，而且在所有子内容之前，也在子图层之 前。
    //和视图层级无关
    
    
    //图4.4 边框是跟随图层的边界变化的，而不是图层里面的内容
    UIImage *image = [UIImage imageNamed:@"snowman"];
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 600);
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityCenter;
    layerView.layer.contentsScale = 2;
    
    layerView.layer.cornerRadius = 20.f;
    layerView.layer.borderWidth = 5.f;
    [self.view addSubview:layerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
