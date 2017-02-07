//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_1
//
//  Created by JXT on 2017/1/19.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 4

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //CAShapeLayer优点：
    //渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
    //高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
    //不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
    //不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
    
    
    //CAShapeLayer可以用来绘制所有能够通过CGPath来表示的形状。这个形状不一定要闭合，图层路径也不一定要不可破，事实上你可以在一个图层上绘制好几个不同的形状。
    //你可以控制一些属性比如lineWith（线宽，用点表示单位），
    //lineCap（线条结尾的样子），
    //和lineJoin（线条之间的结合点的样子）；
    //但是在图层层面你只有一次机会设置这些属性。如果你想用不同颜色或风格来绘制多个形状，就不得不为每个形状准备一个图层了。
    
    
    //扩展参考：http://blog.csdn.net/iunion/article/details/26221213
    
    
    //CAShapeLayer属性列表：
    //1.strokeColor     线颜色
    //2.fillColor       填充色
    //3.fillRule        填充规则
    //4.lineCap         线端点类型
    //5.lineJoin        线连接类型
    //6.lineWidth       线宽
    //7.lineDashPattern 线型模板 //这是一个NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度
    //8.lineDashPhase   线型模板的起始位置
    //9.miterLimit      最大斜接长度 //斜接长度指的是在两条线交汇处内角和外角之间的距离。只有lineJoin属性为kCALineJoinMiter时miterLimit才有效。边角的角度越小，斜接长度就会越大。为了避免斜接长度过长，我们可以使用 miterLimit 属性。如果斜接长度超过 miterLimit 的值，边角会以 lineJoin的 "bevel"即kCALineJoinBevel类型来显示
    //10.strokeStart/strokeEnd 部分绘线
    

    
    
#pragma mark - 4.lineCap 线端点类型/5.lineJoin 线连接类型
    
#if kPartEnabled == 1
    
    //4.lineCap         线端点类型
    //5.lineJoin        线连接类型
    
    //清单6.1 用CAShapeLayer绘制一个火柴人
    //create path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5; //stroke宽度
    
    shapeLayer.lineJoin = kCALineJoinRound;
    //线条之间的结合点的样子
    //kCALineJoinMiter 斜接（尖角）
    //kCALineJoinRound 圆角
    //kCALineJoinBevel 斜角（平切）
    
    shapeLayer.lineCap = kCALineCapRound;
    //线条结尾的样子
    //kCALineCapButt    截断
    //kCALineCapRound   圆角
    //kCALineCapSquare  方角
    
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
    
    
    //圆角矩形
    //define path parameters
    CGRect rect = CGRectMake(0, 0, 200, 200);
    CGSize radii = CGSizeMake(40, 40);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //create path
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    CAShapeLayer *cornerRectLayer = [CAShapeLayer layer];
    cornerRectLayer.frame = CGRectMake(50, 350, 200, 200);
    cornerRectLayer.backgroundColor = [UIColor yellowColor].CGColor;
    cornerRectLayer.strokeColor = [UIColor redColor].CGColor;
    cornerRectLayer.fillColor = [UIColor whiteColor].CGColor;
    cornerRectLayer.path = path2.CGPath;
    [self.view.layer addSublayer:cornerRectLayer];
#endif
    
    
    
    
#pragma mark - 3.fillRule 填充规则
    
    //理解SVG的图形填充规则:http://blog.csdn.net/cuixiping/article/details/7848369
    //SVG fill-rule property in SVG 1.1 (Second Edition):https://www.w3.org/TR/SVG/painting.html#FillProperties
    
    /**
     *   
     ‘fill-rule’ 属性用于指定使用哪一种算法去判断画布上的某区域是否属于该图形“内部” （内部区域将被填充）。对一个简单的无交叉的路径，哪块区域是“内部” 是很直观清除的。但是，对一个复杂的路径，比如自相交或者一个子路径包围另一个子路径，“内部”的理解就不那么明确了。
     ‘fill-rule’ 属性提供两种选项用于指定如何判断图形的“内部”:
     1.nonzero
     字面意思是“非零”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点情况。从0开始计数，路径从左向右穿过射线则计数加1，从右向左穿过射线则计数减1。得出计数结果后，如果结果是0，则认为点在图形外部，否则认为在内部。下图演示了nonzero规则:http://www.w3.org/TR/SVG/images/painting/fillrule-nonzero.png
     2.evenodd
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部。下图演示了evenodd 规则:http://www.w3.org/TR/SVG/images/painting/fillrule-evenodd.png
     (提示: 上述解释未指出当路径片段与射线重合或者相切的时候怎么办，因为任意方向的射线都可以，那么只需要简单的选择另一条没有这种特殊情况的射线即可。)
     */
    
#if kPartEnabled == 2
    
    #define kConditionState 4
    //1:外圆顺时针 fillRule = kCAFillRuleNonZero 无
    //2:外圆逆时针 fillRule = kCAFillRuleNonZero 中空
    //3:外圆顺时针 fillRule = kCAFillRuleEvenOdd 中空
    //4:外圆逆时针 fillRule = kCAFillRuleEvenOdd 中空
    
    /**
     *  1.
     */
    //create path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //小圆
    [path moveToPoint:CGPointMake(200, 150)];
    //内顺时针
    [path addArcWithCenter:CGPointMake(150, 150) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //大圆
    [path moveToPoint:CGPointMake(250, 150)];
#if kConditionState == 1 || kConditionState == 3
    //外顺时针
    [path addArcWithCenter:CGPointMake(150, 150) radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
#elif kConditionState == 2 || kConditionState == 4
    //外逆时针
    [path addArcWithCenter:CGPointMake(150, 150) radius:100 startAngle:0 endAngle:-2*M_PI clockwise:NO];
#endif
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    
#if kConditionState == 1 || kConditionState == 2
    shapeLayer.fillRule = kCAFillRuleNonZero;
#elif kConditionState == 3 || kConditionState == 4
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
#endif
    
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
    
    [self drawDotAtPoint:CGPointMake(200, 150)];
    [self drawDotAtPoint:CGPointMake(250, 150)];
    
    /**
     *  2.
     */
    //create path
    UIBezierPath *path2 = [[UIBezierPath alloc] init];
    [path2 moveToPoint:CGPointMake(250, 450)];
    [path2 addArcWithCenter:CGPointMake(200, 450) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path2 moveToPoint:CGPointMake(300, 450)];
    [path2 addArcWithCenter:CGPointMake(200, 450) radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path2 moveToPoint:CGPointMake(350, 450)];
    [path2 addArcWithCenter:CGPointMake(200, 450) radius:150 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //create shape layer
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor redColor].CGColor;
    shapeLayer2.fillColor = [UIColor blueColor].CGColor;
//    shapeLayer2.fillRule = kCAFillRuleNonZero;
    shapeLayer2.fillRule = kCAFillRuleEvenOdd;
    
    shapeLayer2.lineWidth = 5;
    shapeLayer2.lineJoin = kCALineJoinBevel;
    shapeLayer2.lineCap = kCALineCapRound;
    shapeLayer2.path = path2.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer2];
    
    [self drawDotAtPoint:CGPointMake(250, 450)];
    [self drawDotAtPoint:CGPointMake(300, 450)];
    [self drawDotAtPoint:CGPointMake(350, 450)];
#endif
    
    

    
    
#pragma mark - 7.lineDashPattern 线型模板
    
#if kPartEnabled == 3
    //create path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    
    shapeLayer.lineDashPattern = @[@20, @10, @10, @2];//NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度
    shapeLayer.lineDashPhase = 15;//线型模板的起始位置
    //lineDashPhase默认是0，如果设置，表示第一个绘制的长度，我原本设置为5绘制5空格，如果设置了lineDashPhase，那么第一段绘制为5-2，然后空5绘制5
    shapeLayer.lineJoin = kCALineJoinBevel;
//    shapeLayer.lineCap = kCALineCapRound;
    //    shapeLayer.strokeStart = 0.1;
    //    shapeLayer.strokeEnd = 0.6;
    shapeLayer.path = path.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
    
    
    //虚线1
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(50, 300)];
    [linePath addLineToPoint:CGPointMake(300, 300)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor redColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = 10;
    lineLayer.lineDashPattern = @[@20, @10];//NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度
    lineLayer.path = linePath.CGPath;
    [self.view.layer addSublayer:lineLayer];
    
    //虚线2
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    [linePath2 moveToPoint:CGPointMake(50, 312)];
    [linePath2 addLineToPoint:CGPointMake(300, 312)];
    
    CAShapeLayer *lineLayer2 = [CAShapeLayer layer];
    lineLayer2.strokeColor = [UIColor blueColor].CGColor;
    lineLayer2.fillColor = [UIColor clearColor].CGColor;
    lineLayer2.lineWidth = 10;
    lineLayer2.lineDashPattern = @[@20, @10];//NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度
    lineLayer2.lineDashPhase = 15;//线型模板的起始位置，相位
    lineLayer2.path = linePath2.CGPath;
    [self.view.layer addSublayer:lineLayer2];
    
#endif
    
    
    
    
#pragma mark - 10.strokeStart/strokeEnd 部分绘线
    
#if kPartEnabled == 4
    
    //create path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 5;
    //shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:10], [NSNumber numberWithInt:10], [NSNumber numberWithInt:2], nil];
    //shapeLayer.lineDashPhase = 15;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 0.0;
    shapeLayer.path = path.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
    
#ifdef __IPHONE_10_0
    __block CGFloat progress = 0.0;
    __block BOOL flag = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        shapeLayer.strokeEnd = progress;
        
        if (flag)
        {
            progress += 0.1;
            if (progress > 1.0) {
                progress = 1.0;
                flag = !flag;
            }
        }
        else
        {
            progress -= 0.1;
            if (progress < 0.0) {
                progress = 0.0;
                flag = !flag;
            }
        }
    }];
#endif
    
#endif
    
}


- (void)drawDotAtPoint:(CGPoint)point
{
    CALayer *dotLayer = [CALayer layer];
    dotLayer.backgroundColor = [UIColor yellowColor].CGColor;
    dotLayer.bounds = CGRectMake(0, 0, 10, 10);
    dotLayer.position = point;
    dotLayer.cornerRadius = 5;
    dotLayer.masksToBounds = YES;
    [self.view.layer addSublayer:dotLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
