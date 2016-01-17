//
//  FaceView.h
//  Kiko
//
//  Created by Garrett Davidson on 1/7/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Face.h"

@interface FaceView : UIView

@property (nonatomic) Face *face;
@property (nonatomic) UIColor *faceStrokeColor;

//- (void) redraw;
//- (void) redrawWithFaceFrame:(CGRect)faceFrame;
//- (void) redrawWithFaceFrame:(CGRect)faceFrame hairFrame:(CGRect)hairFrame;

//- (void) drawFace:(Face *)face;
//- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame;
//- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame hairFrame:(CGRect)hairFrame;

//- (void) redraw;
//- (void) drawFace:(Face *)face;

- (void) drawFace:(Face *)face withFaceFrame:(CGRect)faceFrame;

@end
