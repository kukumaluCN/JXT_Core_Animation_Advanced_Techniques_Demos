//
//  TiledLayer_iphoneViewController.h
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapView;
@interface TiledLayer_iphoneViewController : UIViewController<UIScrollViewDelegate> {
	MapView* mapView;
}

@end

