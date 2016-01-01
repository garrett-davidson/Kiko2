//
//  KikoAnimator.h
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef __KikoAnimator
#define __KikoAnimator

#include <cstdlib>
#include <cstdint>
#include "com/tastenkunst/cpp/brf/nxt/BRFManager.hpp"
#include "com/tastenkunst/cpp/brf/nxt/geom/Rectangle.hpp"

#include "com/tastenkunst/cpp/brf/nxt/BRFMode.hpp"
#include "com/tastenkunst/cpp/brf/nxt/BRFState.hpp"

#include "com/tastenkunst/cpp/brf/nxt/utils/DrawingUtils.hpp"

#endif

@interface KikoAnimator : NSObject

//@property (nonatomic) CAShapeLayer *animationLayer;
@property (nonatomic) UIView *animationView;

+ (id) sharedAnimator;

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points;

- (void) pause;
- (void) unpause;

- (UIBezierPath *) getCurrentPath;

@end
