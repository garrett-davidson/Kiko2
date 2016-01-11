//
//  CAShapeLayer+Scaling.m
//  Kiko
//
//  Created by Garrett Davidson on 1/7/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "CAShapeLayer+Scaling.h"

@implementation CAShapeLayer (Scaling)

- (void) setPath:(CGPathRef)path inRect:(CGRect)rect {
    [self setPath:path inRect:rect withXInset:0 yInset:0];
}

- (void) setPath:(CGPathRef)path inRect:(CGRect)rect withXInset:(CGFloat)xInset yInset:(CGFloat)yInset {
    self.path = path;
    CGRect pathBounds = CGPathGetBoundingBox(path);
    CGRect rectBounds = CGRectInset(rect, xInset + self.lineWidth * 2, yInset + self.lineWidth * 2);
    
    float widthScale = rectBounds.size.width/pathBounds.size.width;
    float heightScale = rectBounds.size.height/pathBounds.size.height;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, widthScale, heightScale);
    transform = CGAffineTransformTranslate(transform, -pathBounds.origin.x, -pathBounds.origin.y);
    transform = CGAffineTransformTranslate(transform, rectBounds.origin.x/widthScale, rectBounds.origin.y/heightScale);

    self.affineTransform = transform;
}
@end
