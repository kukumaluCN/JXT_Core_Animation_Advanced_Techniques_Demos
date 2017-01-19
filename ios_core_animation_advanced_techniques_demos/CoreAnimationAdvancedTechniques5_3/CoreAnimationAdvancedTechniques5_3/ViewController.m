//
//  ViewController.m
//  CoreAnimationAdvancedTechniques5_3
//
//  Created by JXT on 2017/1/13.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import <GLKit/GLKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 1

static CGFloat const kSideLength = 200.0;

@interface ViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray * faces;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //构建6个面
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        UIView *faceView = [self faceViewWithIndexNumber:i];
        [array addObject:faceView];
    }
    self.faces = [NSArray arrayWithArray:array];
    
    
    //正方体容器
    self.containerView = ({
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSideLength, kSideLength)];
        containerView.center = kScreenCenter;
        containerView;
    });
    [self.view addSubview:self.containerView];
    
    
    //构建正方体
    //set up the container sublayer transform
    /*__block*/ CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;//透视
    self.containerView.layer.sublayerTransform = perspective;//作用于所有子图层
    
    CGFloat kSideLengthHalf = kSideLength*0.5;
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, kSideLengthHalf);//面向用户前移边长一半100
//    [self addFace:0 withTransform:transform];
//    //add cube face 2
//    transform = CATransform3DMakeTranslation(kSideLengthHalf, 0, 0);//右移300
//    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);//y旋转90
//    [self addFace:1 withTransform:transform];
//    //add cube face 3
//    transform = CATransform3DMakeTranslation(0, -kSideLengthHalf, 0);//上移300
//    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);//x旋转90
//    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, kSideLengthHalf, 0);//下移300
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);//x旋转-90
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-kSideLengthHalf, 0, 0);//左移300
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);//y旋转-90
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -kSideLengthHalf);//面向用户后移300
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);//y旋转180
    [self addFace:5 withTransform:transform];
    
    //add cube face 1
    transform = CATransform3DMakeTranslation(0, 0, kSideLengthHalf);//面向用户前移边长一半100
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(kSideLengthHalf, 0, 0);//右移300
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);//y旋转90
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -kSideLengthHalf, 0);//上移300
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);//x旋转90
    [self addFace:2 withTransform:transform];
    
    //对相机（或者相对相机的整个场景，你也可以这么认为）绕Y轴旋转45度，并且绕X轴旋转45度。现在从另一个角度去观察立方体，就能看出它的真实面貌
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);//x -45
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);//y -45
    self.containerView.layer.sublayerTransform = perspective;//作用于所有子图层
    
//    __block CGFloat angle = 0;
//    [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        angle += 1;
//        if (angle > 360) {
//            angle = 0;
//        }
////        perspective = CATransform3DRotate(perspective, DEGREES_TO_RADIANS(angle), 1, 0, 0);//x -45
//        perspective = CATransform3DRotate(perspective, DEGREES_TO_RADIANS(angle), 0, 1, 0);//y -45
//        
//        self.containerView.layer.sublayerTransform = perspective;//作用于所有子图层
//    }];
    
    
    
    //点击事件
    //在第三章中我们简要提到过，点击事件的处理由视图在父视图中的顺序决定的，并不是3D空间中的Z轴顺序。当给立方体添加视图的时候，我们实际上是按照一个顺序添加，所以按照视图/图层顺序来说，4，5，6在3的前面。
    //即使我们看不见4，5，6的表面（因为被1，2，3遮住了），iOS在事件响应上仍然保持之前的顺序。当试图点击表面3上的按钮，表面4，5，6截断了点击事件（取决于点击的位置），这就和普通的2D布局在按钮上覆盖物体一样。

    //视图中图层添加的层级顺序会比屏幕上显示的顺序更有意义。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UI
#pragma mark 正方体面
static NSInteger const kFaceButtonTagBase = 1000;
- (UIView *)faceViewWithIndexNumber:(NSInteger)index
{
    UIView *faceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSideLength, kSideLength)];
    faceView.backgroundColor = [UIColor whiteColor];
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceBtn setTitle:[NSString stringWithFormat:@"%zd", index+1] forState:UIControlStateNormal];
    [faceBtn setTitleColor:[self randomColor] forState:UIControlStateNormal];
    faceBtn.backgroundColor = [UIColor whiteColor];
    [faceBtn addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    faceBtn.bounds = CGRectMake(0, 0, 100, 100);
    faceBtn.center = CGPointMake(faceView.bounds.size.width*0.5, faceView.bounds.size.height*0.5);
    faceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:50];
    faceBtn.tag = kFaceButtonTagBase + index + 1;
    faceBtn.layer.cornerRadius = 10;
    faceBtn.layer.borderColor = [UIColor blackColor].CGColor;
    faceBtn.layer.borderWidth = 0.5;
    [faceView addSubview:faceBtn];
    
    return faceView;
}
- (void)faceButtonAction:(UIButton *)aSender
{
    NSInteger index = aSender.tag - kFaceButtonTagBase;
    NSLog(@"按钮序号：%zd", index);
}
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0f];
}
#pragma mark 正方体构建
- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    //get the face view and add it to the container
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    //center the face view within the container
    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width*0.5, containerSize.height*0.5);
    
    // apply the transform
    face.layer.transform = transform;
    
    //apply lighting
    [self applyLightingToFace:face.layer];
}


//清单5.10 对立方体的表面应用动态的光线效果
#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.3
#define kFloat(_num_) (float)(_num_)
- (void)applyLightingToFace:(CALayer *)face
{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    
    //“GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;”语句并不能做到正确的转换，会导致整体失效。恰当的做法是：“GLKMatrix4 matrix4 = GLKMatrix4Make(kFloat(transform.m11), kFloat(transform.m12), kFloat(transform.m13), kFloat(transform.m14), kFloat(transform.m21), kFloat(transform.m22), kFloat(transform.m23), kFloat(transform.m24), kFloat(transform.m31), kFloat(transform.m32), kFloat(transform.m33), kFloat(transform.m34), kFloat(transform.m41), kFloat(transform.m42), kFloat(transform.m43), kFloat(transform.m44));”，其中kFloat宏只是做了一个float的强制类型转换。
//    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix4 matrix4 = GLKMatrix4Make(kFloat(transform.m11), kFloat(transform.m12), kFloat(transform.m13), kFloat(transform.m14), kFloat(transform.m21), kFloat(transform.m22), kFloat(transform.m23), kFloat(transform.m24), kFloat(transform.m31), kFloat(transform.m32), kFloat(transform.m33), kFloat(transform.m34), kFloat(transform.m41), kFloat(transform.m42), kFloat(transform.m43), kFloat(transform.m44));
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}


@end
