//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_5
//
//  Created by JXT on 2017/2/19.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import "ReflectionView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 2


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    containerView.center = kScreenCenter;
    containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:containerView];
    
#if kPartEnabled == 1
    
    //清单6.8 用CAReplicatorLayer重复图层
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = containerView.bounds;
//    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [containerView.layer addSublayer:replicatorLayer];
    
    //configure the replicator
    replicatorLayer.instanceCount = 10;
    
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    
    replicatorLayer.instanceTransform = transform;
    
    //instanceCount属性指定了图层需要重复多少次。instanceTransform指定了一个CATransform3D3D变换。
    
    //apply a color shift for each instance
    replicatorLayer.instanceBlueOffset = -0.1;
    replicatorLayer.instanceGreenOffset = -0.1;
    //用instanceBlueOffset和instanceGreenOffset属性实现的。通过逐步减少蓝色和绿色通道，我们逐渐将图层颜色转换成了红色。
    
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicatorLayer addSublayer:layer];
    
#endif
    
    
    
    
    
#if kPartEnabled == 2
    
    //模仿系统indicatorView，理解CAReplicatorLayer具体布局
    
    //设置背景黑色
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    //复制对象容器CAReplicatorLayer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position = CGPointMake(containerView.bounds.size.width*0.5, containerView.bounds.size.height*0.5);
    replicatorLayer.backgroundColor = [UIColor blackColor].CGColor;
    [containerView.layer addSublayer:replicatorLayer];
    
    //添加复制对象
    CALayer *lineLayer = [CALayer layer];
    lineLayer.bounds = CGRectMake(0, 0, 10, 50);
    lineLayer.position = CGPointMake(replicatorLayer.bounds.size.width*0.5, 0);
    lineLayer.cornerRadius = lineLayer.bounds.size.width*0.5;
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicatorLayer addSublayer:lineLayer];
    
    //配置复制属性
    CGFloat count                     = 10;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2*M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    //复制延迟，用于动画效果
    CFTimeInterval delay = 1.0f;
    replicatorLayer.instanceDelay     = delay/count;
    
//    replicatorLayer.instanceColor = [UIColor redColor].CGColor;
//    replicatorLayer.instanceBlueOffset = -0.1;
//    replicatorLayer.instanceGreenOffset = -0.1;
//    replicatorLayer.instanceAlphaOffset = -0.1;
    
    //添加透明度渐变动画
    CABasicAnimation *animationOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationOpacity.fromValue   = @1.0;
    animationOpacity.toValue     = @0.0;
//    [lineLayer addAnimation:animationOpacity forKey:nil];
    //缩放动画
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.fromValue   = @1.0;
    animationScale.toValue     = @0.5;
    //组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration    = delay;
    animationGroup.animations = @[animationOpacity, animationScale];
    animationGroup.repeatCount = MAXFLOAT;
    [lineLayer addAnimation:animationGroup forKey:nil];
    
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    animation2.duration    = 1;
//    animation2.fromValue   = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 50)];
//    animation2.toValue     = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 10)];
//    animation2.repeatCount = MAXFLOAT;
//    [lineLayer addAnimation:animation2 forKey:nil];
    
    //设置复制对象初始值，使动画初始效果自然
    lineLayer.opacity = 0.5f;
    lineLayer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
//    [lineLayer setAffineTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    
#endif
    
    
    
    
    
#if kPartEnabled == 3
    
    //使用CAReplicatorLayer并应用一个负比例变换于一个复制图层，你就可以创建指定视图（或整个视图层次）内容的镜像图片，这样就创建了一个实时的『反射』效果。
    
    ReflectionView *reflectionView = [[ReflectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    reflectionView.center = kScreenCenter;
//    reflectionView.layer.contents = (__bridge id)[UIImage imageNamed:@"Anchor"].CGImage;
//    reflectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Anchor"]];
    [self.view addSubview:reflectionView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:reflectionView.bounds];
    imageView.image = [UIImage imageNamed:@"Anchor"];
    [reflectionView addSubview:imageView];
    
#endif
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
