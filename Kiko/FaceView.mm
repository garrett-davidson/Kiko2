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

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initialize];
    return self;
}

- (void) initialize {
    faceLayer = [[CAShapeLayer alloc] init];
    hairLayer = [[CAShapeLayer alloc] init];
    leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 50, 50)];
    rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 50, 50)];
    
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
}

- (void) setFace:(Face *)face {
    _face = face;
    [self redraw];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self redraw];
}

- (void) redraw {
    [self drawFace:_face];
}

- (void) redrawWithFaceFrame:(CGRect)faceFrame {
    [self drawFace:_face withFaceFrame:faceFrame];
}

- (void) redrawWithFaceFrame:(CGRect)faceFrame hairFrame:(CGRect)hairFrame {
    [self drawFace:_face withFaceFrame:faceFrame hairFrame:hairFrame];
}

- (void) drawFace:(Face *)face {
    faceRect = CGRectInset(self.bounds, self.bounds.size.height/6, self.bounds.size.height/6);
    faceRect = CGRectOffset(faceRect, 0, self.bounds.size.height/6);

    hairRect = CGRectInset(self.bounds, 0, self.bounds.size.height/4);
    hairRect = CGRectOffset(hairRect, 0, -self.bounds.size.height/4);
    [self drawFace:face withFaceFrame:faceRect hairFrame:hairRect];
}

- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame {
    CGRect bounds = CGRectInset(faceFrame, -faceFrame.size.width*1/6, -faceFrame.size.height*1/6);
    CGRect hairFrame = CGRectInset(bounds, 0, bounds.size.height/4);
    hairFrame = CGRectOffset(hairFrame, 0, -faceFrame.size.height/2);
    [self drawFace:face withFaceFrame:faceFrame hairFrame:hairFrame];
}

- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame hairFrame:(CGRect)hairFrame {
    _face = face;
    if (face) {
        facePath = [face.facePath copy];
        
        if (face.hair) {
            hairPath = face.hair.path;
            [hairLayer setPath:hairPath.CGPath inRect:hairFrame];
        }
        
        if (![face.eyes fetchIfNeeded].leftEyeFile) {
            leftEyeImageView.hidden = true;
            rightEyeImageView.hidden = true;
            
            [facePath appendPath:face.leftEyePath];
            [facePath appendPath:face.rightEyePath];
            
            //Must be at the end here because of append path
            [faceLayer setPath:facePath.CGPath inRect:faceFrame withXInset:0 yInset:0];
        }
        
        else {
            //Must be at the beginning here to update the eye positions with the new scale
            [faceLayer setPath:facePath.CGPath inRect:faceFrame withXInset:0 yInset:0];
            
            leftEyeImageView.hidden = false;
            rightEyeImageView.hidden = false;
            
            leftEyeImageView.image = [face.eyes getLeftEyeImage];
            rightEyeImageView.image = [face.eyes getRightEyeImage];
            
            CGRect leftEyeBounds = CGPathGetBoundingBox(face.leftEyePath.CGPath);
            CGRect rightEyeBounds = CGPathGetBoundingBox(face.rightEyePath.CGPath);
            
            if (!CGRectEqualToRect(leftEyeBounds, CGRectZero) && !CGRectEqualToRect(rightEyeBounds, CGRectZero)) {
                leftEyeImageView.frame = [self.layer convertRect:CGRectMake(leftEyeBounds.origin.x, leftEyeBounds.origin.y, leftEyeBounds.size.width*1.2, leftEyeBounds.size.width*1.2) fromLayer:faceLayer];
                rightEyeImageView.frame = [self.layer convertRect:CGRectMake(rightEyeBounds.origin.x, rightEyeBounds.origin.y, rightEyeBounds.size.width*1.2, rightEyeBounds.size.width*1.2) fromLayer:faceLayer];
            }
        }
        
    }
}

@end
