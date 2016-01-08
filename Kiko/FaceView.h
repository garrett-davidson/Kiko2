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

- (void) drawFace:(Face *)face;
- (void) redraw;

@end
