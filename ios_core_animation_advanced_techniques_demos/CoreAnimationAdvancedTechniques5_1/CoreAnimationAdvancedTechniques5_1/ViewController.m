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

#define kPartEnabled 1

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
     [X, Y, 1]   |c    d    0|  =  [aX + cY + tx   bX + dY + ty  1] ;
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
 
    
    //rotate the layer 45 degrees
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    layerView.layer.affineTransform = transform;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
