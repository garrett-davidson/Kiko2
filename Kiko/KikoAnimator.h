//
//  KikoAnimator.h
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KikoMessage.h"
#import "KikoEyes.h"
#import "KikoHair.h"


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

@interface KikoAnimator : NSObject

//@property (nonatomic) CAShapeLayer *animationLayer;
@property (nonatomic) UIView *animationView;
@property (nonatomic) KikoEyes *currentEyes;
@property (nonatomic) KikoHair *currentHair;

+ (id) sharedAnimator;

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points;

- (void) pause;
- (void) unpause;

- (Face *) getCurrentFace;

- (void) startRecording;
- (NSArray *)endRecording;

- (void)playMessage: (KikoMessage*)message;
- (void)stopPlayingMessage;

@end
