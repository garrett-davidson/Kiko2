//
//  NewKikoAnimator.h
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __NewKikoAnimator
#define __NewKikoAnimator

#include <cstdlib>
#include <cstdint>
#include "BRFManager.hpp"
#include "Rectangle.hpp"

#include "BRFMode.hpp"
#include "BRFState.hpp"

#include "DrawingUtils.hpp"

#endif

@interface NewKikoAnimator : NSObject

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points;
+ (NewKikoAnimator*) sharedAnimator;

@property (nonatomic) UIView *animationView;

@end
