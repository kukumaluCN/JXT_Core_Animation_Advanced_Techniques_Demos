//
//  TiledLayer_iphoneViewController.m
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TiledLayer_iphoneViewController.h"
#import "MapView.h"
@implementation TiledLayer_iphoneViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
 *delegate notification
 *return a view that will be scaled
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return mapView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//create& add scrollView
	UIScrollView* myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	myScrollView.contentSize = CGSizeMake(mapView.frame.size.width, mapView.frame.size.height);
	myScrollView.minimumZoomScale = 1.0;
	myScrollView.maximumZoomScale = 50.0;
	myScrollView.clipsToBounds = YES;
	myScrollView.delegate = self;
	[self.view addSubview:myScrollView];
	
	//add image view to scrollView
	mapView = [[MapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[myScrollView addSubview:mapView];
	
	//release
	[mapView release];
	[myScrollView release];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
}

@end
