//
//  ViewController.m
//  CoreAnimationAdvancedTechniques7_2
//
//  Created by JXT on 2017/4/9.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kScreenScale [UIScreen mainScreen].scale

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 2

@interface ViewController ()
@property (nonatomic, strong) CALayer * colorLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    layerView.center = kScreenCenter;
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    
    //create sublayer
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(50.0f, 50.0f, 200.0f, 200.0f);
    colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.colorLayer = colorLayer;
    //add it to our view
    [layerView.layer addSublayer:self.colorLayer];
    
    //button
    UIButton *testButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    testButton1.frame = CGRectMake(100, 255, 100, 40);
    [testButton1 setTitle:@"Change Color" forState:UIControlStateNormal];
    testButton1.titleLabel.font = [UIFont systemFontOfSize:12];
    testButton1.backgroundColor = [UIColor clearColor];
    testButton1.layer.cornerRadius = 5;
    testButton1.layer.borderWidth = 2;
    testButton1.layer.borderColor = [UIColor grayColor].CGColor;
    [testButton1 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [layerView addSubview:testButton1];
}

//清单7.3 在颜色动画完成之后添加一个回调
- (void)changeColor:(UIButton *)aSender
{
    //begin a new transaction
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    //add the spin animation on completion
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //commit the transaction
    [CATransaction commit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
