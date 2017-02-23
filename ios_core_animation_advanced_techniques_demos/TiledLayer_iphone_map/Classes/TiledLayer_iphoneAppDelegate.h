//
//  TiledLayer_iphoneAppDelegate.h
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TiledLayer_iphoneViewController;

@interface TiledLayer_iphoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TiledLayer_iphoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TiledLayer_iphoneViewController *viewController;

@end

