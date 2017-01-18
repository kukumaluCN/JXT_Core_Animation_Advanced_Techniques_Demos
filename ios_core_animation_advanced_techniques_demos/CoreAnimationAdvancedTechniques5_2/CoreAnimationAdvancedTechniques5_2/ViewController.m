//
//  ViewController.m
//  CoreAnimationAdvancedTechniques5_2
//
//  Created by JXT on 2017/1/11.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 6

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    /**
     *  
     CATransform3D
     
     struct CATransform3D
     {
        CGFloat m11, m12, m13, m14;
        CGFloat m21, m22, m23, m24;
        CGFloat m31, m32, m33, m34;
        CGFloat m41, m42, m43, m44;
     };
     The identity transform: [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
     
     CGPoint + zPosition
     运算原理：原坐标设为（X, Y, Z, 1）
     
     书中的写法，貌似是转置之后的，这样算不正确
             |m11 m21 m31 m41|
[X, Y, Z, 1] |m12 m22 m32 m42| = [m11X+m12Y+m13Z+m14 m21X+m22Y+m23Z+m24 m31X+m32Y+m33Z+m34 m41+m42+m43+m44] ;
             |m13 m23 m33 m43|
             |m14 m24 m34 m44|
     
     
     将其转置之后，就对了
             |m11 m12 m13 m14|
[X, Y, Z, 1] |m21 m22 m23 m24| = [m11X+m21Y+m31Z+m41 m12X+m22Y+m32Z+m42 m13X+m23Y+m33Z+m43 m14+m24+m34+m44] ;
             |m31 m32 m33 m34|
             |m41 m42 m43 m44|
     
     这里的CATransform3D矩阵貌似做了转置处理，原因不明，如果按照图中的计算，结果就是[m11X+m12Y+m13Z+m14 m21X+m22Y+m23Z+m24 m31X+m32Y+m33Z+m34 m41+m42+m43+m44]，这和实际使用中是不相符的，如果将图中的矩阵再次转置回来，计算的结果为[m11X+m21Y+m31Z+m41 m12X+m22Y+m32Z+m42 m13X+m23Y+m33Z+m43 m14+m24+m34+m44]，这才是实际使用中对应的情况。
     
     {
     m11（x缩放）, m12（y切变）, m13（旋转）, m14（）;
     m21（x切变）, m22（y缩放）, m23（）, m24（）;
     m31（旋转）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
     m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
     };
     
     */
    
    //和CGAffineTransform矩阵类似，Core Animation提供了一系列的方法用来创建和组合CATransform3D类型的矩阵，和Core Graphics的函数类似，但是3D的平移和旋转多处了一个z参数，并且旋转函数除了angle之外多出了x,y,z三个参数，分别决定了每个坐标轴方向上的旋转：
    //CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
    //CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
    //CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
    
    UIImage *image = [UIImage imageNamed:@"snowman"];
    
    //占位对比
    UIView *layerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView2.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView2.backgroundColor = [UIColor whiteColor];
    layerView2.layer.contents = (__bridge id)image.CGImage;
    layerView2.layer.contentsGravity = kCAGravityResizeAspect;
    layerView2.layer.opacity = 0.2;
    [self.view addSubview:layerView2];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView.backgroundColor = [UIColor whiteColor];
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    [self.view addSubview:layerView];
    
    
//    NSLog(@"%@", [NSValue valueWithCATransform3D:layerView.layer.transform]);
    NSLog(@"layerView.layer.transform:");
    JXTPrintCATransform3D(layerView.layer.transform);
    NSLog(@"CATransform3DIdentity:");
    JXTPrintCATransform3D(CATransform3DIdentity);
    
#if kPartEnabled == 1
    //rotate the layer 45 degrees along the Y axis
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    layerView.layer.transform = transform;
    //看起来图层并没有被旋转，而是仅仅在水平方向上的一个压缩，是哪里出了问题呢？
    //其实完全没错，视图看起来更窄实际上是因为我们在用一个斜向的视角看它，而不是透视。
    
//    NSLog(@"%@", [NSValue valueWithCATransform3D:layerView.layer.transform]);
    JXTPrintCATransform3D(layerView.layer.transform);
#endif
    

#if kPartEnabled == 2
    /**
     *  3D矩阵原理
     */
    CATransform3D transform = layerView.layer.transform;
    
    //[m11X+m21Y+m31Z+m41 m12X+m22Y+m32Z+m42 m13X+m23Y+m33Z+m43 m14+m24+m34+m44]
    
    //1.初始 [X Y Z 1]
    transform = CATransform3DIdentity;
    
    //2.位移 [X+m41 Y+m42 Z+m43 m44]
    layerView.layer.transform = JXTTransform3DMakeTranslation(100, 100, 100);
    NSLog(@"JXTCATransform3DMakeTranslation:");
    JXTPrintCATransform3D(layerView.layer.transform);
    
    layerView.layer.transform = CATransform3DMakeTranslation(50, 50, 50);
    NSLog(@"CATransform3DMakeTranslation:");
    JXTPrintCATransform3D(layerView.layer.transform);
//    NSLog(@"%lf", layerView.layer.zPosition);
    
    //3.缩放 [m11X m22Y m33Z 1]
    layerView.layer.transform = JXTTransform3DMakeScale(0.5, 0.5, 0.5);
    NSLog(@"JXTTransform3DMakeScale:");
    JXTPrintCATransform3D(layerView.layer.transform);
    
    layerView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3);
    NSLog(@"CATransform3DMakeScale:");
    JXTPrintCATransform3D(layerView.layer.transform);
    
    //4.旋转
    //4.1.Z 平面旋转 [m11X+m21Y+m31Z+m41 m12X+m22Y+m32Z+m42 m13X+m23Y+m33Z+m43 m14+m24+m34+m44]
    //[m11X+m21Y m12X+m22Y m13X+m23Y 1]
    //[Xcosɵ - Ysinɵ    Xsinɵ + Ycosɵ  1]
    //m11=cosɵ m21=-sinɵ m12=sinɵ m22=cosɵ
    layerView.layer.transform = JXTTransform3DMakeRotationZ(DEGREES_TO_RADIANS(45));
    NSLog(@"JXTTransform3DMakeRotation:");
    JXTPrintCATransform3D(layerView.layer.transform);
    
    layerView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(30), 1, 0, 0);
    NSLog(@"CATransform3DMakeRotation:");
    JXTPrintCATransform3D(layerView.layer.transform);
    
#endif
    
    
#if kPartEnabled == 3
    //CATransform3D的m34元素，用来做透视
    //m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。
    //因为视角相机实际上并不存在，所以可以根据屏幕上的显示效果自由决定它的防止 的位置。通常500-1000就已经很好了，但对于特定的图层有时候更小或者更大的值 会看起来更舒服，减少距离的值会增强透视效果，所以一个非常微小的值会让它看 起来更加失真，然而一个非常大的值会让它基本失去透视效果
//    //create a new transform
//    CATransform3D transform = CATransform3DIdentity;
//    //apply perspective
//    transform.m34 = - 1.0 / 500.0;
//    //rotate by 45 degrees along the Y axis
//    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
//    //apply to layer
//    layerView.layer.transform = transform;
    
    layerView.layer.transform = JXTTransform3DMakePerspectiveRotation(M_PI_4, 500, 0, 1, 0);
    JXTPrintCATransform3D(layerView.layer.transform);
#endif
    
    
#if kPartEnabled == 4
    //当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
    //为了在应用中创建拟真效果的透视，这个点应该聚在屏幕中点，或者至少是包含所有3D对象的视图中点。
    //Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外，见第三章）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置
    //当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
    
    [layerView removeFromSuperview];
    [layerView2 removeFromSuperview];
    
    //清单5.6 应用sublayerTransform
    //占位对比
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    containerView.center = kScreenCenter;
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
    
    UIView *subLayerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    subLayerView1.center = CGPointMake(kScreenWidth*0.25, containerView.bounds.size.height*0.5);
    subLayerView1.backgroundColor = [UIColor whiteColor];
    subLayerView1.layer.contents = (__bridge id)image.CGImage;
    subLayerView1.layer.contentsGravity = kCAGravityResizeAspect;
    [containerView addSubview:subLayerView1];
    
    UIView *subLayerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    subLayerView2.center = CGPointMake(kScreenWidth*0.75, containerView.bounds.size.height*0.5);
    subLayerView2.backgroundColor = [UIColor whiteColor];
    subLayerView2.layer.contents = (__bridge id)image.CGImage;
    subLayerView2.layer.contentsGravity = kCAGravityResizeAspect;
    [containerView addSubview:subLayerView2];
    
    //apply perspective transform to container
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = - 1.0 / 500.0;
    containerView.layer.sublayerTransform = perspective;
    //rotate layerView1 by 45 degrees along the Y axis
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    subLayerView1.layer.transform = transform1;
    //rotate layerView2 by 45 degrees along the Y axis
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    subLayerView2.layer.transform = transform2;
#endif
    
    
#if kPartEnabled == 5
    //CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
    layerView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 1, 0);
    layerView.layer.doubleSided = NO;
    NSLog(@"CATransform3DMakeRotation:");
    JXTPrintCATransform3D(layerView.layer.transform);
#endif
    
    
#if kPartEnabled == 6
    [layerView removeFromSuperview];
    [layerView2 removeFromSuperview];
    
    //用Core Animation创建非常复杂的3D场景变得十分困难。你不能够使用图层树去创建一个3D结构的层级关系--在相同场景下的任何3D表面必须和同样的图层保持一致，这是因为每个的父视图都把它的子视图扁平化了。
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    containerView.center = kScreenCenter;
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
    
    UIView *subLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    subLayerView.center = CGPointMake(containerView.bounds.size.width*0.5, containerView.bounds.size.height*0.5);
//    subLayerView.center = kScreenCenter;
    subLayerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:subLayerView];
//    [self.view addSubview:subLayerView];
    
    
    containerView.layer.transform = JXTTransform3DMakePerspectiveRotation(M_PI_4, 500, 0, 1, 0);
    subLayerView.layer.transform = JXTTransform3DMakePerspectiveRotation(-M_PI_4, 500, 0, 1, 0);
#endif
    
}

CATransform3D JXTTransform3DMakeTranslation(CGFloat tx, CGFloat ty, CGFloat tz)
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m41 = tx;
    transform.m42 = ty;
    transform.m43 = tz;
    return transform;
}
CATransform3D JXTTransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m11 = sx;
    transform.m22 = sy;
    transform.m33 = sz;
    return transform;
}

CATransform3D JXTTransform3DMakePerspectiveRotation(CGFloat angle, CGFloat distance, CGFloat x, CGFloat y, CGFloat z)
{
    CATransform3D transform = CATransform3DIdentity;
    //正负和旋转方向有关，如果角度为正，顺时针旋转，这里应该为负值。
    transform.m34 = - 1.0 / distance;
    transform = CATransform3DRotate(transform, angle, x, y, z);
    return transform;
}
CATransform3D JXTTransform3DMakeRotationZ(CGFloat angle)
{
    CATransform3D transform = CATransform3DIdentity;
    
    //[m11X+m21Y m12X+m22Y m13X+m23Y 1]
    //[Xcosɵ - Ysinɵ    Xsinɵ + Ycosɵ  1]
    //m11=cosɵ m21=-sinɵ m12=sinɵ m22=cosɵ
    transform.m11 = cos(angle);
    transform.m21 = -sin(angle);
    transform.m12 = sin(angle);
    transform.m22 = cos(angle);
    transform.m33 = 1;
    
    return transform;
}


static inline void JXTPrintCATransform3D(CATransform3D t)
{
    NSLog(@"\n%11lf %11lf %11lf %11lf\n%11lf %11lf %11lf %11lf\n%11lf %11lf %11lf %11lf\n%11lf %11lf %11lf %11lf\n", t.m11, t.m12, t.m13, t.m14, t.m21, t.m22, t.m23, t.m24, t.m31, t.m32, t.m33, t.m34, t.m41, t.m42, t.m43, t.m44);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
