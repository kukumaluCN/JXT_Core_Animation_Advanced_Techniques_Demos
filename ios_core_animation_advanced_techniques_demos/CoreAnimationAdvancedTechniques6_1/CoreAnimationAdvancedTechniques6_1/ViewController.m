//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_1
//
//  Created by JXT on 2017/1/19.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 1

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //CAShapeLayer优点：
    //渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
    //高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
    //不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
    //不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
    
    
    //CAShapeLayer可以用来绘制所有能够通过CGPath来表示的形状。这个形状不一定要闭合，图层路径也不一定要不可破，事实上你可以在一个图层上绘制好几个不同的形状。
    //你可以控制一些属性比如lineWith（线宽，用点表示单位），
    //lineCap（线条结尾的样子），
    //和lineJoin（线条之间的结合点的样子）；
    //但是在图层层面你只有一次机会设置这些属性。如果你想用不同颜色或风格来绘制多个形状，就不得不为每个形状准备一个图层了。
    
    
    //清单6.1 用CAShapeLayer绘制一个火柴人
    //create path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5; //stroke宽度
    
    shapeLayer.lineJoin = kCALineJoinRound;
    //线条之间的结合点的样子
    //kCALineJoinMiter 斜接
    //kCALineJoinRound 圆角
    //kCALineJoinBevel 斜角
    
    shapeLayer.lineCap = kCALineCapRound;
    //线条结尾的样子
    //kCALineCapButt    截断
    //kCALineCapRound   圆角
    //kCALineCapSquare  直角
    
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
    
    
    //圆角矩形
    //define path parameters
    CGRect rect = CGRectMake(0, 0, 200, 200);
    CGSize radii = CGSizeMake(40, 40);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //create path
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    CAShapeLayer *cornerRectLayer = [CAShapeLayer layer];
    cornerRectLayer.frame = CGRectMake(50, 350, 200, 200);
    cornerRectLayer.backgroundColor = [UIColor yellowColor].CGColor;
    cornerRectLayer.strokeColor = [UIColor redColor].CGColor;
    cornerRectLayer.fillColor = [UIColor whiteColor].CGColor;
    cornerRectLayer.path = path2.CGPath;
    [self.view.layer addSublayer:cornerRectLayer];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
