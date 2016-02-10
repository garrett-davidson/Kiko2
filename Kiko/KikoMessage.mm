//
//  KikoMessage.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoMessage.h"

#import "KikoAnimator.h"

@interface KikoMessage () {
    NSUInteger currentFrame;
    NSTimer *playbackTimer;

    KikoAnimator *animator;
    UIView *playbackView;
}

@end

@implementation KikoMessage

@dynamic sender, face, messageLength, xValues, yValues;
@synthesize view = _view, isPlaying = _isPlaying, faceFrames = _faceFrames;

- (id) initWithSender:(User *)sender andFrames:(FacesArray *)frames {
    self = [KikoMessage object];

    self.sender = sender;
    self.faceFrames = frames;

    currentFrame = 0;
    self.messageLength = frames.count;

    //TODO: Update with new drawing
        animator = [KikoAnimator sharedAnimator];
//        self.face = animator.currentFace;

    return self;
}

- (void) setView:(FaceView *)view {
    _view = view;
    //TODO: Update with new drawing
//    [animator updateAnimationWithFacePointsArray:self.faceFrames[0] inView:_view];
}

- (void) playInView:(UIView *)view {
    playbackView = view;
    _isPlaying = true;
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(advanceFrame) userInfo:nil repeats:true];
}

- (void) advanceFrame {
    //TODO: Implement playback
    [animator playFrameWithLayer:_faceFrames.layerArray[currentFrame++ % self.messageLength] inView:playbackView];
//    [animator updateAnimationWithFacePointsArray:_faceFrames[currentFrame++ % self.messageLength] inView:_view];
}

- (void) pause {
    _isPlaying = false;
    [playbackTimer invalidate];
}

- (void) stop {
    _isPlaying = false;
    [playbackTimer invalidate];
    //TODO: Implement playback
//    [animator updateAnimationWithFacePointsArray:self.faceFrames[0]];
}

+ (NSString *)parseClassName {
    return @"KikoMessage";
}

+ (void)load {
    [self registerSubclass];
}

//- (BOOL) save {
//    self.xValues = [NSMutableArray arrayWithCapacity:_faceFrames.count];
//    self.yValues = [NSMutableArray arrayWithCapacity:_faceFrames.count];
//
//    for (int i = 0; i < _faceFrames.count; i++) {
//        NSMutableArray *frameX = [NSMutableArray arrayWithCapacity:(_faceFrames.count)];
//        NSMutableArray *frameY = [NSMutableArray arrayWithCapacity:(_faceFrames.count)];
//
//        for (int j = 0; j < frameX.count; j++) {
//            NSValue* pointValue = ((NSValue*)_faceFrames[i][j]);
//            CGPoint point;
//            [pointValue getValue:&point];
//            frameX[j] = [NSNumber numberWithFloat:point.x];
//            frameY[j] = [NSNumber numberWithFloat:point.y];
//        }
//
//        ((NSMutableArray*)self.xValues)[i] = frameX;
//        ((NSMutableArray*)self.yValues)[i] = frameY;
//    }
//
//    return [super save];
//}


- (BOOL) save {
    return [super save];
}

- (void) saveInBackgroundWithBlock:(PFBooleanResultBlock)block {
    [super saveInBackgroundWithBlock:block];
}

- (id)saveInBackground {
    return [super saveInBackground];
}

- (void)saveEventually:(nullable PFBooleanResultBlock)callback {
    [super saveEventually:callback];
}

- (id)saveEventually {
    return [super saveEventually];
}

//- (void) saveInBackgroundWithBlock:(PFBooleanResultBlock)block {
//    NSLog(@"Save in background");
//}

- (id) fetch {
    KikoMessage *me = [super fetch];

    //TODO: Implement for actual messaging
//    _faceFrames = [NSMutableArray arrayWithCapacity:me.xValues.count];

    for (int i = 0; i < _faceFrames.count; i++) {
        NSMutableArray *frame = [NSMutableArray arrayWithCapacity:((NSArray *)me.xValues[i]).count];

        for (int j = 0; j < frame.count; j++) {
            CGPoint point = CGPointMake(((NSNumber*) me.xValues[i][j]).floatValue, ((NSNumber*) me.yValues[i][j]).floatValue);
            frame[j] = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
        }

        ((NSMutableArray*)_faceFrames)[i] = frame;
    }

    return me;
}

@end
