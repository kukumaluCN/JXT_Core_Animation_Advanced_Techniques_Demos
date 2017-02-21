//
//  ScrollView.m
//  CoreAnimationAdvancedTechniques6_6
//
//  Created by JXT on 2017/2/21.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

+ (Class)layerClass
{
    return [CAScrollLayer class];
}

- (void)setUp
{
    //enable clipping
    self.layer.masksToBounds = YES;
    
    //attach pan gesture recognizer
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    //get the offset by subtracting the pan gesture
    //translation from the current bounds origin
    CGPoint offset = self.bounds.origin;
    offset.x -= [recognizer translationInView:self].x;
    offset.y -= [recognizer translationInView:self].y;
    
    NSLog(@"%lf %lf", offset.x, offset.y);
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    NSLog(@"%@", NSStringFromCGPoint(self.center));
    //scroll the layer
    [(CAScrollLayer *)self.layer scrollToPoint:offset];
    
    //reset the pan gesture translation
    [recognizer setTranslation:CGPointZero inView:self];
}

@end
