//
//  ViewController.m
//  CoreAnimationAdvancedTechniques4_1
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
    
    //CALayer有一个叫做 conrnerRadius 的属性控制着图层角的曲率。它是一个浮 点数，默认为0(为0的时候就是直角)，但是你可以把它设置成任意值。默认情况 下，这个曲率值只影响背景颜色而不影响背景图片或是子图层。不过，如果把 masksToBounds 设置成YES的话，图层里面的所有东西都会被截取
    
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
    
    
    testView1.layer.cornerRadius = 20.0f;
    testView2.layer.cornerRadius = 20.0f;
    
    testView2.layer.masksToBounds = YES;
    
//    testView1.clipsToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
