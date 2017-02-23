//
//  MapView.h
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MapView : UIImageView {
    CATiledLayer *tiledLayer;
    CGFloat zoom;
    NSInteger popUpIndex;
	
}
@property (assign) NSInteger popUpIndex;

@end
