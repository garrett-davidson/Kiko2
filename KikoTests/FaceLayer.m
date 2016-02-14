//
//  CustomLayer.m
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 9/7/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import "FaceLayer.h"

@implementation FaceLayer {
    BOOL isResize;
    CGRect rect;
}


-(id)init {
    self = [super init];
    if (self) {
        isResize = YES;
    }
    
    return self;
}


- (void)layoutSublayers {
    // resize your layers based on the view's new frame
    
    int counter = 0;
    for (CALayer *subLayer in self.sublayers) {
        counter++;
//        subLayer.frame = self.bounds;
        [self setRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        NSLog(@"Self Bounds : %f %f", self.bounds.size.width, self.bounds.size.height);
        
       // NSLog(@"Sublayer Box : %f %f", subLayer.frame.size.width, subLayer.frame.size.height);
        //NSLog(@"Self Box : %f %f", self.bounds.size.width, self.bounds.size.height);

       // NSLog(@"%f", self.bounds.size.height);
        
        //NSLog(@"%f %f", self.bounds.size.height, self.bounds.size.width);
        //NSLog(@"%f %f", subLayer.frame.size.height, subLayer.frame.size.width);
        //NSLog(@"%ui", counter);
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        //NSLog(@"%f %f", screenHeight, screenWidth);
        
        CGRect boundingBox2;

        if ([subLayer isMemberOfClass:[CAShapeLayer class]]) {
//            subLayer.frame = self.bounds;
            boundingBox2 = CGPathGetBoundingBox(((CAShapeLayer*)subLayer).path);
        }
        else {
            boundingBox2 = subLayer.frame;
        }
        
       // NSLog(@"Bounding Box 2: %f %f", boundingBox2.size.width, boundingBox2.size.height);

        //TODO: Check if this can be replaced with self.frame or bounds
        CGRect boundingBox;
        if (isResize) {
            boundingBox = CGRectMake(0, 0, 480.0, 640.0);
            //isResize = NO;
        } else {
            boundingBox = [self getRect];
        }
        
        
      
        
//        if (!CGRectContainsRect(subLayer.frame, boundingBox2)) {
            CGFloat boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox);
            CGFloat viewAspectRatio = CGRectGetWidth(self.bounds)/CGRectGetHeight(self.bounds);
            CGFloat scaleFactor = 1.0;
            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor
                scaleFactor = CGRectGetWidth(self.bounds)/CGRectGetWidth(boundingBox);
            } else {
                // Height is limiting factor
                scaleFactor = CGRectGetHeight(self.bounds)/CGRectGetHeight(boundingBox);
            }
        
            CGAffineTransform scaleTransform = CGAffineTransformIdentity;
            scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
            scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
            CGSize scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
            //NSLog(@"Scaled Size %f %f", scaledSize.width, scaledSize.height);
            CGSize centerOffset = CGSizeMake((CGRectGetWidth(self.bounds)-scaledSize.width)/(scaleFactor*2.0),(CGRectGetHeight(self.bounds)-scaledSize.height)/(scaleFactor*2.0));
            scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
            //NSLog(@"Center Offset Size %f %f", centerOffset.width, centerOffset.height);
        

        
            //NSLog(@"Scale Factor %f", scaleFactor);
            //NSLog(@"Bounding Box : %f %f", finalBoundingBox.size.width, finalBoundingBox.size.height);
            if ([subLayer isMemberOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeSubLayer = (CAShapeLayer*) subLayer;
                CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(shapeSubLayer.path, &scaleTransform);
                [shapeSubLayer setPath:scaledPath];
            }
            else {
                CGRect finalBoundingBox = CGRectApplyAffineTransform(boundingBox2, scaleTransform);
                finalBoundingBox = CGRectMake(CGRectGetMidX(finalBoundingBox),  CGRectGetMidY(finalBoundingBox) - finalBoundingBox.size.height, finalBoundingBox.size.width * 2, finalBoundingBox.size.height * 2);

                [CATransaction begin];
                [CATransaction setAnimationDuration:0.0];
                subLayer.frame = finalBoundingBox;
                [CATransaction commit];
            }
//        }
    }
    
    isResize = NO;
}

-(id)copyWithZone:(NSZone *)zone {
    FaceLayer *layer = [[FaceLayer allocWithZone:zone] init];
    layer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    
    return layer;
}

-(void)setRect:(CGRect) rectangle {
    rect = rectangle;
}

-(CGRect)getRect {
    return rect;
}








@end
