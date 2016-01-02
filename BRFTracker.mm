//
//  BRFTracker.m
//  Kiko
//
//  Created by Garrett Davidson on 12/11/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "BRFTracker.h"

@implementation BRFTracker

- (id) initWithWidth:(int)width height:(int)height {
    self = [self initWithWidth:width height:height andGrayScale:true];
    
    self.faceDetectionROI = new brf::Rectangle;
    
    return self;
}

- (id) initWithWidth: (int)width height:(int)height andGrayScale:(bool)grayScale {
    self.bmd = new brf::BitmapData(width, height, grayScale);
    self.brfRoi = new brf::Rectangle(0, 0, width, height);
    self.brfManager = new brf::BRFManager();
    
    return self;
}

- (void) initialize:(bool)showTraces {
    self.brfManager -> debug(showTraces);
    self.brfManager -> init(self.bmd, self.brfRoi);
}

- (void) onReadyBRF {
    brf::trace("BRFTracker::onReadBRF");
    
    double border = 40.0;
    
    self.faceDetectionROI->x = border;
    self.faceDetectionROI->y = border;
    self.faceDetectionROI->width = self.bmd->width - border * 2;
    self.faceDetectionROI->height = self.bmd->height - border * 2;
    
    if (self.bmd->width > 352) {
        self.brfManager -> setFaceDetectionVars(8.0, 0.5, 14.0, 0.06, 6, false);
    } else {
        self.brfManager -> setFaceDetectionVars(4.0, 0.5, 11.0, 0.06, 6, false);
    }
    
    self.brfManager -> setFaceTrackingVars(80, 500);
    self.brfManager -> candideEnabled(false);
    self.brfManager -> candideActionUnitsEnabled(false);
    
    self.brfManager -> mode(brf::BRFMode::FACE_TRACKING);
    self.brfManager -> debug(false);
}

- (void) update:(uint8_t *)data {
    self.bmd -> updateData(data);
    self.brfManager -> update();
}

- (std::vector<std::shared_ptr<brf::Point>>) updateGUI:(CGContextRef)context {
    std::string& state = self.brfManager -> state();
    
    std::vector<std::shared_ptr<brf::Point>> points;
    
    DrawingUtils::drawRect(context, *(self.brfRoi), false, 2, 0x00ff00, 1);
    
     if (!state.compare(brf::BRFState::FACE_DETECTION)) {
        DrawingUtils::drawRect(context, *(self.faceDetectionROI), true, 1, 0xffff00, 1);
        
        std::vector<std::shared_ptr<brf::Rectangle>>& rects = self.brfManager -> lastDetectedFaces();
        
        if (rects.size() > 0) {
            DrawingUtils::drawRects(context, rects, false, 1, 0x00ff00, 1);
        }
        
        brf::Rectangle& rect = self.brfManager -> lastDetectedFace();
        
        if (rect.x != 0.0) {
            DrawingUtils::drawRect(context, rect, false, 3, 0xff7900, 1);
        }
    }
    else if (!state.compare(brf::BRFState::FACE_TRACKING_START) || !state.compare(brf::BRFState::FACE_TRACKING)) {
        brf::BRFFaceShape& faceShape = self.brfManager -> faceShape();
        
        DrawingUtils::drawTriangles(context, faceShape.faceShapeVertices, faceShape.faceShapeTriangles, true, 0x00ff00, 1);
        
        DrawingUtils::drawRect(context, faceShape.bounds, false, 1, 0x00ff00, 1);
        
        points = faceShape.points;
    }
    
    return points;
}

@end
