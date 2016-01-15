//
//  FaceView.m
//  Kiko
//
//  Created by Garrett Davidson on 1/7/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "FaceView.h"
#import "CAShapeLayer+Scaling.h"

#define kStandardFaceWidth 410

@interface FaceView () {
    CAShapeLayer *faceLayer;
    UIImageView *hairImageView;
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
    hairImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 50, 50)];
    leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 50, 50)];
    rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 50, 50)];
    
    [self addSubview:leftEyeImageView];
    [self addSubview:rightEyeImageView];
    [self addSubview:hairImageView];
    [self.layer addSublayer:faceLayer];
    
    leftEyeImageView.hidden = true;
    rightEyeImageView.hidden = true;
    hairImageView.hidden = true;
    
    faceLayer.strokeColor = [UIColor blackColor].CGColor;
    faceLayer.fillColor = [UIColor clearColor].CGColor;
    
    faceRect = CGRectInset(self.bounds, self.bounds.size.height/6, self.bounds.size.height/6);
    faceRect = CGRectOffset(faceRect, 0, self.bounds.size.height/6);
    
    hairRect = CGRectInset(self.bounds, 0, self.bounds.size.height/4);
    hairRect = CGRectOffset(hairRect, 0, -self.bounds.size.height/4);
}

- (void) setFace:(Face *)face {
    _face = face;
    [self redrawNew];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self redrawNew];
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
//            hairPath = face.hair.path;
//            [hairLayer setPath:hairPath.CGPath inRect:hairFrame];
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

- (void) redrawNew {
    [self drawFaceNew:_face];
}

- (void) drawFaceNew:(Face *)face {
//    float hairScale = self.bounds.size.height > self.bounds.size.width ? self.bounds.size.width/face.hair.image.size.width : self.bounds.size.height/face.hair.image.size.height;
    float hairScale = face.hair.image ? self.bounds.size.width/face.hair.image.size.width : 1;
    hairRect = CGRectMake(self.bounds.origin.x - (face.hair.mountingX.floatValue * hairScale), self.bounds.origin.y - (face.hair.mountingY.floatValue * hairScale), (face.hair.image.size.width + (face.hair.mountingX.floatValue * 2)) * hairScale, (face.hair.image.size.height + (face.hair.mountingX.floatValue*2)) * hairScale);

    faceRect = self.bounds;

    _face = face;

    [self drawFaceNew2:face];
}

- (void) drawFaceNew2:(Face *)face {
    _face = face;
    if (face) {
        facePath = [face.facePath copy];

        if (face.hair) {
            hairImageView.hidden = false;
            hairImageView.image = face.hair.image;
            hairImageView.frame = hairRect;
        }

        if (![face.eyes fetchIfNeeded].leftEyeFile) {
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

            if (!CGRectEqualToRect(leftEyeBounds, CGRectZero) && !CGRectEqualToRect(rightEyeBounds, CGRectZero)) {
                leftEyeImageView.frame = [self.layer convertRect:CGRectMake(leftEyeBounds.origin.x, leftEyeBounds.origin.y, leftEyeBounds.size.width*1.2, leftEyeBounds.size.width*1.2) fromLayer:faceLayer];
                rightEyeImageView.frame = [self.layer convertRect:CGRectMake(rightEyeBounds.origin.x, rightEyeBounds.origin.y, rightEyeBounds.size.width*1.2, rightEyeBounds.size.width*1.2) fromLayer:faceLayer];
            }
        }
        
    }
}

- (void) drawFace:(Face *)face withFaceFrameNew:(CGRect)faceFrame {
    CGRect faceBounds = CGPathGetBoundingBox(face.facePath.CGPath);

    float faceScale = face.hair.image ? faceFrame.size.width / (face.hair.image.size.width - (face.hair.mountingX.floatValue * 2)) : 1;
    float hairScale = face.hair.image ? faceFrame.size.width / face.hair.image.size.width : 1;
    float aspectRatio = faceBounds.size.width / faceBounds.size.height;

    faceScale = faceScale > 1 ? 1 / faceScale : faceScale;

    faceRect = CGRectMake([face.hair fetchIfNeeded].mountingX.floatValue * faceScale * hairScale, [face.hair fetchIfNeeded].mountingY.floatValue * faceScale * aspectRatio * hairScale, faceScale * faceFrame.size.width, faceFrame.size.height * faceScale * aspectRatio);
    hairRect = CGRectMake(0, 0, face.hair.image.size.width * hairScale, face.hair.image.size.height * hairScale);

    if (face.hair.image) {
        float scale2 = faceFrame.size.height / (faceRect.origin.y + faceRect.size.height);
        scale2 = scale2 > 1 ? 1 / scale2 : scale2;
        CGAffineTransform t = CGAffineTransformMakeScale(scale2, scale2);

        faceRect = CGRectApplyAffineTransform(faceRect, t);
        hairRect = CGRectApplyAffineTransform(hairRect, t);
    }

    faceRect = CGRectOffset(faceRect, CGRectGetMidX(faceFrame) - CGRectGetMidX(faceRect), 0);
    hairRect = CGRectOffset(hairRect, CGRectGetMidX(faceFrame) - CGRectGetMidX(hairRect), 0);

    [self drawFaceNew2:face];
}

@end
