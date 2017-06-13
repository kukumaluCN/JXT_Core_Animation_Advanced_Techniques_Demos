//
//  AppDelegate.m
//  CoreAnimationAdvancedTechniques8_3
//
//  Created by JXT on 2017/6/9.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "ViewController2.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //清单8.12 对UITabBarController做动画
    UIViewController *viewController1 = [[ViewController alloc] init];
    viewController1.title = @"VC1";
    UIViewController *viewController2 = [[ViewController2 alloc] init];
    viewController2.title = @"VC2";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[viewController1, viewController2];
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    /**
     *  设置tabBar-title
     */
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:103/255.0 green:193/255.0 blue:236/255.0 alpha:1], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(-8, -12)];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //用UITabBarControllerDelegate的-tabBarController:didSelectViewController:方法来应用过渡动画。我们把动画添加到UITabBarController的视图图层上，于是在标签被替换的时候动画不会被移除。
    //set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to tab bar controller's view
    [tabBarController.view.layer addAnimation:transition forKey:nil];
//    [self.window.layer addAnimation:transition forKey:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
