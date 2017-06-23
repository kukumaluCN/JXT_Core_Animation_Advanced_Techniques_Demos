//
//  ViewController.m
//  CoreAnimationAdvancedTechniques9_1
//
//  Created by JXT on 2017/6/13.
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

@interface ViewController () <CAAnimationDelegate>
@property (nonatomic, strong) UITextField *durationField;
@property (nonatomic, strong) UITextField *repeatField;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) CALayer *shipLayer;

@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeOffsetLabel;
@property (nonatomic, strong) UISlider *speedSlider;
@property (nonatomic, strong) UISlider *timeOffsetSlider;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //CAMediaTiming协议定义了在一段动画内用来控制逝去时间的属性的集合，CALayer和CAAnimation都实现了这个协议，所以时间可以被任意基于一个图层或者一段动画的类控制。
    
    //duration和repeatCount默认都是0。但这不意味着动画时长为0秒，或者0次，这里的0仅仅代表了“默认”，也就是0.25秒和1次
    
#if kPartEnabled == 1
    //清单9.1 测试duration和repeatCount
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(kScreenCenter.x, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
    
    
    UITextField *durationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    durationField.center = CGPointMake(kScreenCenter.x-80, self.shipLayer.position.y+100);
    durationField.placeholder = @"duration";
    durationField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    durationField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:durationField];
    self.durationField = durationField;
    
    UITextField *repeatField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    repeatField.center = CGPointMake(kScreenCenter.x+80, self.shipLayer.position.y+100);
    repeatField.placeholder = @"repeatCount";
    repeatField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    repeatField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:repeatField];
    self.repeatField = repeatField;
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake(0, 0, 100, 50);
    startButton.center = CGPointMake(kScreenCenter.x, self.repeatField.frame.origin.y+100);
    [startButton setTitle:@"start" forState:UIControlStateNormal];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    self.startButton = startButton;
#endif
    
    
    
    
#if kPartEnabled == 2
    //清单9.2 使用autoreverses属性实现门的摇摆
    //add the door
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, kScreenCenter.y);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed: @"Door.png"].CGImage;
    [self.view.layer addSublayer:doorLayer];
   
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
//    self.view.layer.sublayerTransform = perspective;
    
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.rotation.y";
//    animation.toValue = @(-M_PI_2);
    animation.keyPath = @"transform";
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(perspective, -M_PI_2, 0, 1, 0)];
    animation.duration = 2.0;
    animation.repeatDuration = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
    
#endif
    
    
    
    
#if kPartEnabled == 3
    /**
     *  beginTime指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）。
     
        speed是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个duration为1的动画，实际上在0.5秒的时候就已经完成了。
     
        timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。
     
        和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为2.0，把timeOffset设置为0.5，那么你的动画将从动画最后结束的地方开始，因为1秒的动画实际上被缩短到了0.5秒。然而即使使用了timeOffset让动画从结束的地方开始，它仍然播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放。
     */
    
    //清单9.3 测试timeOffset和speed属性
    //create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(30, 150)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer.position = CGPointMake(30, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
    //set initial values
    [self updateSliders];
    
    
    self.timeOffsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 150, 30)];
    self.timeOffsetLabel.text = @"timeOffset";
    [self.view addSubview:self.timeOffsetLabel];
    self.timeOffsetSlider = [[UISlider alloc] initWithFrame:CGRectMake(180, 220, 200, 50)];
    self.timeOffsetSlider.center = CGPointMake(self.timeOffsetSlider.center.x, self.timeOffsetLabel.center.y);
    [self.view addSubview:self.timeOffsetSlider];
    [self.timeOffsetSlider addTarget:self action:@selector(updateSliders) forControlEvents:UIControlEventValueChanged];
    
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 270, 150, 30)];
    self.speedLabel.text = @"speed";
    [self.view addSubview:self.speedLabel];
    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(180, 270, 200, 50)];
    self.speedSlider.center = CGPointMake(self.speedSlider.center.x, self.speedLabel.center.y);
    [self.view addSubview:self.speedSlider];
    [self.speedSlider addTarget:self action:@selector(updateSliders) forControlEvents:UIControlEventValueChanged];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake(0, 0, 100, 50);
    startButton.center = CGPointMake(kScreenCenter.x, 350);
    [startButton setTitle:@"play" forState:UIControlStateNormal];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    self.startButton = startButton;
    
#endif
    
    
    
    
    
    /**
     *  另一种可能是保持动画开始之前那一帧，或者动画结束之后的那一帧。这就是所谓的填充，因为动画开始和结束的值用来填充开始之前和结束之后的时间。
        这种行为就交给开发者了，它可以被CAMediaTiming的fillMode来控制。fillMode是一个NSString类型，可以接受如下四种常量：
        kCAFillModeForwards
        kCAFillModeBackwards
        kCAFillModeBoth
        kCAFillModeRemoved
        默认是kCAFillModeRemoved，当动画不再播放的时候就显示图层模型指定的值剩下的三种类型向前，向后或者即向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。
        这就对避免在动画结束的时候急速返回提供另一种方案（见第八章）。但是记住了，当用它来解决这个问题的时候，需要把removeOnCompletion设置为NO，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。
     */
}




#if kPartEnabled == 1
- (void)hideKeyboard
{
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

- (void)startButtonAction:(UIButton *)aSender
{
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    [self hideKeyboard];
    
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    //disable controls
    [self setControlsEnabled:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //reenable controls
    [self setControlsEnabled:YES];
}

- (void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}
#endif




#if kPartEnabled == 3
- (void)updateSliders
{
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"timeOffset = %0.2f", timeOffset];
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"speed = %0.2f", speed];
}

- (void)play
{
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.duration = 1.0;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;
    [self.shipLayer addAnimation:animation forKey:@"slide"];
}
#endif


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
