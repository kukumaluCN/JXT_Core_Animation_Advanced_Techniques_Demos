//
//  LayerView.m
//  CoreAnimationAdvancedTechniques7_3
//
//  Created by JXT on 2017/4/9.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "LayerView.h"

@implementation LayerView

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    NSLog(@"key - %@", event);
//    return [NSNull null];
    return nil;
//    NSLog(@"%@", [super actionForLayer:layer forKey:event]);
//    NSLog(@"%@", [NSNull null]);
//    NSLog(@"%@", nil);
//    return [super actionForLayer:layer forKey:event];
}

@end
