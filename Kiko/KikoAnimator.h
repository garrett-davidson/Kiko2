//
//  NewKikoAnimator.h
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __KikoAnimator
#define __KikoAnimator

#include <cstdlib>
#include <cstdint>
#include "BRFManager.hpp"
#include "Rectangle.hpp"

#include "BRFMode.hpp"
#include "BRFState.hpp"

#include "DrawingUtils.hpp"

#endif

#import "Face2.h"

@interface KikoAnimator : NSObject

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points;
+ (KikoAnimator*) sharedAnimator;

- (void) pause;
- (void) unpause;
- (void) startRecording;
- (NSArray *) stopRecording;

@property (nonatomic) UIView *animationView;
@property (nonatomic) Face2 *currentFace;

@end
