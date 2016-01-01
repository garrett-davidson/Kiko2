//
//  BRFTracker.h
//  Kiko
//
//  Created by Garrett Davidson on 12/11/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef __BRFTracker
#define __BRFTracker

#include <cstdlib>
#include <cstdint>
#include "BRFManager.hpp"
#include "Rectangle.hpp"

#include "BRFMode.hpp"
#include "BRFState.hpp"

#include "DrawingUtils.hpp"

#endif

@interface BRFTracker : NSObject {
    
}

@property (nonatomic) brf::BitmapData *bmd;
@property (nonatomic) brf::Rectangle *brfRoi;
@property (nonatomic) brf::BRFManager *brfManager;
@property (nonatomic) brf::Rectangle *faceDetectionROI;

- (id) initWithWidth: (int)width height:(int) height;

- (id) initWithWidth: (int)width height:(int)height andGrayScale:(bool)grayScale;

- (void) initialize: (bool)showTraces;

- (void) onReadyBRF;

- (void) update: (uint8_t*)data;

- (std::vector<std::shared_ptr<brf::Point>>) updateGUI: (CGContextRef)context;

@end
