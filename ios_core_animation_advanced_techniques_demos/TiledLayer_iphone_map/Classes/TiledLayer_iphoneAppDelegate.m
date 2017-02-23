//
//  TiledLayer_iphoneAppDelegate.m
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TiledLayer_iphoneAppDelegate.h"
#import "TiledLayer_iphoneViewController.h"

@implementation TiledLayer_iphoneAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
