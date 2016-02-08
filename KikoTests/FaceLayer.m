//
//  CustomLayer.m
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 9/7/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import "FaceLayer.h"

@implementation FaceLayer


- (void)layoutSublayers {
    // resize your layers based on the view's new frame
    
    int counter = 0;
    for (CAShapeLayer *subLayer in (CAShapeLayer *)self.sublayers) {
        counter++;
        subLayer.frame = self.bounds;
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
        
        CGRect boundingBox2 = CGPathGetBoundingBox(subLayer.path);
        
       // NSLog(@"Bounding Box 2: %f %f", boundingBox2.size.width, boundingBox2.size.height);
        
        CGRect boundingBox = CGRectMake(0, 0, 480.0, 640.0);
        
      
        
        if (!CGRectContainsRect(subLayer.frame, boundingBox2)) {
            CGFloat boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox);
            CGFloat viewAspectRatio = CGRectGetWidth(subLayer.frame)/CGRectGetHeight(subLayer.frame);
            CGFloat scaleFactor = 1.0;
            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor
                scaleFactor = CGRectGetWidth(subLayer.frame)/CGRectGetWidth(boundingBox);
            } else {
                // Height is limiting factor
                scaleFactor = CGRectGetHeight(subLayer.frame)/CGRectGetHeight(boundingBox);
            }
        
            CGAffineTransform scaleTransform = CGAffineTransformIdentity;
            scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
            scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
            CGSize scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
            //NSLog(@"Scaled Size %f %f", scaledSize.width, scaledSize.height);
            CGSize centerOffset = CGSizeMake((CGRectGetWidth(subLayer.frame)-scaledSize.width)/(scaleFactor*2.0),(CGRectGetHeight(subLayer.frame)-scaledSize.height)/(scaleFactor*2.0));
            scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
            //NSLog(@"Center Offset Size %f %f", centerOffset.width, centerOffset.height);
        
            CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(subLayer.path,
                                                                  &scaleTransform);
        
            CGRect finalBoundingBox = CGPathGetBoundingBox(scaledPath);
            //NSLog(@"Scale Factor %f", scaleFactor);
            //NSLog(@"Bounding Box : %f %f", finalBoundingBox.size.width, finalBoundingBox.size.height);
            if (finalBoundingBox.origin.y >= 0.0 && (finalBoundingBox.origin.y + finalBoundingBox.size. height <= self.bounds.size.height)) {
                [subLayer setPath:scaledPath];
            } else {
                [subLayer setPath:nil];
            } 
            
        }
        
        
        
        
        



    }
    
}

-(id)copyWithZone:(NSZone *)zone {
    FaceLayer *layer = [[FaceLayer allocWithZone:zone] init];
    layer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    
    return layer;
}





@end
