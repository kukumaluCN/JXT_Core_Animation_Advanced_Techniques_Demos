//
//  ViewController.m
//  CoreAnimationAdvancedTechniques3_3
//
//  Created by JXT on 2016/12/6.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

@interface ViewController ()
@property (nonatomic, strong) CALayer * layer;

@property (nonatomic, strong) CALayer * layer1;
@property (nonatomic, strong) CALayer * layer2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //翻转的几何结构
    //常规说来，在iOS上，一个图层的position位于父图层的左上角，但是在Mac OS上，通常是位于左下角。Core Animation可以通过geometryFlipped属性来适配这两种情况，它决定了一个图层的坐标是否相对于父图层垂直翻转，是一个BOOL类型。在iOS上通过设置它为YES意味着它的子图层将会被垂直翻转，也就是将会沿着底部排版而不是通常的顶部（它的所有子图层也同理，除非把它们的geometryFlipped属性也设为YES）。
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 200, 200);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(20, 10, 50, 50);
    subLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:subLayer];
    
    
    //通过增加图层的zPosition，就可以把图层向相机方向前置，于是它就在所有其他图层的前面了（或者至少是小于它的zPosition值的图层的前面）。
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(100, 400, 100, 100);
    layer1.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:layer1];
    self.layer1 = layer1;
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(150, 450, 100, 100);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer2];
    self.layer2 = layer2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //垂直反转坐标
    self.layer.geometryFlipped = !self.layer.geometryFlipped;
    
    CGFloat num = self.layer.geometryFlipped;
    self.layer1.zPosition = num;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
