//
//  ViewController.m
//  CoreAnimationAdvancedTechniques5_1
//
//  Created by JXT on 2017/1/10.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kPartEnabled 2

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    /**
     *
     1.http://blog.csdn.net/x32sky/article/details/43523771
     2.http://blog.cocosdever.com/2016/03/11/Interpretation-of-the-relationship-between-CGAffineTransform-iOS-and-matrix/?utm_source=tuicool&utm_medium=referral
     3.http://wenku.baidu.com/link?url=aGUT9lxMuCOiiaK1f4hWdLkNzSvNEqt8UXgNMovaYHXaRHHh58C-L8J1FkKa7vopz5eMP0QIAF_JTK939JvbJAeOXZnYN818614px45g57u
     
     CGAffineTransformMake(a,b,c,d,tx,ty)
     ad缩放 bc旋转 tx,ty位移，基础的2D矩阵
     公式
     x=ax+cy+tx
     y=bx+dy+ty
     
     运算原理：原坐标设为（X,Y,1）
                 |a    b    0|
     [X, Y, 1]   |c    d    0|  =  [aX + cY + tx   bX + dY + ty   1] ;
                 |tx   ty   1|
     
     第一种：设a=d=1, b=c=0.
     [aX + cY + tx   bX + dY + ty  1] = [X  + tx  Y + ty  1];
     可见，这个时候，坐标是按照向量（tx，ty）进行平移，其实这也就是函数
     CGAffineTransform CGAffineMakeTranslation(CGFloat tx, CGFloat ty)的计算原理。
     
     第二种：设b=c=tx=ty=0.
     [aX + cY + tx   bX + dY + ty  1] = [aX   dY   1];
     可见，这个时候，坐标X按照a进行缩放，Y按照d进行缩放，a，d就是X，Y的比例系数，其实这也就是函数
     CGAffineTransform CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)的计算原理。a对应于sx，d对应于sy。
    
     第三种：设tx=ty=0，a=cosɵ，b=sinɵ，c=-sinɵ，d=cosɵ。
     [aX + cY + tx   bX + dY + ty  1] = [Xcosɵ - Ysinɵ    Xsinɵ + Ycosɵ  1] ;
     可见，这个时候，ɵ就是旋转的角度，逆时针为正，顺时针为负。其实这也就是函数
     CGAffineTransform CGAffineTransformMakeRotation(CGFloat angle)的计算原理。angle即ɵ的弧度表示。
     
     */
    
    
    UIImage *image = [UIImage imageNamed:@"snowman"];
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView.backgroundColor = [UIColor whiteColor];
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    [self.view addSubview:layerView];
    
    UIView *layerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView2.center = CGPointMake(kScreenWidth*0.5, 150);
    layerView2.backgroundColor = [UIColor whiteColor];
    layerView2.layer.contents = (__bridge id)image.CGImage;
    layerView2.layer.contentsGravity = kCAGravityResizeAspect;
    [self.view addSubview:layerView2];
 
    
#if kPartEnabled == 1
    //rotate the layer 45 degrees
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    layerView.layer.affineTransform = transform;
#endif
    
    
    //当操纵一个变换的时候，初始生成一个什么都不做的变换很重要--也就是创建一个CGAffineTransform类型的空值，矩阵论中称作单位矩阵，Core Graphics同样也提供了一个方便的常量：
    //CGAffineTransformIdentity
    
#if kPartEnabled == 2
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //create a new transform
        CGAffineTransform transform = CGAffineTransformIdentity;
        //scale by 50%
        transform = CGAffineTransformScale(transform, 0.5, 0.5);
        //rotate by 30 degrees
        transform = CGAffineTransformRotate(transform, kDegreesToRadian(30));
        //translate by 200 points
        transform = CGAffineTransformTranslate(transform, 200, 0);
        //apply transform to layer
        layerView2.layer.affineTransform = transform;
        
        
        layerView.layer.opacity = 0.3;
    });
    
    //复合变换的作用顺序应该是后一个变换会作用于前一个变换。一个变换完成之后，初始View被改变，后一个变换作用于被前一个变换改变之后的View.
    //旋转变化就是改了坐标系的原点，所以针对后面向右移动200 个像素，也是针对图层本身的坐标系，而对原坐标（左上角而言，就变成了右移100 个像素了）
    //这意味着变换的顺序会影响最终的结果，也就是说旋转之后的平移和平移之后的旋转结果可能不同。
#endif
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
