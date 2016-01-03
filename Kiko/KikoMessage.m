//
//  KikoMessage.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoMessage.h"

@interface KikoMessage () {
    NSArray *faceFrames;
    int currentFrame;
    NSUInteger messageLength;
    NSTimer *playbackTimer;
}

@end

@implementation KikoMessage

- (id)initWithSender:(User *)sender andFrames:(NSArray *)frames {
    self = [super init];
    
    _sender = sender;
    faceFrames = frames;
    
    _faceLayer = [[CAShapeLayer alloc] init];
    
    _faceLayer.frame = CGRectMake(0, 0, 480, 640);
    [_faceLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_faceLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    _faceLayer.path = ((UIBezierPath*)frames[0]).CGPath;
    
    currentFrame = 0;
    messageLength = frames.count;
    
    
    return self;
}

- (void) play {
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(advanceFrame) userInfo:nil repeats:true];
}

- (void) advanceFrame {
    _faceLayer.path = ((UIBezierPath*)faceFrames[currentFrame++ % messageLength]).CGPath;
}

- (void) pause {
    [playbackTimer invalidate];
}

- (void) stop {
    [playbackTimer invalidate];
    _faceLayer.path = ((UIBezierPath*)faceFrames[0]).CGPath;
}

@end
