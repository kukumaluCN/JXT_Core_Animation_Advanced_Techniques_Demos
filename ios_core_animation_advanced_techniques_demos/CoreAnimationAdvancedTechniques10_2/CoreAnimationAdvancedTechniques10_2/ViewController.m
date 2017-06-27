//
//  ViewController.m
//  CoreAnimationAdvancedTechniques10_2
//
//  Created by JXT on 2017/6/26.
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
@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
#if kPartEnabled == 1
    //曲线的斜率代表了速度，斜率的改变代表了加速度，原则上来说，任何加速的曲线都可以用这种图像来表示，但是CAMediaTimingFunction使用了一个叫做三次贝塞尔曲线的函数，它只可以产出指定缓冲函数的子集（我们之前在第八章中创建CAKeyframeAnimation路径的时候提到过三次贝塞尔曲线）。
    //一个三次贝塞尔曲线通过四个点来定义，第一个和最后一个点代表了曲线的起点和终点，剩下中间两个点叫做控制点，因为它们控制了曲线的形状，贝塞尔曲线的控制点其实是位于曲线之外的点，也就是说曲线并不一定要穿过它们。你可以把它们想象成吸引经过它们曲线的磁铁。
    
    
    //清单10.4 使用UIBezierPath绘制CAMediaTimingFunction
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.layerView.center = kScreenCenter;
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    //create timing function
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //对于我们自定义时钟指针的缓冲函数来说，我们需要初始微弱，然后迅速上升，最后缓冲到终点的曲线，通过一些实验之后，最终结果如下：
    function = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    
//    //get control points
//    CGPoint controlPoint1, controlPoint2;
//    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
//    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
//    
//    NSLog(@"%@", NSStringFromCGPoint(controlPoint1));
//    NSLog(@"%@", NSStringFromCGPoint(controlPoint2));
    
    //get control points
    float poi[2];
    [function getControlPointAtIndex:1 values:poi];
    CGPoint controlPoint1 = CGPointMake(poi[0], poi[1]);
    [function getControlPointAtIndex:2 values:poi];
    CGPoint controlPoint2 = CGPointMake(poi[0], poi[1]);
    
    NSLog(@"%@", NSStringFromCGPoint(controlPoint1));
    NSLog(@"%@", NSStringFromCGPoint(controlPoint2));
    
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1)
            controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    //scale the path up to a reasonable size for display
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    //flip geometry so that 0,0 is in the bottom-left
    self.layerView.layer.geometryFlipped = YES; //垂直反转，适配标准几何坐标系
#endif
    
    
    
    
#if kPartEnabled == 2
    //清单10.6 使用关键帧实现反弹球的动画
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.containerView.center = kScreenCenter;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"Ball.png"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.containerView addSubview:self.ballView];
    //animate
    [self animate];
    
#endif
    
    
    
    
    /**
     *  在清单10.6中，我们把动画分割成相当大的几块，然后用Core Animation的缓冲进入和缓冲退出函数来大约形成我们想要的曲线。但如果我们把动画分割成更小的几部分，那么我们就可以用直线来拼接这些曲线（也就是线性缓冲）。为了实现自动化，我们需要知道如何做如下两件事情：
     
            自动把任意属性动画分割成多个关键帧
            用一个数学函数表示弹性动画，使得可以对帧做便宜
        
        为了解决第一个问题，我们需要复制Core Animation的插值机制。这是一个传入起点和终点，然后在这两个点之间指定时间点产出一个新点的机制。对于简单的浮点起始值，公式如下（假设时间从0到1）：
        value = (endValue – startValue) × time + startValue;
     */
#if kPartEnabled == 3
    //清单10.7 使用插入的值创建一个关键帧动画
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.containerView.center = kScreenCenter;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"Ball.png"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.containerView addSubview:self.ballView];
    //animate
    [self animate];
#endif
}




#if kPartEnabled == 2 || kPartEnabled == 3
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
}
#endif


#if kPartEnabled == 2
- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
//    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)]
                         ];
    
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    //apply animation
    self.ballView.layer.position = CGPointMake(150, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}
#endif




#if kPartEnabled == 3
float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}
- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}
//- (void)animate
//{
//    //reset ball to top of screen
//    self.ballView.center = CGPointMake(150, 32);
//    //set up animation parameters
//    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
//    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
//    CFTimeInterval duration = 1.0;
//    //generate keyframes
//    NSInteger numFrames = duration * 60;
//    NSMutableArray *frames = [NSMutableArray array];
//    for (int i = 0; i < numFrames; i++) {
//        float time = 1 / (float)numFrames * i;
//        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
//    }
//    //create keyframe animation
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//    animation.keyPath = @"position";
//    animation.duration = 1.0;
//    animation.values = frames;
//    //apply animation
//    [self.ballView.layer addAnimation:animation forKey:nil];
//}

float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}
- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1/(float)numFrames * i;
        //apply easing
        time = bounceEaseOut(time);
        //add keyframe
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = frames;
    //apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}
#endif





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
