//
//  ViewController.m
//  CoreAnimationAdvancedTechniques6_2
//
//  Created by JXT on 2017/2/7.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#import <CoreText/CoreText.h>

#import "LayerLabel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

//GLK_INLINE float GLKMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };
//GLK_INLINE float GLKMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 2

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    //Core Animation提供了一个CALayer的子类CATextLayer，它以图层的形式包含了UILabel几乎所有的绘制特性，并且额外提供了一些新的特性
    //CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。
    
#if kPartEnabled == 1
    //清单6.2 用CATextLayer来实现一个UILabel
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    labelView.center = kScreenCenter;
    labelView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:labelView];
    
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = labelView.bounds;
    [labelView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    textLayer.font = fontRef;//CFTypeRef -> CGFontRef/CTFontRef
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \n elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \n leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \n fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \n lobortis";

    //set layer text
    textLayer.string = text;//id类型 这样你既可以用NSString也可以用NSAttributedString来指定文本
    
    
    //contentsScale并不关心屏幕的拉伸因素而总是默认为1.0。如果我们想以Retina的质量来显示文字，我们就得手动地设置CATextLayer的contentsScale属性
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    
    
    
    //清单6.3 用NSAttributedString实现一个富文本标签。
    //富文本
    //create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    //convert UIFont to a CTFont
    CFStringRef fontName2 = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef2 = CTFontCreateWithName(fontName2, fontSize, NULL);
    
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef2
                              };
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
   
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef2
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef2);
    
    textLayer.string = string;
    
#endif
    
    
#if kPartEnabled == 2
    
    LayerLabel *label = [[LayerLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = @"自定义layerLabel测试";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor orangeColor]; //源代码不能设置。。。做了修改
    label.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:label];
    
#endif
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
