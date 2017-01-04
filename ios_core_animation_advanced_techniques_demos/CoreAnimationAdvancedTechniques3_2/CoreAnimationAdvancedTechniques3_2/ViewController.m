//
//  ViewController.m
//  CoreAnimationAdvancedTechniques3_2
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

@property (nonatomic, strong) UIView * layerView;

@property (nonatomic, strong) UIImageView * hourHand;
@property (nonatomic, strong) UIImageView * minHand;
@property (nonatomic, strong) UIImageView * secHand;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 200)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 200);
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    _layerView = layerView;
    
    NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(layerView.frame), NSStringFromCGRect(layerView.bounds), NSStringFromCGPoint(layerView.center));
    NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(layerView.layer.frame), NSStringFromCGRect(layerView.layer.bounds), NSStringFromCGPoint(layerView.layer.position));
    
    
    // anchorPoint 可以通过指定x和y 值小于0或者大于1，使它放置在图层范围之外。
    
    
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
    [self tick];
}

- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
////    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
////    //calculate hour hand angle //calculate minute hand angle
////    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
////    //calculate second hand angle
////    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
////    //rotate hands
//    
//    //calculate second hand angle
////    CGFloat secsAngle = (components.second / 60.0)*M_PI*2.0;
//    CGFloat secsAngle = kDegreesToRadian(components.second*6);
//    
//    //calculate minute hand angle//360/60=6°
////    CGFloat minsAngle = (components.minute / 60.0)*M_PI*2.0 + kDegreesToRadian(6*(components.second/60.0));
////    CGFloat minsAngle = kDegreesToRadian(components.minute*6) + kDegreesToRadian(components.second/10.0);
//    CGFloat minsAngle = kDegreesToRadian(components.minute*6) + secsAngle/60.0;
//
//    
//    //calculate hour hand angle
////    CGFloat hoursAngle = (components.hour / 12.0)*M_PI*2.0;
//    CGFloat hoursAngle = kDegreesToRadian(components.hour*30) + kDegreesToRadian(components.minute/2.0);
//    
//    //rotate hands
//    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
//    self.minHand.transform = CGAffineTransformMakeRotation(minsAngle);
//    self.secHand.transform = CGAffineTransformMakeRotation(secsAngle);
    
    
    NSInteger sec = components.second;
    NSInteger min = components.minute;
    NSInteger hour = components.hour;
    
    //sec
    //360/60=6°，1sec = 6°
    CGFloat secAngle = sec*6;
    //min
    //360/60=6°，1min = 6°
//    CGFloat minAngle = components.minute*6 + components.second/60.0*6;
    CGFloat minAngle = min*6 + sec/10.0;
    //hour
    //360/12=30°，1hour = 30°
    CGFloat hourAngle = (hour+min/60.0+sec/3600.0) *30;
    
    //rotate hands
    self.hourHand.transform = CGAffineTransformMakeRotation(kDegreesToRadian(hourAngle));
    self.minHand.transform = CGAffineTransformMakeRotation(kDegreesToRadian(minAngle));
    self.secHand.transform = CGAffineTransformMakeRotation(kDegreesToRadian(secAngle));
}

- (UIImageView *)createImageViewWithName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.bounds = CGRectMake(0, 0, imageView.image.size.width*0.4, imageView.image.size.height*0.4);
    
    return imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL flag = NO;
    flag = !flag;
    if (flag)
    {
        self.layerView.layer.anchorPoint = CGPointMake(0, 0);
        NSLog(@"anchorPoint = CGPointMake(0, 0)");
        NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(self.layerView.frame), NSStringFromCGRect(self.layerView.bounds), NSStringFromCGPoint(self.layerView.center));
        NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(self.layerView.layer.frame), NSStringFromCGRect(self.layerView.layer.bounds), NSStringFromCGPoint(self.layerView.layer.position));
    }
    else
    {
        self.layerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        NSLog(@"anchorPoint = CGPointMake(0.5, 0.5)");
        NSLog(@"\nUIView:\nframe:%@\nbounds:%@\ncenter:%@", NSStringFromCGRect(self.layerView.frame), NSStringFromCGRect(self.layerView.bounds), NSStringFromCGPoint(self.layerView.center));
        NSLog(@"\nCALayer:\nframe:%@\nbounds:%@\nposition:%@", NSStringFromCGRect(self.layerView.layer.frame), NSStringFromCGRect(self.layerView.layer.bounds), NSStringFromCGPoint(self.layerView.layer.position));
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
