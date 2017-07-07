//
//  DrawingView.m
//  CoreAnimationAdvancedTechniques13_3
//
//  Created by JXT on 2017/7/7.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "DrawingView.h"

static CGFloat const BRUSH_SIZE = 32.0f;

@interface DrawingView ()
@property (nonatomic, strong) NSMutableArray * strokes;
@end

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //create array
        self.strokes = [NSMutableArray array];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}



//- (void)addBrushStrokeAtPoint:(CGPoint)point
//{
//    //add brush stroke to array
//    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
//    
//    //needs redraw
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    //redraw strokes
//    for (NSValue *value in self.strokes) {
//        //get point
//        CGPoint point = [value CGPointValue];
//        
//        //get brush rect
//        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
//        
//        //draw brush stroke    ￼
//        [[UIImage imageNamed:@"Chalk.png"] drawInRect:brushRect];
//    }
//}

- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    //set dirty rect
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point
{
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        
        //get brush rect
        CGRect brushRect = [self brushRectForPoint:point];
        
        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"Chalk.png"] drawInRect:brushRect];
        }
    }
}

@end
