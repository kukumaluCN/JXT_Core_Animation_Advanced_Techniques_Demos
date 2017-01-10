//
//  ViewController.m
//  CoreAnimationAdvancedTechniques4_5
//
//  Created by JXT on 2017/1/5.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kPartEnabled 1


@interface ViewController ()
@property (nonatomic, strong) NSArray <NSValue *>* rectArray;
@property (nonatomic, strong) UIView * bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //换句话说，线性过滤保留了形状，最近过滤则保留了像素的差异。
    
    
//    UIImage *spriteImage = [UIImage imageNamed:@"digit_small"];
//    NSArray *rectArray = [self getContentRectArrayWithImage:spriteImage spriteSize:CGSizeMake(20, 33)];
    
    UIImage *spriteImage = [UIImage imageNamed:@"digit_black"];
    NSArray *rectArray = [self getContentRectArrayWithImage:spriteImage spriteSize:CGSizeMake(180, 248)];
    self.rectArray = rectArray;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.bounds = CGRectMake(0, 0, 320, 88);
    bgView.center = CGPointMake(kScreenWidth*0.5, 300);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    NSArray *centerArr = @[@"{0, 0}", @"{50, 0}", @"{110, 0}", @"{160, 0}", @"{220, 0}", @"{270, 0}"];
    for (int i = 0; i < 6; i ++) {
        UIView *spriteView = [[UIView alloc] initWithFrame:CGRectMake(CGPointFromString(centerArr[i]).x, 0, 50, 88)];
        spriteView.backgroundColor = [UIColor whiteColor];
        spriteView.layer.contents = (__bridge id)spriteImage.CGImage;
        spriteView.layer.contentsGravity = kCAGravityResizeAspect;
        spriteView.layer.magnificationFilter = kCAFilterNearest;
        [bgView addSubview:spriteView];
        
        [self setDigit:8 forView:spriteView];
    }
    
    //start timer
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    //set initial clock time
    [self tick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    //set hours
    [self setDigit:components.hour / 10 forView:self.bgView.subviews[0]];
    [self setDigit:components.hour % 10 forView:self.bgView.subviews[1]];
    
    //set minutes
    [self setDigit:components.minute / 10 forView:self.bgView.subviews[2]];
    [self setDigit:components.minute % 10 forView:self.bgView.subviews[3]];
    
    //set seconds
    [self setDigit:components.second / 10 forView:self.bgView.subviews[4]];
    [self setDigit:components.second % 10 forView:self.bgView.subviews[5]];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    NSArray *rectArray = self.rectArray;
//    NSInteger index = digit-1;
//    if (index < 0) {
//        index = rectArray.count-1;
//    }
//    else if (index > 8) {
//        index = 8;
//    }
    NSInteger index = digit;
    if (index < 0) {
        index = 0;
    }
    else if (index > 9) {
        index = 9;
    }
    view.layer.contentsRect = [rectArray[index] CGRectValue];
}
//行列输出
- (NSArray *)getContentRectArrayWithImage:(UIImage *)image spriteSize:(CGSize)spriteSize
{
    if (!image || CGSizeEqualToSize(spriteSize, CGSizeZero)) return nil;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat rectWidth = spriteSize.width/width;
    CGFloat rectHeight = spriteSize.height/height;
    
    int lineWNum = width/spriteSize.width+0.5;
    int lineHNum = height/spriteSize.height+0.5;
    
    NSMutableArray *rectArr = [NSMutableArray array];
    for (int j = 0; j < lineHNum; j ++)//先列
    {
        CGFloat originY = j/(float)lineHNum;
        
        for (int i = 0; i < lineWNum; i ++)//再行
        {
            CGFloat originX = i/(float)lineWNum;
            
            NSValue *rectValue = [NSValue valueWithCGRect:CGRectMake(originX, originY, rectWidth, rectHeight)];
            [rectArr addObject:rectValue];
        }
    }
    
    return rectArr;
}


@end
