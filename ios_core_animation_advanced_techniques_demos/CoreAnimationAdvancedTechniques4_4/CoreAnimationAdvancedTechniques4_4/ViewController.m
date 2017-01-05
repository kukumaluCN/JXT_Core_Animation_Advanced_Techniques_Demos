//
//  ViewController.m
//  CoreAnimationAdvancedTechniques4_4
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
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) CALayer * maskLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //清单4.5 应用蒙板图层
    UIImage *image = [UIImage imageNamed:@"snowman"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 300, 300)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    //create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = imageView.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"bell"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.contentsScale = 2;
    [imageView.layer addSublayer:maskLayer];
    self.maskLayer = maskLayer;
    
    
    //mask图层定义了父图层的部分可见区域。
    //mask图层的Color属性是无关紧要的，真正重要的是图层的轮廓。mask属性就像是一个饼干切割机，mask图层实心的部分会被保留下来，其他的则会被抛弃。
    //CALayer蒙板图层真正厉害的地方在于蒙板图不局限于静态图。任何有图层构成的都可以作为 mask 属性，这意味着你的蒙板可以通过代码甚至是动画实时生成。
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL flag = NO;
    flag = !flag;
    
    if (flag) {
        self.imageView.layer.mask = self.maskLayer;
    }
    else {
        self.imageView.layer.mask = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
