//
//  KikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "OldKikoAnimator.h"
#import "UIBezierPath+Interpolation.h"
#import "FaceView.h"

#define kLeftEyeAnimationKey @"leftEyeAnimation"
#define kRightEyeAnimationKey @"rightEyeAnimation"
#define kHairAnimationKey @"hairAnimation"

@interface OldKikoAnimator () {
    BOOL paused;
    BOOL isRecording;
    NSMutableArray *recording;
    KikoMessage *currentMessage;
    
    UIBezierPath *facePath;
    UIBezierPath *leftEyePath;
    UIBezierPath *rightEyePath;
    
    FaceView *faceView;
}

@end

@implementation OldKikoAnimator

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
static float _frameWidth;
static float _frameHeight;

+ (id) sharedAnimator {
    static OldKikoAnimator *sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[OldKikoAnimator alloc] init];
    });
    
    return sharedAnimator;
}

- (void) setAnimationView:(UIView *)animationView {
    [faceView removeFromSuperview];
    
    _animationView = animationView;
    [_animationView addSubview:faceView];
    
    CGRect newFrame = _animationView.bounds;
    faceView.frame = newFrame;
    _frameHeight = newFrame.size.height;
    _frameWidth = newFrame.size.width;
    
    faceView.frame = _animationView.bounds;
    faceView.face = [User currentUser].face;
    
    if (!faceView.face) {
        faceView.face = [Face object];
    }
    
    
    paused = false;
}

- (id) init {
    self = [super init];
    
    _cameraHeight = 640;
    _cameraWidth = 480;
    
    faceView = [[FaceView alloc] init];
    
    paused = true;
    isRecording = false;
    
    User* currentUser = [User currentUser];
    [currentUser addObserver:self forKeyPath:kLeftEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kRightEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kHairAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

- (void) setCurrentEyes:(KikoEyes *)currentEyes {
    _currentEyes = currentEyes;
    if (_currentEyes) {
        faceView.face.eyes = _currentEyes;
    }
    
    else {
        faceView.face.eyes = nil;
    }
}

- (void) setCurrentHair:(KikoHair *)currentHair {
    _currentHair = currentHair;
}

NSValue* getValue (std::shared_ptr<brf::Point> point) {
    CGPoint p = CGPointMake(point->x * _frameWidth/_cameraWidth, point->y *_frameHeight/_cameraHeight);
    
    return [NSValue valueWithBytes:&p objCType:@encode(CGPoint)];
}

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point>>) points {
    if (!paused) {
        std::vector<std::shared_ptr<brf::Point>>::iterator start = points.begin();
        std::vector<std::shared_ptr<brf::Point>>::iterator end = points.end();
        
        std::vector<NSValue*> pointValues(points.size());
        
        std::transform(start, end, pointValues.begin(), getValue);
        
        NSArray *pointsArray = [NSArray arrayWithObjects:&pointValues[0] count:points.size()];

        [self updateAnimationWithFacePointsArray:pointsArray];
    }
}

- (void) updateAnimationWithFacePointsArray:(NSArray *)pointsArray {
    [self updateAnimationWithFacePointsArray:pointsArray inView:faceView];
}

- (void) updateAnimationWithFacePointsArray:(NSArray *)pointsArray inView: (FaceView*)view {
    facePath = [self createFacePath:pointsArray];

    leftEyePath = [self getLeftEyePath:pointsArray];
    rightEyePath = [self getRightEyePath:pointsArray];

    view.face.facePath = facePath;
    view.face.leftEyePath = leftEyePath;
    view.face.rightEyePath = rightEyePath;

    dispatch_async(dispatch_get_main_queue(), ^{
//        [view redrawWithFaceFrame:CGPathGetBoundingBox(facePath.CGPath)];
        if (view == faceView)
            view.frame = CGPathGetBoundingBox(facePath.CGPath);
//            [view redraw2];

        else {
            view.frame.size = CGPathGetBoundingBox(facePath.CGPath).size;
            [view redraw];
        }
    });

    if (isRecording) {
        [recording addObject:pointsArray];
    }
}


- (UIBezierPath *) getLeftEyePath:(NSArray *) points {
    return [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyeStart, kLeftEyeLength)] closed:true];
}

- (UIBezierPath *) getRightEyePath:(NSArray *) points {
    return [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyeStart, kRightEyeLength)] closed:true];
}

- (UIBezierPath *) createFacePath:(NSArray *) points {
    UIBezierPath *newFacePath = [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kFaceCurveStart, kFaceCurveLength)] closed:false];
    [newFacePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kOuterMouthStart, kOuterMouthLength)] closed:true]];
    [newFacePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyebrowStart, kRightEyebrowLength)] closed:true]];
    [newFacePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyebrowStart, kLeftEyebrowLength)] closed:true]];
    
    NSArray *noseArray = [[[points subarrayWithRange:NSMakeRange(kNose1Start, kNose1Length)] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(kNose2Start, kNose2Length)]] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(kNose3Start, kNose3Length)]];
    [newFacePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:noseArray closed:false]];
    
    return newFacePath;
}

- (void) pause {
    paused = true;
}

- (void) unpause {
    paused = false;
}

- (Face *) getCurrentFace {
    return [[Face alloc] initWithFacePath:facePath leftEyePath:leftEyePath rightEyePath:rightEyePath eyes:_currentEyes hair:_currentHair];
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
    [self playMessage:message inCurrentView:false];
}

- (void) playMessage:(KikoMessage *)message inCurrentView:(BOOL) inCurrentView {
    if (inCurrentView) {
        message.view = faceView;
    }

    currentMessage = message;
    [self pause];
    faceView.face = message.face;
//    [message play];
}

- (void) stopPlayingMessage {
    [currentMessage stop];
}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:kLeftEyeAnimationKey]) {
//        leftEyeImageView.image = [UIImage imageNamed:[change objectForKey:NSKeyValueChangeNewKey]];
//    }
//    
//    else if ([keyPath isEqualToString:kRightEyeAnimationKey]) {
//        rightEyeImageView.image = [UIImage imageNamed:[change objectForKey:NSKeyValueChangeNewKey]];
//    }
//    
//    else if ([keyPath isEqualToString:kHairAnimationKey]) {
//
//    }
//}

@end
