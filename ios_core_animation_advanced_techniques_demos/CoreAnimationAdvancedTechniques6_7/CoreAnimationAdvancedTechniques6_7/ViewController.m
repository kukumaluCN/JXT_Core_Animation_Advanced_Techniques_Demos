//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_7
//
//  Created by JXT on 2017/2/22.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import "MyTiledLayer.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kScreenScale 2.//[UIScreen mainScreen].scale //3X有误差

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 2


@interface ViewController () <CALayerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //能高效绘制在iOS上的图片也有一个大小限制。所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048*2048，或4096*4096，这个取决于设备型号）。
    //CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。
    
    //图片
    CGSize tileImageSize = CGSizeMake(256, 256);
    
    //清单6.12 一个简单的滚动CATiledLayer实现
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tileImageSize.width, tileImageSize.height)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    scrollView.center = kScreenCenter;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    //add the tiled layer
    MyTiledLayer *tiledLayer = [MyTiledLayer layer];
//    tiledLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tiledLayer.frame = CGRectMake(0, 0, 2048./kScreenScale, 2048./kScreenScale); //适配Retina
    tiledLayer.delegate = self;
    tiledLayer.tileSize = tileImageSize; //设置元素尺寸
    tiledLayer.contentsScale = kScreenScale;
    [scrollView.layer addSublayer:tiledLayer];
    
    //configure the scroll view
    scrollView.contentSize = tiledLayer.frame.size;
    
    //draw layer
    [tiledLayer setNeedsDisplay];
    
    //CATiledLayer（不同于大部分的UIKit和Core Animation方法）支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用，所以请小心谨慎地确保你在这个方法中实现的绘制代码是线程安全的。
    

    //tileSize是以像素为单位，而不是点，所以增大了contentsScale就自动有了默认的小图尺寸（现在它是128*128的点而不是256*256）.所以，我们不需要手工更新小图的尺寸或是在Retina分辨率下指定一个不同的小图。我们需要做的是适应小图渲染代码以对应安排scale的变化
    //通过这个方法纠正scale也意味着我们的雪人图将以一半的大小渲染在Retina设备上（总尺寸是1024*1024，而不是2048*2048）。这个通常都不会影响到用CATiledLayer正常显示的图片类型（比如照片和地图，他们在设计上就是要支持放大缩小，能够在不同的缩放条件下显示），但是也需要在心里明白。

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    CGFloat scale = kScreenScale;
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width * scale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height * scale);
    
    //load tile image
    NSString *imageName = [NSString stringWithFormat:@"Snowman_%02zd_%02zd", x, y];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tiledImage = [UIImage imageWithContentsOfFile:imagePath];
    
    //draw tile
    UIGraphicsPushContext(ctx);
    [tiledImage drawInRect:bounds];
    UIGraphicsPopContext();
}


@end
