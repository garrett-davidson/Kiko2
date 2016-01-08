//
//  CAShapeLayer+Scaling.h
//  Kiko
//
//  Created by Garrett Davidson on 1/7/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (Scaling)

- (void) setPath:(CGPathRef)path inRect:(CGRect)rect;
- (void) setPath:(CGPathRef)path inRect:(CGRect)rect withXInset:(CGFloat)xInset yInset:(CGFloat)yInset;

@end
