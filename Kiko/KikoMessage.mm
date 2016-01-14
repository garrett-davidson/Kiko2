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
}

@end

@implementation KikoMessage

@dynamic sender, face, faceFrames, messageLength;
@synthesize view = _view, isPlaying = _isPlaying;

- (id)initWithSender:(User *)sender andFrames:(NSArray *)frames {
    self = [KikoMessage object];
    
    self.sender = sender;
    self.faceFrames = frames;
    
    currentFrame = 0;
    self.messageLength = frames.count;

    animator = [KikoAnimator sharedAnimator];
    self.face = [animator getCurrentFace];
    
    return self;
}

- (void) play {
    _isPlaying = true;
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(advanceFrame) userInfo:nil repeats:true];
}

- (void) advanceFrame {
    [animator updateAnimationWithFacePointsArray:self.faceFrames[currentFrame++ % self.messageLength] inView:_view];
}

- (void) pause {
    _isPlaying = false;
    [playbackTimer invalidate];
}

- (void) stop {
    _isPlaying = false;
    [playbackTimer invalidate];
    [animator updateAnimationWithFacePointsArray:self.faceFrames[0]];
}

+ (NSString *)parseClassName {
    return @"KikoMessage";
}

+ (void)load {
    [self registerSubclass];
}

@end
