//
//  ViewController.m
//  CoreAnimationAdvancedTechniques5_3
//
//  Created by JXT on 2017/1/13.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kPartEnabled 6

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
