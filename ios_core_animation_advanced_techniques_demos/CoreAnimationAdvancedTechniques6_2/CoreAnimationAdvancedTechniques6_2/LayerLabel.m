//
//  LayerLabel.m
//  CoreAnimationAdvancedTechniques6_2
//
//  Created by JXT on 2017/2/8.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "LayerLabel.h"

@implementation LayerLabel

+ (Class)layerClass
{
    //this makes our label create a CATextLayer //instead of a regular CALayer for its backing layer
    return [CATextLayer class];
}

//直接这样写，无法正常设置backgroundColor
//- (CATextLayer *)textLayer
//{
////    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
//
//    return (CATextLayer *)self.layer;
//}

- (CATextLayer *)textLayer
{
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = self.layer.bounds;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_textLayer];
    }
    return _textLayer;
}


- (void)setUp
{
    //set defaults from UILabel settings
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    //we should really derive these from the UILabel settings too
    //but that's complicated, so for now we'll just hard-code them
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    [self textLayer].wrapped = YES;
    
    [self.layer display];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    //called when creating label programmatically
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //called when creating label using Interface Builder
    [self setUp];
}



- (void)setText:(NSString *)text
{
    super.text = text;
    //set layer text
    [self textLayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    super.textColor = textColor;
    //set layer text color
    [self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    
    CGFontRelease(fontRef);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.textLayer.backgroundColor = backgroundColor.CGColor;
}

@end
