//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_4
//
//  Created by JXT on 2017/2/9.
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

#define kPartEnabled 4

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    
    //CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。
    
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    containerView.center = kScreenCenter;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    
#if kPartEnabled == 1
    
    //清单6.6 简单的两种颜色的对角线渐变
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = containerView.bounds;
    [containerView.layer addSublayer:gradientLayer];
    
    //这个数组成员接受CGColorRef类型的值（并不是从NSObject派生而来），所以我们要用通过bridge转换以确保编译正常。
    //set gradient colors
    gradientLayer.colors = @[
                             (__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor
                             ];
    
    //CAGradientLayer也有startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}。
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
#endif
    
    
    
    
#if kPartEnabled == 2
    
    //默认情况下，这些颜色在空间上均匀地被渲染，但是我们可以用locations属性来调整空间。
    //locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置，同样的，也是以单位坐标系进行标定。0.0代表着渐变的开始，1.0代表着结束。
    
    //清单6.7 在渐变上使用locations
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = containerView.bounds;
    [containerView.layer addSublayer:gradientLayer];
    
    //set gradient colors
    gradientLayer.colors = @[
                             (__bridge id)[UIColor redColor].CGColor,
                             (__bridge id) [UIColor yellowColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor
                             ];
    
    //set locations
    gradientLayer.locations = @[@0.0, @0.25, @0.5];
    
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
#endif
    
    
    
    
#if kPartEnabled == 3
    
    //切边遮罩
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = containerView.bounds;
    [containerView.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[
                             (__bridge id)[UIColor blackColor].CGColor,
                             (__bridge id)[UIColor clearColor].CGColor
                             ];
    
    //set locations
//    gradientLayer.locations = @[@0.0, @0.5];
    
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
#endif
    
    
    
    
    
#if kPartEnabled == 4
    
    //环形渐变进度条实现
    //http://www.superqq.com/blog/2015/08/12/realization-circular-gradient-progress/?utm_source=tuicool&utm_medium=referral
    
    //iOS实现一个颜色渐变的弧形进度条
    //http://blog.csdn.net/zhoutao198712/article/details/20864143
    
    //创建一个圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, containerView.bounds.size.width-20, containerView.bounds.size.height-20)];
    
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = containerView.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 20;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.5;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = bezierPath.CGPath;
    
    //颜色渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = containerView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    gradientLayer.colors = @[
                             (__bridge id)[UIColor blackColor].CGColor,
                             (__bridge id)[UIColor whiteColor].CGColor
                             ];
    
    gradientLayer.mask = shapeLayer;
    
    [containerView.layer addSublayer:gradientLayer];
    
    
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 1;
    [gradientLayer addAnimation:rotationAnimation forKey:@"groupAnnimation"];
    
    
#endif
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
