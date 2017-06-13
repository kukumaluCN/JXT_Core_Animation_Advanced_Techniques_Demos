//
//  ViewController.m
//  CoreAnimationAdvancedTechniques8_3
//
//  Created by JXT on 2017/6/9.
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
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) NSArray * images;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    //默认的过渡类型是kCATransitionFade，当你在改变图层属性之后，就创建了一个平滑的淡入淡出效果。
    //我们在第七章的例子中就已经用到过kCATransitionPush，它创建了一个新的图层，从边缘的一侧滑动进来，把旧图层从另一侧推出去的效果。
    //kCATransitionMoveIn和kCATransitionReveal与kCATransitionPush类似，都实现了一个定向滑动的动画，但是有一些细微的不同，kCATransitionMoveIn从顶部滑动进入，但不像推送动画那样把老土层推走，
    //然而kCATransitionReveal把原始的图层滑动出去来显示新的外观，而不是把新的图层滑动进入。
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.center = kScreenCenter;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    //
    self.images = @[[UIImage imageNamed:@"Anchor.png"],
                    [UIImage imageNamed:@"Cone.png"],
                    [UIImage imageNamed:@"Igloo.png"],
                    [UIImage imageNamed:@"Spaceship.png"]];
    
    
    
    //对图层树的动画
    //这里用到了一个小诡计，要确保CATransition添加到的图层在过渡动画发生时不会在树状结构中被移除，否则CATransition将会和图层一起被移除。一般来说，你只需要将动画添加到被影响图层的superlayer。
    

    
    
    //过渡动画做基础的原则就是对原始的图层外观截图，然后添加一段动画，平滑过渡到图层改变之后那个截图的效果。如果我们知道如何对图层截图，我们就可以使用属性动画来代替CATransition或者是UIKit的过渡方法来实现动画。
    //这里有个警告：-renderInContext:捕获了图层的图片和子图层，但是不能对子图层正确地处理变换效果，而且对视频和OpenGL内容也不起作用。但是用CATransition，或者用私有的截屏方式就没有这个限制了。
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
#if kPartEnabled == 1
    //set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to imageview backing layer
    [self.imageView.layer addAnimation:transition forKey:nil];
    
    //cycle to next image
    UIImage *currentImage = self.imageView.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1) % [self.images count];
    self.imageView.image = self.images[index];
#endif
    
    
#if kPartEnabled == 2
    
    [UIView transitionWithView:self.imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        //cycle to next image
        UIImage *currentImage = self.imageView.image;
        NSUInteger index = [self.images indexOfObject:currentImage];
        index = (index + 1) % [self.images count];
        self.imageView.image = self.images[index];
    } completion:NULL];
    
    
    
    //清单8.14 用renderInContext:创建自定义过渡效果
    //preserve the current view snapshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    //insert snapshot view in front of this one
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    //update the view (we'll simply randomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //perform animation (anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        //scale, rotate and fade the view
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //remove the cover view now we're finished with it
        [coverView removeFromSuperview];
    }];
    
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
