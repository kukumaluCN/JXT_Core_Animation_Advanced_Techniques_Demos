//
//  ViewController.m
//  CoreAnimationAdvancedTechniques11_1
//
//  Created by JXT on 2017/6/27.
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
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;

#if kPartEnabled == 1
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
#endif

#if kPartEnabled == 2
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval timeOffset;
@property (nonatomic, assign) CFTimeInterval lastStep;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
#endif
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    
    /**
     *  NSTimer并不是最佳方案，为了理解这点，我们需要确切地知道NSTimer是如何工作的。iOS上的每个线程都管理了一个NSRunloop，字面上看就是通过一个循环来完成一些任务列表。但是对主线程，这些任务包含如下几项：
            处理触摸事件
            发送和接受网络数据包
            执行使用gcd的代码
            处理计时器行为
            屏幕重绘
        当你设置一个NSTimer，他会被插入到当前任务列表中，然后直到指定时间过去之后才会被执行。但是何时启动定时器并没有一个时间上限，而且它只会在列表中上一个任务完成之后开始执行。这通常会导致有几毫秒的延迟，但是如果上一个任务过了很久才完成就会导致延迟很长一段时间。
        屏幕重绘的频率是一秒钟六十次，但是和定时器行为一样，如果列表中上一个执行了很长时间，它也会延迟。这些延迟都是一个随机值，于是就不能保证定时器精准地一秒钟执行六十次。有时候发生在屏幕重绘之后，这就会使得更新屏幕会有个延迟，看起来就是动画卡壳了。有时候定时器会在屏幕更新的时候执行两次，于是动画看起来就跳动了。
        我们可以通过一些途径来优化：
            我们可以用CADisplayLink让更新频率严格控制在每次屏幕刷新之后。
            基于真实帧的持续时间而不是假设的更新频率来做动画。
            调整动画计时器的run loop模式，这样就不会被别的事件干扰。
     */
    
    
    
    
    
    
    /**
     *  CADisplayLink
     
        CADisplayLink是CoreAnimation提供的另一个类似于NSTimer的类，它总是在屏幕完成一次更新之前启动，它的接口设计的和NSTimer很类似，所以它实际上就是一个内置实现的替代，但是和timeInterval以秒为单位不同，CADisplayLink有一个整型的frameInterval属性，指定了间隔多少帧之后才执行。默认值是1，意味着每次屏幕更新之前都会执行一次。但是如果动画的代码执行起来超过了六十分之一秒，你可以指定frameInterval为2，就是说动画每隔一帧执行一次（一秒钟30帧）或者3，也就是一秒钟20次，等等。
        用CADisplayLink而不是NSTimer，会保证帧率足够连续，使得动画看起来更加平滑，但即使CADisplayLink也不能保证每一帧都按计划执行，一些失去控制的离散的任务或者事件（例如资源紧张的后台程序）可能会导致动画偶尔地丢帧。当使用NSTimer的时候，一旦有机会计时器就会开启，但是CADisplayLink却不一样：如果它丢失了帧，就会直接忽略它们，然后在下一次更新的时候接着运行。
     */
    
    
    
    
    /**
     *  无论是使用NSTimer还是CADisplayLink，我们仍然需要处理一帧的时间超出了预期的六十分之一秒。由于我们不能够计算出一帧真实的持续时间，所以需要手动测量。我们可以在每帧开始刷新的时候用CACurrentMediaTime()记录当前时间，然后和上一帧记录的时间去比较。
        通过比较这些时间，我们就可以得到真实的每帧持续的时间，然后代替硬编码的六十分之一秒。我们来更新一下上个例子（见清单11.2）。
     */
    
    
    
    /**
     *  Run Loop 模式
     
        注意到当创建CADisplayLink的时候，我们需要指定一个run loop和run loop mode，对于run loop来说，我们就使用了主线程的run loop，因为任何用户界面的更新都需要在主线程执行，但是模式的选择就并不那么清楚了，每个添加到run loop的任务都有一个指定了优先级的模式，为了保证用户界面保持平滑，iOS会提供和用户界面相关任务的优先级，而且当UI很活跃的时候的确会暂停一些别的任务。
        一个典型的例子就是当是用UIScrollview滑动的时候，重绘滚动视图的内容会比别的任务优先级更高，所以标准的NSTimer和网络请求就不会启动，一些常见的run loop模式如下：
     
            NSDefaultRunLoopMode - 标准优先级
            NSRunLoopCommonModes - 高优先级
            UITrackingRunLoopMode - 用于UIScrollView和别的控件的动画
        
        在我们的例子中，我们是用了NSDefaultRunLoopMode，但是不能保证动画平滑的运行，所以就可以用NSRunLoopCommonModes来替代。但是要小心，因为如果动画在一个高帧率情况下运行，你会发现一些别的类似于定时器的任务或者类似于滑动的其他iOS动画会暂停，直到动画结束。
        同样可以同时对CADisplayLink指定多个run loop模式，于是我们可以同时加入NSDefaultRunLoopMode和UITrackingRunLoopMode来保证它不会被滑动打断，也不会被其他UIKit控件动画影响性能，像这样：
        self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
        [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
     */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [(NSValue *)fromValue objCType];
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



//清单11.1 使用NSTimer实现弹性球动画
#if kPartEnabled == 1
- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                                  target:self
                                                selector:@selector(step:)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void)step:(NSTimer *)step
{
    //update time offset
    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue
                                     toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#endif




//清单11.2 通过测量每帧持续的时间来使得动画更加平滑
#if kPartEnabled == 2
- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}

- (void)step:(CADisplayLink *)timer
{
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    //update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
