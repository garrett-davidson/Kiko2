//
//  FaceView.m
//  Kiko
//
//  Created by Garrett Davidson on 1/7/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "FaceView.h"
#import "CAShapeLayer+Scaling.h"

@interface FaceView () {
    CAShapeLayer *faceLayer;
    CAShapeLayer *hairLayer;
    UIImageView *leftEyeImageView;
    UIImageView *rightEyeImageView;
    
    UIBezierPath *facePath;
    UIBezierPath *hairPath;
    
    CGRect faceRect;
    CGRect hairRect;
}

@end

@implementation FaceView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    faceLayer = [[CAShapeLayer alloc] init];
    hairLayer = [[CAShapeLayer alloc] init];
    leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [self addSubview:leftEyeImageView];
    [self addSubview:rightEyeImageView];
    [self.layer addSublayer:faceLayer];
    [self.layer addSublayer:hairLayer];
    
    leftEyeImageView.hidden = true;
    rightEyeImageView.hidden = true;
    
    faceLayer.strokeColor = [UIColor blackColor].CGColor;
    faceLayer.fillColor = [UIColor clearColor].CGColor;
    hairLayer.strokeColor = [UIColor blackColor].CGColor;
    hairLayer.fillColor = [UIColor blackColor].CGColor;
    
    faceRect = CGRectInset(self.bounds, self.bounds.size.height/6, self.bounds.size.height/6);
    faceRect = CGRectOffset(faceRect, 0, self.bounds.size.height/6);
    
    hairRect = CGRectInset(self.bounds, 0, self.bounds.size.height/4);
    hairRect = CGRectOffset(hairRect, 0, -self.bounds.size.height/4);
    
    return self;
}

- (void) setFace:(Face *)face {
    _face = face;
    
    [self redraw];
}

- (void) redraw {
    [self drawFace:_face];
}

- (void) drawFace:(Face *)face {
    if (face) {
        facePath = [face.facePath copy];
        
        if (face.hair) {
            hairPath = face.hair.path;
            [hairLayer setPath:hairPath.CGPath inRect:hairRect];
        }

        if (!face.eyes.leftEyeFile) {
            leftEyeImageView.hidden = true;
            rightEyeImageView.hidden = true;
            
            [facePath appendPath:face.leftEyePath];
            [facePath appendPath:face.rightEyePath];
            
            //Must be at the end here because of append path
            [faceLayer setPath:facePath.CGPath inRect:faceRect withXInset:0 yInset:0];
        }
        
        else {
            //Must be at the beginning here to update the eye positions with the new scale
            [faceLayer setPath:facePath.CGPath inRect:faceRect withXInset:0 yInset:0];
            
            leftEyeImageView.hidden = false;
            rightEyeImageView.hidden = false;
            
            leftEyeImageView.image = [face.eyes getLeftEyeImage];
            rightEyeImageView.image = [face.eyes getRightEyeImage];
            
            CGRect leftEyeBounds = CGPathGetBoundingBox(face.leftEyePath.CGPath);
            CGRect rightEyeBounds = CGPathGetBoundingBox(face.rightEyePath.CGPath);
            
            leftEyeImageView.center = [self.layer convertPoint:CGPointMake(CGRectGetMidX(leftEyeBounds), CGRectGetMidY(leftEyeBounds)) fromLayer:faceLayer];
            rightEyeImageView.center = [self.layer convertPoint:CGPointMake(CGRectGetMidX(rightEyeBounds), CGRectGetMidY(rightEyeBounds)) fromLayer:faceLayer];
        }
        
    }
}

@end
