//
//  ViewController.m
//  CoreAnimationAdvancedTechniques8_1
//
//  Created by JXT on 2017/5/23.
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

@interface ViewController () <CAAnimationDelegate>
@property (nonatomic, strong) CALayer * colorLayer;

@property (nonatomic, strong) UIImageView * hourHand;
@property (nonatomic, strong) UIImageView * minHand;
@property (nonatomic, strong) UIImageView * secHand;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
#if kPartEnabled == 1
    //清单8.3 动画完成之后修改图层的背景色
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
    
    
    //像所有的NSObject子类一样，CAAnimation实现了KVC（键-值-编码）协议，于是你可以用-setValue:forKey:和-valueForKey:方法来存取属性。但是CAAnimation有一个不同的性能：它更像一个NSDictionary，可以让你随意设置键值对，即使和你使用的动画类所声明的属性并不匹配。
    //这意味着你可以对动画用任意类型打标签。
#endif
    
    
    
#if kPartEnabled == 2
    //清单3.1 Clock
    UIImageView *clockView = [self createImageViewWithName:@"clock"];
    clockView.center = CGPointMake(kScreenWidth*0.5, 500);
    [self.view addSubview:clockView];
    
    CGPoint center = CGPointMake(clockView.bounds.size.width*0.5, clockView.bounds.size.height*0.5);
    
    UIImageView *hourHand = [self createImageViewWithName:@"clock_hour"];
    hourHand.center = center;
    [clockView addSubview:hourHand];
    self.hourHand = hourHand;
    UIImageView *minHand = [self createImageViewWithName:@"clock_min"];
    minHand.center = center;
    [clockView addSubview:minHand];
    self.minHand = minHand;
    UIImageView *secHand = [self createImageViewWithName:@"clock_sec"];
    secHand.center = center;
    [clockView addSubview:secHand];
    self.secHand = secHand;
    
    self.secHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial hand positions
    [self updateHandsAnimated:NO];
#endif
    
    
    
#if kPartEnabled == 3
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
    
    //清单8.5 使用CAKeyframeAnimation应用一系列颜色的变化
    //create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 3.0;
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
    
#endif
    
    
    
#if kPartEnabled == 4
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(30, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(30, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto; //图层将会根据曲线的切线自动旋转
    animation.repeatCount = 10;
    [shipLayer addAnimation:animation forKey:nil];
    
#endif
    
    
    
    /**
      *  虚拟属性
     
        用transform.rotation而不是transform做动画的好处如下：
     
        我们可以不通过关键帧一步旋转多于180度的动画。
        可以用相对值而不是绝对值旋转（设置byValue而不是toValue）。
        可以不用创建CATransform3D，而是使用一个简单的数值来指定角度。
        不会和transform.position或者transform.scale冲突（同样是使用关键路径来做独立的动画属性）。
     */
    //transform.rotation属性有一个奇怪的问题是它其实并不存在。这是因为CATransform3D并不是一个对象，它实际上是一个结构体，也没有符合KVC相关属性，transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性。
    //你不可以直接设置transform.rotation或者transform.scale，他们不能被直接使用。当你对他们做动画时，Core Animation自动地根据通过CAValueFunction来计算的值来更新transform属性。
    //CAValueFunction看起来似乎是对那些不能简单相加的属性（例如变换矩阵）做动画的非常有用的机制，但由于CAValueFunction的实现细节是私有的，所以目前不能通过继承它来自定义。你可以通过使用苹果目前已经提供的常量（目前都是和变换矩阵的虚拟属性相关，所以没太多使用场景了，因为这些属性都有了默认的实现方式）。
    
#if kPartEnabled == 5
    
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 128, 128);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    //虚拟属性
//    animation.keyPath = @"transform.rotation";
    //等效
    animation.keyPath = @"transform";
    animation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    [shipLayer addAnimation:animation forKey:nil];
    
#endif
    
    
    
}

- (void)tick
{
    [self updateHandsAnimated:YES];
}

- (void)updateHandsAnimated:(BOOL)animated
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
//    NSInteger sec = components.second;
//    NSInteger min = components.minute;
//    NSInteger hour = components.hour;
//    
//    //sec
//    //360/60=6°，1sec = 6°
//    CGFloat secAngle = sec*6;
//    //min
//    //360/60=6°，1min = 6°
//    //    CGFloat minAngle = components.minute*6 + components.second/60.0*6;
//    CGFloat minAngle = min*6 + sec/10.0;
//    //hour
//    //360/12=30°，1hour = 30°
//    CGFloat hourAngle = (hour+min/60.0+sec/3600.0) *30;
//    
//    //rotate hands
//    [self setAngle:DEGREES_TO_RADIANS(hourAngle) forHand:self.hourHand animated:animated];
//    [self setAngle:DEGREES_TO_RADIANS(minAngle) forHand:self.minHand animated:animated];
//    [self setAngle:DEGREES_TO_RADIANS(secAngle) forHand:self.secHand animated:animated];
    
    
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minuteAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secondAngle = (components.second / 60.0) * M_PI * 2.0;
    
    //rotate hands
    [self setAngle:hourAngle forHand:self.hourHand animated:animated];
    [self setAngle:minuteAngle forHand:self.minHand animated:animated];
    [self setAngle:secondAngle forHand:self.secHand animated:animated];
}
- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated
{
    //generate transform
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    if (animated) {
        //create transform animation
        CABasicAnimation *animation = [CABasicAnimation animation];
//        [self updateHandsAnimated:NO];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.delegate = self;
//        animation.duration = 1.0;
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1]; //指针抖动
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        //set transform directly
        handView.layer.transform = transform;
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#if kPartEnabled == 1
    //create a new random color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
//    animation.removedOnCompletion = NO;
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:@"mykey"];
#endif 
    
    
    
    
}
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
#if kPartEnabled == 1
    NSLog(@"%@", anim);
    //想要在animationDidStop回调中使用animationForKey获取对应动画对象，需要设置animation.removedOnCompletion = NO，否则在动画执行结束时，对应动画已经释放了。
    NSLog(@"%@", [self.colorLayer animationForKey:@"mykey"]);
    NSLog(@"%@", self.colorLayer.animationKeys);
    
    //set the backgroundColor property to match animation toValue
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //当更新属性的时候，我们需要设置一个新的事务，并且禁用图层行为。否则动画会发生两次，一个是因为显式的CABasicAnimation，另一次是因为隐式动画
    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
#endif
    
    
    
#if kPartEnabled == 2
    //set final position for hand view
    UIView *handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
#endif
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private
- (UIImageView *)createImageViewWithName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.bounds = CGRectMake(0, 0, imageView.image.size.width*0.4, imageView.image.size.height*0.4);
    
    return imageView;
}

@end
