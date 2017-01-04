//
//  ViewController.m
//  CoreAnimationAdvancedTechniques1_3
//
//  Created by JXT on 2016/12/1.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //图1.3 灰色背景上的一个白色UIView
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    layerView.center = kScreenCenter;
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    
    //清单1.1 给视图添加一个蓝色子图层
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [layerView.layer addSublayer:blueLayer];
    
    //一个视图只有一个相关联的图层（自动创建），同时它也可以支持添加无数多个子图层，从清单1.1可以看出，你可以显示创建一个单独的图层，并且把它直接添加到视图关联图层的子图层。尽管可以这样添加图层，但往往我们只是见简单地处理视图，他们关联的图层并不需要额外地手动添加子图层。
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
