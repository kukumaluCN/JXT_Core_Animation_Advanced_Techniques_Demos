//
//  ViewController.m
//  CoreAnimationAdvancedTechniques9_2
//
//  Created by JXT on 2017/6/23.
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
@property (nonatomic, strong) CALayer *shipLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //在第三章“图层几何学”中，你已经了解到每个图层是如何相对在图层树中的父图层定义它的坐标系的。动画时间和它类似，每个动画和图层在时间上都有它自己的层级概念，相对于它的父亲来测量。对图层调整时间将会影响到它本身和子图层的动画，但不会影响到父图层。另一个相似点是所有的动画都被按照层级组合（使用CAAnimationGroup实例）。
    
    //对CALayer或者CAGroupAnimation调整duration和repeatCount/repeatDuration属性并不会影响到子动画。但是beginTime，timeOffset和speed属性将会影响到子动画。然而在层级关系中，beginTime指定了父图层开始动画（或者组合关系中的父动画）和对象将要开始自己动画之间的偏移。类似的，调整CALayer和CAGroupAnimation的speed属性将会对动画以及子动画速度应用一个缩放的因子。
    
    
    /**
     *  CoreAnimation有一个全局时间的概念，也就是所谓的马赫时间（“马赫”实际上是iOS和Mac OS系统内核的命名）。马赫时间在设备上所有进程都是全局的--但是在不同设备上并不是全局的--不过这已经足够对动画的参考点提供便利了，你可以使用CACurrentMediaTime函数来访问马赫时间：+
     
        CFTimeInterval time = CACurrentMediaTime();
        这个函数返回的值其实无关紧要（它返回了设备自从上次启动后的秒数，并不是你所关心的），它真实的作用在于对动画的时间测量提供了一个相对值。注意当设备休眠的时候马赫时间会暂停，也就是所有的CAAnimations（基于马赫时间）同样也会暂停。
     */
    
    
    
    /**
     *  一个简单的方法是可以利用CAMediaTiming来暂停图层本身。如果把图层的speed设置成0，它会暂停任何添加到图层上的动画。类似的，设置speed大于1.0将会快进，设置成一个负值将会倒回动画。
        通过增加主窗口图层的speed，可以暂停整个应用程序的动画。这对UI自动化提供了好处，我们可以加速所有的视图动画来进行自动化测试（注意对于在主窗口之外的视图并不会被影响，比如UIAlertview）。可以在app delegate设置如下进行验证：
        self.window.layer.speed = 100;
        你也可以通过这种方式来减速，但其实也可以在模拟器通过切换慢速动画来实现。
     */
    
    
    
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL flag = NO;
    flag = !flag;
    
    //暂停
    if (flag) {
        //先转换出时间，不能直接用CACurrentMediaTime()，它一直在变，不能先设置speed，会导致转换出错
//        self.shipLayer.timeOffset = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil];
//        self.shipLayer.speed = 0;
        CFTimeInterval pausedTime = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.shipLayer.speed = 0.0;
        self.shipLayer.timeOffset = pausedTime;
    }
    //恢复
    else {
        CFTimeInterval pausedTime = [self.shipLayer timeOffset];
        self.shipLayer.speed = 1.0;
        self.shipLayer.timeOffset = 0.0;
        self.shipLayer.beginTime = 0.0; //清空一次
        CFTimeInterval timeSincePause = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.shipLayer.beginTime = timeSincePause;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
