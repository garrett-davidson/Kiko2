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
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, widthScale, heightScale, 1);
    transform = CATransform3DTranslate(transform, -pathBounds.origin.x, -pathBounds.origin.y, 0);
    transform = CATransform3DTranslate(transform, rectBounds.origin.x/widthScale, rectBounds.origin.y/heightScale, 0);
//    transform = CATransform3DTranslate(transform, (rect.size.width - pathBounds.size.width*widthScale)/(widthScale*2.0), (rect.size.height-pathBounds.size.height*heightScale)/(heightScale*2.0), 1);
//    transform = CATransform3DTranslate(transform, (rect.origin.x - pathBounds.origin.x*widthScale)/(widthScale*2.0), (rect.origin.y-pathBounds.origin.y*heightScale)/(heightScale*2.0), 1);
    self.transform = transform;
}
@end
