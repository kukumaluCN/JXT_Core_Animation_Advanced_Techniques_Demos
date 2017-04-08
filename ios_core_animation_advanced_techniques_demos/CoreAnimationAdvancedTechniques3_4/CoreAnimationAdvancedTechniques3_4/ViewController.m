//
//  ViewController.m
//  CoreAnimationAdvancedTechniques3_4
//
//  Created by JXT on 2016/12/6.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kPartEnabled 2


@interface ViewController ()
@property (nonatomic, strong) UIView * layerView;
@property (nonatomic, strong) CALayer * blueLayer;

@property (nonatomic, strong) CALayer * layer1;
@property (nonatomic, strong) CALayer * layer2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //最好使用图层相关视图，而不是创建独立的图层关系。其中一个原因就是要处理额外复杂的触摸事件。
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    self.layerView = layerView;
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [layerView.layer addSublayer:blueLayer];
    self.blueLayer = blueLayer;
    
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(100, 400, 100, 100);
    layer1.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:layer1];
    self.layer1 = layer1;
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(150, 450, 100, 100);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer2];
    self.layer2 = layer2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
//    NSLog(@"1.%@", NSStringFromCGPoint(point));
    
    
    //-containsPoint:接受一个在本图层坐标系下的CGPoint，如果这个点在图层frame范围内就返回YES。如清单3.4所示第一章的项目的另一个合适的版本，也就是使用-containsPoint:方法来判断到底是白色还是蓝色的图层被触摸了 （图3.10）。这需要把触摸坐标转换成每个图层坐标系下的坐标，结果很不方便。
    
#if kPartEnabled == 1
    //清单3.4 使用containsPoint判断被点击的图层
    
    //convert point to the white layer's coordinates
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
//    point = [self.view.layer convertPoint:point toLayer:self.layerView.layer];//等效
    //from:  目标图层 convert 原图层的点 from 原图层
    //to:    原图层  convert 原图层的点 to 目标图层
    NSLog(@"2.%@", NSStringFromCGPoint(point));

    //get layer using containsPoint:
    if ([self.layerView.layer containsPoint:point])
    {
        //convert point to blueLayer’s coordinates
        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
        
        if ([self.blueLayer containsPoint:point])
        {
            NSLog(@"点击-blueLayer");
        }
        else
        {
            NSLog(@"点击-layerView");
        }
    }
#endif
    
    
    
#if kPartEnabled == 2
    //-hitTest:方法同样接受一个CGPoint类型参数，而不是BOOL类型，它返回图层本身，或者包含这个坐标点的叶子节点图层。这意味着不再需要像使用-containsPoint:那样，人工地在每个子图层变换或者测试点击的坐标。如果这个点在最外面图层的范围之外，则返回nil。
    
    //清单3.5 使用hitTest判断被点击的图层
    
    //get touched layer
    CALayer *layer = [self.layerView.layer hitTest:point];
    
    //get layer using hitTest
    if (layer == self.layerView.layer)
    {
        NSLog(@"点击-layerView");
    }
    else if (layer == self.blueLayer)
    {
        NSLog(@"点击-blueLayer");
    }
    
    
    static BOOL flag = NO;
    
    
    //注意当调用图层的-hitTest:方法时，测算的顺序严格依赖于图层树当中的图层顺序（和UIView处理事件类似）。之前提到的zPosition属性可以明显改变屏幕上图层的顺序，但不能改变事件传递的顺序。
    //这意味着如果改变了图层的z轴顺序，你会发现将不能够检测到最前方的视图点击事件，这是因为被另一个图层遮盖住了，虽然它的zPosition值较小，但是在图层树中的顺序靠前。我们将在第五章详细讨论这个问题。???
    CALayer *touchLayer = [self.view.layer hitTest:point];
    if (touchLayer == self.layer1)
    {
        NSLog(@"点击-layer1-绿色");
    }
    else if (touchLayer == self.layer2)
    {
        NSLog(@"点击-layer2-红色");
    }
    else
    {
        flag = !flag;
        self.layer1.zPosition = flag;
    }
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
