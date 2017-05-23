//
//  ViewController.m
//  CoreAnimationAdvancedTechniques7_3
//
//  Created by JXT on 2017/4/9.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import "LayerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kScreenScale [UIScreen mainScreen].scale

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 2


@interface ViewController ()
@property (nonatomic, strong) LayerView * layerView;
@property (nonatomic, strong) CALayer * colorLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //1.Changing a Layer’s Default Behavior
    //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/ReactingtoLayerChanges/ReactingtoLayerChanges.html#//apple_ref/doc/uid/TP40004514-CH7-SW1
    //2.View-Layer 协作
    //https://objccn.io/issue-12-4/
    

    //试想一下，如果UIView的属性都有动画特性的话，那么无论在什么时候修改它，我们都应该能注意到的。所以，如果说UIKit建立在Core Animation（默认对所有东西都做动画）之上，那么隐式动画是如何被UIKit禁用掉呢？
    //我们知道Core Animation通常对CALayer的所有属性（可动画的属性）做动画，但是UIView把它关联的图层的这个特性关闭了。为了更好说明这一点，我们需要知道隐式动画是如何实现的。
    
    
    //UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
    //对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画。
    
    
    LayerView *layerView = [[LayerView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = CGPointMake(kScreenCenter.x, kScreenCenter.y - 200);
    layerView.layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view addSubview:layerView];
    self.layerView = layerView;
    
    
    //清单7.6 实现自定义行为
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    self.colorLayer.position = CGPointMake(kScreenCenter.x, layerView.center.y + 200);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
    
    NSLog(@"%@", self.view.layer.delegate);
    NSLog(@"%@", self.colorLayer.delegate);
    
    
    /**
     *  @property(nonatomic, readonly, strong) CALayer *layer;
        
        Description
        The view’s Core Animation layer used for rendering.
        This property is never nil. The actual class of the object is determined by the value returned in the layerClass property. The view is the layer’s delegate.
       
        Warning
        Because the view is the layer’s delegate, never make the view the delegate of another CALayer object. Additionally, never change the delegate of this layer object.
     */
    
    
    //这正是我们所看到的行为；当一个属性在动画 block 之外被改变时，没有动画，但是当属性在动画 block 内被改变时，就带上了动画。对于这是如何发生的这一问题的答案十分简单和优雅，它优美地阐明和揭示了 view 和 layer 之间是如何协同工作和被精心设计的。
    //无论何时一个可动画的 layer 属性改变时，layer 都会寻找并运行合适的 'action' 来实行这个改变。在 Core Animation 的专业术语中就把这样的动画统称为动作 (action，或者 CAAction)。
    //CAAction：技术上来说，这是一个接口，并可以用来做各种事情。但是实际中，某种程度上你可以只把它理解为用来处理动画。
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    //randomize the layer background color
    self.colorLayer.backgroundColor = color.CGColor;
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1];
//    self.layerView.layer.delegate = nil;
    self.layerView.layer.backgroundColor = color.CGColor;
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
