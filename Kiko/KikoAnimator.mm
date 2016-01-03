//
//  KikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoAnimator.h"
#import "UIBezierPath+Interpolation.h"

@interface KikoAnimator () {
    BOOL paused;
    BOOL isRecording;
    CAShapeLayer *animationLayer;
    NSMutableArray *recording;
    KikoMessage *currentMessage;
}

@end

@implementation KikoAnimator

#define kFaceCurveStart 0
#define kFaceCurveLength 15
#define kRightEyebrowStart 15
#define kRightEyebrowLength 6
#define kLeftEyebrowStart 21
#define kLeftEyebrowLength 6
#define kOuterMouthStart 48
#define kOuterMouthLength 12
#define kRightEyeStart 32
#define kRightEyeLength 4
#define kLeftEyeStart 27
#define kLeftEyeLength 4
#define kNose1Start 37
#define kNose1Length 3
#define kNose2Start 46
#define kNose2Length 2
#define kNose3Start 43
#define kNose3Length 3

static float _cameraWidth;
static float _cameraHeight;
static float _layerWidth;
static float _layerHeight;

+ (id) sharedAnimator {
    static KikoAnimator *sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[KikoAnimator alloc] init];
    });
    
    return sharedAnimator;
}

- (void) setAnimationView:(UIView *)animationView {
    [animationLayer removeFromSuperlayer];
    
    _animationView = animationView;
    [_animationView.layer addSublayer:animationLayer];
    _layerHeight = _animationView.frame.size.height;
    _layerWidth = _animationView.frame.size.width;
    
    animationLayer.frame = CGRectMake(0, 0, _layerWidth, _layerHeight);
    
    paused = false;
}

- (id) init {
    self = [super init];
    
    _cameraHeight = 640;
    _cameraWidth = 480;
    
    animationLayer = [[CAShapeLayer alloc] init];
    
    animationLayer.frame = CGRectMake(0, 0, _layerWidth, _layerHeight);
    [animationLayer setFillColor:[[UIColor clearColor] CGColor]];
    [animationLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    paused = true;
    isRecording = false;
    
    return self;
}

NSValue* getValue (std::shared_ptr<brf::Point> point) {
    CGPoint p = CGPointMake(point->x * _layerWidth/_cameraWidth, point->y *_layerHeight/_cameraHeight);
    
    return [NSValue valueWithBytes:&p objCType:@encode(CGPoint)];
}

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points {
    
    if (!paused) {
    
        std::vector<std::shared_ptr<brf::Point>>::iterator start = points.begin();
        std::vector<std::shared_ptr<brf::Point>>::iterator end = points.end();
        
        std::vector<NSValue*> pointValues(points.size());
        
        std::transform(start, end, pointValues.begin(), getValue);
        
        NSArray *pointsArray = [NSArray arrayWithObjects:&pointValues[0] count:points.size()];
        
        UIBezierPath *facePath = [self createBezierPath:pointsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [animationLayer setPath:facePath.CGPath];
        });
        

        if (isRecording) {
            [recording addObject:facePath];
        }
    }
}


- (UIBezierPath *) createBezierPath:(NSArray *) points {
    UIBezierPath *rightEyePath = [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyeStart, kRightEyeLength)] closed:true];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kFaceCurveStart, kFaceCurveLength)] closed:false]];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kOuterMouthStart, kOuterMouthLength)] closed:true]];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyebrowStart, kRightEyebrowLength)] closed:true]];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyebrowStart, kLeftEyebrowLength)] closed:true]];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyeStart, kLeftEyeLength)] closed:true]];
    
    NSArray *noseArray = [[[points subarrayWithRange:NSMakeRange(37, 3)] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(46, 2)]] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(43, 3)]];
    [rightEyePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:noseArray closed:false]];
    
    return rightEyePath;
}

- (void) pause {
    paused = true;
}

- (void) unpause {
    paused = false;
}

- (UIBezierPath *) getCurrentPath {
   return [UIBezierPath bezierPathWithCGPath: animationLayer.path];
}

- (void) startRecording {
    recording = [NSMutableArray new];
    isRecording = true;
}

- (NSArray *)endRecording {
    isRecording = false;
    NSArray *savedRecording = recording;
    recording = nil;
    return savedRecording;
}

- (void) playMessage:(KikoMessage*)message {
    currentMessage = message;
    [self pause];
    animationLayer.hidden = true;
    [self.animationView.layer addSublayer:message.faceLayer];
    [message play];
}

- (void) stopPlayingMessage {
    [currentMessage stop];
    [currentMessage.faceLayer removeFromSuperlayer];
}

@end
