//
//  ViewController.m
//  CoreAnimationAdvancedTechniques2_1
//
//  Created by JXT on 2016/12/1.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImage *image = [UIImage imageNamed:@"snowman"];
    
    /**
     *  1.contents
     */
    //清单2.1 在UIView的宿主图层中显示一张图片
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView.backgroundColor = [UIColor whiteColor];
    layerView.layer.contents = (__bridge id)image.CGImage;
    [self.view addSubview:layerView];
    
    
    /**
     *  2.contentsGravity
     */
    //图2.2 正确地设置contentsGravity的值
    //CALayer与contentMode对应的属性叫做contentsGravity，但是它是一个NSString类型，而不是像对应的UIKit部分，那里面的值是枚举。
    //和cotentMode一样，contentsGravity的目的是为了决定内容在图层的边界中怎么对齐，我们将使用kCAGravityResizeAspect，它的效果等同于UIViewContentModeScaleAspectFit，同时它还能在图层中等比例拉伸以适应图层的边界。
    //layerView.contentMode = UIViewContentModeScaleAspectFit;
    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    
    /**
     *  3.contentsScale
     */
    //图2.3 用错误的contentsScale属性显示Retina图片
    //contentsScale属性其实属于支持高分辨率（又称Hi-DPI或Retina）屏幕机制的一部分。它用来判断在绘制图层的时候应该为寄宿图创建的空间大小，和需要显示的图片的拉伸度（假设并没有设置contentsGravity属性）。
    //如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕。
    layerView.layer.contentsGravity = kCAGravityCenter;
    layerView.layer.contentsScale = 0.5;//值越小，图片越大越虚
    
    
    /**
     *  4.contentsScale
     */
    //图2.4 同样的Retina图片设置了正确的contentsScale之后
    //因为和UIImage不同，CGImage没有拉伸的概念。当我们使用UIImage类去读取我们的雪人图片的时候，他读取了高质量的Retina版本的图片。但是当我们用CGImage来设置我们的图层的内容时，拉伸这个因素在转换的时候就丢失了。
    layerView.layer.contentsScale = image.scale;
    //当用代码的方式来处理寄宿图的时候，一定要记住要手动的设置图层的contentsScale属性，否则，你的图片在Retina设备上就显示得不正确啦。
    layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    
    /**
     *  5.masksToBounds
     */
    //图2.5 使用masksToBounds来修剪图层内容
    //UIView有一个叫做clipsToBounds的属性可以用来决定是否显示超出边界的内容，CALayer对应的属性叫做masksToBounds，把它设置为YES，雪人就在边界里啦～
    layerView.layer.contentsScale = image.scale;
    layerView.layer.masksToBounds = YES;
    
    
    /**
     *  6.contentsRect
     */
    //CALayer的contentsRect属性允许我们在图层边框里显示寄宿图的一个子域。这涉及到图片是如何显示和拉伸的，所以要比contentsGravity灵活多了
    //单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）
    //点  —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一致的视觉效果。
    //像素 —— 物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系。UIImage是一个屏幕分辨率解决方案，所以指定点来度量大小。但是一些底层的图片表示如CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，他们表现出来了不同的大小。
    //单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式，当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。
    
    //默认的contentsRect是{0, 0, 1, 1}，这意味着整个寄宿图默认都是可见的，如果我们指定一个小一点的矩形，图片就会被裁剪
    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    layerView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
    
    //事实上给contentsRect设置一个负数的原点或是大于{1, 1}的尺寸也是可以的。这种情况下，最外面的像素会被拉伸以填充剩下的区域。
    layerView.layer.contentsRect = CGRectMake(0, 0, 2, 2);
    layerView.layer.contentsRect = CGRectMake(-0.2, -0.2, 1, 1);
    
    
    /**
     *  7.contentsRect图片拼合
     */
    //contentsRect在app中最有趣的地方在于一个叫做image sprites（图片拼合）的用法
    //典型地，图片拼合后可以打包整合到一张大图上一次性载入。相比多次载入不同的图片，这样做能够带来很多方面的好处：内存使用，载入时间，渲染性能等等
    //拼合不仅给app提供了一个整洁的载入方式，还有效地提高了载入性能（单张大图比多张小图载入地更快），但是如果有手动安排的话，他们还是有一些不方便的，如果你需要在一个已经创建好的品和图上做一些尺寸上的修改或者其他变动，无疑是比较麻烦的。
    NSArray *centerArr = @[@"{100, 350}", @"{300, 350}", @"{100, 500}", @"{300, 500}"];
    UIImage *spriteImage = [UIImage imageNamed:@"birdsSprites"];
    NSArray *rectArray = [self getContentRectArrayWithImage:spriteImage spriteSize:CGSizeMake(163, 133)];

    for (int i = 0; i < centerArr.count; i ++) {
        UIView *spriteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 163, 133)];
        spriteView.center = CGPointFromString(centerArr[i]);
        spriteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:spriteView];
        
        [self addSpriteImage:spriteImage withContentRect:[rectArray[i] CGRectValue] toLayer:spriteView.layer];
    }

    
    /**
     *  8.contentsCenter
     */
    //contentsCenter其实是一个CGRect，它定义了一个固定的边框和一个在图层上可拉伸的区域。
    //他工作起来的效果和UIImage里的-resizableImageWithCapInsets: 方法效果非常类似，只是它可以运用到任何寄宿图，甚至包括在Core Graphics运行时绘制的图形
    UIView *stretchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    stretchView.center = CGPointMake(kScreenWidth*0.5, 650);
    stretchView.backgroundColor = [UIColor whiteColor];
    stretchView.layer.contents = (__bridge id)[UIImage imageNamed:@"button"].CGImage;
    [self.view addSubview:stretchView];
    stretchView.layer.contentsCenter = CGRectMake(0.2, 0.2, 0.5, 0.5);
}

//
- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
