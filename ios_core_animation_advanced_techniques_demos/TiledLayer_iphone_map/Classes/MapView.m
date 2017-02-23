//
//  MapView.m
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "TiledDelegate.h"


@implementation MapView
@synthesize popUpIndex;


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		zoom = 0.20f;
		// set up this view & its layer
//		self.layer = [CALayer layer];
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 10.0f;
		self.layer.borderWidth  = 5.0f;
		self.layer.borderColor  = [UIColor redColor].CGColor;
		self.layer.backgroundColor = [UIColor whiteColor].CGColor;//CGColorGetConstantColor(kCGColorWhite);
//		self.wantsLayer = YES;
		
		// set up the tiled layer
		tiledLayer = [CATiledLayer layer];
		TiledDelegate *delegate = [[TiledDelegate alloc] init];
		tiledLayer.delegate = delegate;
		
		// get tiledLayer size
		CGRect pageRect = CGPDFPageGetBoxRect(delegate.map, kCGPDFCropBox);
		int w = pageRect.size.width;
		int h = pageRect.size.height;
		
		// get level count
		int levels = 1;
		while (w > 1 && h > 1) {
			levels++;
			w = w >> 1;
			h = h >> 1;
		}
		// set the levels of detail
		tiledLayer.levelsOfDetail = levels;
		// set the bias for how many 'zoom in' levels there are
		tiledLayer.levelsOfDetailBias = 5;
		// setup the size and position of the tiled layer
		tiledLayer.bounds = CGRectMake(0.0f, 0.0f,
									   CGRectGetWidth(pageRect), 
									   CGRectGetHeight(pageRect));
		CGFloat x = CGRectGetWidth(tiledLayer.bounds) * tiledLayer.anchorPoint.x;
		CGFloat y = CGRectGetHeight(tiledLayer.bounds) * tiledLayer.anchorPoint.y;
		tiledLayer.position = CGPointMake(x * zoom, y * zoom);
		tiledLayer.transform = CATransform3DMakeScale(zoom, zoom, 1.0f);
		[self.layer addSublayer:tiledLayer];
		
		[tiledLayer setNeedsDisplay];
		
		// set self w h
		//[self setFrame:pageRect];
		
		//self.userInteractionEnabled = YES;
    }
    return self;
}

#if 0
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // realy should recenter on a click but I'm being lazy
//    if(event.modifierFlags & NSControlKeyMask) {
//        zoom *= 0.5f;
//        tiledLayer.transform = CATransform3DMakeScale(zoom, zoom, 1.0f);
//    } 
//	else
 
	{
        zoom *= 2.0f;
        tiledLayer.transform = CATransform3DMakeScale(zoom, zoom, 1.0f);
    }
}
#endif



- (void)dealloc 
{
    [super dealloc];
}


@end
