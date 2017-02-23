//
//  Created by Bill Dudney
//
// Copyright 2008 Gala Factory
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TiledDelegate.h"

@implementation TiledDelegate

@synthesize sfMuni;
@synthesize map;

- (CGPDFDocumentRef)sfMuni {
    if(NULL == sfMuni) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sf_muni" ofType:@"pdf"];
        NSURL *docURL = [NSURL fileURLWithPath:path];
        sfMuni = CGPDFDocumentCreateWithURL((CFURLRef)docURL);
    }
    return sfMuni;
}

- (CGPDFPageRef)map {
    if(NULL == map) {
        map = CGPDFDocumentGetPage(self.sfMuni, 1);
    }
    return map;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextDrawPDFPage(ctx, self.map);
}

- (void)dealloc {
    CGPDFPageRelease(map);
    CGPDFDocumentRelease(sfMuni);
    [super dealloc];
}

@end
