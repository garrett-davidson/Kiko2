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
    [self redraw];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self redraw];
}


- (void) redraw {
    [self drawFace:_face];
}

- (void) drawFace:(Face *)face {
//    float hairScale = self.bounds.size.height > self.bounds.size.width ? self.bounds.size.width/face.hair.image.size.width : self.bounds.size.height/face.hair.image.size.height;
    float hairScale = face.hair.image ? self.bounds.size.width/face.hair.image.size.width : 1;
    hairRect = CGRectMake(self.bounds.origin.x - (face.hair.mountingX.floatValue * hairScale), self.bounds.origin.y - (face.hair.mountingY.floatValue * hairScale), (face.hair.image.size.width + (face.hair.mountingX.floatValue * 2)) * hairScale, (face.hair.image.size.height + (face.hair.mountingX.floatValue*2)) * hairScale);

    faceRect = self.bounds;

    _face = face;

    [self draw];
}

- (void) draw {
    if (_face) {
        facePath = [_face.facePath copy];

        if (_face.hair.image) {
            hairImageView.hidden = false;
            hairImageView.image = _face.hair.image;
            hairImageView.frame = hairRect;
        }

        if (![_face.eyes fetchIfNeeded].leftEyeFile) {
            leftEyeImageView.hidden = true;
            rightEyeImageView.hidden = true;

            [facePath appendPath:_face.leftEyePath];
            [facePath appendPath:_face.rightEyePath];

            //Must be at the end here because of append path
            [faceLayer setPath:facePath.CGPath inRect:faceRect withXInset:0 yInset:0];
        }

        else {
            //Must be at the beginning here to update the eye positions with the new scale
            [faceLayer setPath:facePath.CGPath inRect:faceRect withXInset:0 yInset:0];

            leftEyeImageView.hidden = false;
            rightEyeImageView.hidden = false;

            leftEyeImageView.image = [_face.eyes getLeftEyeImage];
            rightEyeImageView.image = [_face.eyes getRightEyeImage];

            CGRect leftEyeBounds = CGPathGetBoundingBox(_face.leftEyePath.CGPath);
            CGRect rightEyeBounds = CGPathGetBoundingBox(_face.rightEyePath.CGPath);

            if (!CGRectEqualToRect(leftEyeBounds, CGRectZero) && !CGRectEqualToRect(rightEyeBounds, CGRectZero)) {
                leftEyeImageView.frame = [self.layer convertRect:CGRectMake(leftEyeBounds.origin.x, leftEyeBounds.origin.y, leftEyeBounds.size.width*1.2, leftEyeBounds.size.width*1.2) fromLayer:faceLayer];
                rightEyeImageView.frame = [self.layer convertRect:CGRectMake(rightEyeBounds.origin.x, rightEyeBounds.origin.y, rightEyeBounds.size.width*1.2, rightEyeBounds.size.width*1.2) fromLayer:faceLayer];
            }
        }
        
    }
}

- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame {

    if (face.facePath) {
        _face = face;
        CGRect faceBounds = CGPathGetBoundingBox(face.facePath.CGPath);

        float hairScale = face.hair.image ? faceFrame.size.width / face.hair.image.size.width : 1;
        float faceScale = face.hair.image ? faceFrame.size.width / (hairScale * (face.hair.image.size.width - (face.hair.mountingX.floatValue * 2))) : 1;

        float aspectRatio = faceBounds.size.height / faceBounds.size.width;

        faceScale = faceScale > 1 ? 1 / faceScale : faceScale;

        faceRect = CGRectMake([face.hair fetchIfNeeded].mountingX.floatValue * faceScale * hairScale,
                              [face.hair fetchIfNeeded].mountingY.floatValue * faceScale * aspectRatio * hairScale,
                              faceScale * faceFrame.size.width,
                              faceFrame.size.height * faceScale * aspectRatio);
        hairRect = CGRectMake(0,
                              0,
                              face.hair.image.size.width * hairScale,
                              face.hair.image.size.height * hairScale);

        float scale2 = faceFrame.size.height / (faceRect.origin.y + faceRect.size.height);
        scale2 = scale2 > 1 ? 1 / scale2 : scale2;
        CGAffineTransform t = CGAffineTransformMakeScale(scale2, scale2);

        faceRect = CGRectApplyAffineTransform(faceRect, t);
        if (face.hair.image) {
            hairRect = CGRectApplyAffineTransform(hairRect, t);
        }

        faceRect = CGRectOffset(faceRect, CGRectGetMidX(faceFrame) - CGRectGetMidX(faceRect), 0);
        hairRect = CGRectOffset(hairRect, CGRectGetMidX(faceFrame) - CGRectGetMidX(hairRect), 0);

        [self draw];
    }
}

@end
