//
//  KikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoAnimator.h"
#import "UIBezierPath+Interpolation.h"

#define kLeftEyeAnimationKey @"leftEyeAnimation"
#define kRightEyeAnimationKey @"rightEyeAnimation"
#define kHairAnimationKey @"hairAnimation"

@interface KikoAnimator () {
    BOOL paused;
    BOOL isRecording;
    CAShapeLayer *animationLayer;
    NSMutableArray *recording;
    KikoMessage *currentMessage;
    
    UIImageView *leftEyeImageView;
    UIImageView *rightEyeImageView;
    
    UIBezierPath *facePath;
    UIBezierPath *leftEyePath;
    UIBezierPath *rightEyePath;
    UIBezierPath *drawingPath;
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
    
    [animationView addSubview:leftEyeImageView];
    [animationView addSubview:rightEyeImageView];
    
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
    
    int eyeSize = 20;
    leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, eyeSize, eyeSize)];
    rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, eyeSize, eyeSize)];
    
    User* currentUser = [User currentUser];
    [currentUser addObserver:self forKeyPath:kLeftEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kRightEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kHairAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

- (void) setCurrentEyes:(KikoEyes *)currentEyes {
    _currentEyes = currentEyes;
    if (_currentEyes) {
        leftEyeImageView.image = [_currentEyes getLeftEyeImage];
        rightEyeImageView.image = [_currentEyes getRightEyeImage];
        leftEyeImageView.hidden = false;
        rightEyeImageView.hidden = false;
    }
    
    else {
        leftEyeImageView.image = nil;
        rightEyeImageView.image = nil;
        leftEyeImageView.hidden = true;
        rightEyeImageView.hidden = true;
    }
}

- (void) setCurrentHair:(KikoHair *)currentHair {
    _currentHair = currentHair;
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
        
        facePath = [self createFacePath:pointsArray];
        drawingPath = [facePath copy];
        
        leftEyePath = [self getLeftEyePath:pointsArray];
        rightEyePath = [self getRightEyePath:pointsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (leftEyeImageView.image) {
                CGRect bounds = CGPathGetBoundingBox(leftEyePath.CGPath);
                leftEyeImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.width);
            }
            else {
                [drawingPath appendPath:leftEyePath];
            }
            
            if (rightEyeImageView.image) {
                CGRect bounds = CGPathGetBoundingBox(rightEyePath.CGPath);
                rightEyeImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.width);
            }
            else {
                [drawingPath appendPath:rightEyePath];
            }
            
            [animationLayer setPath:drawingPath.CGPath];
        });
        
        if (isRecording) {
            [recording addObject:facePath];
        }
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
    currentMessage = message;
    [self pause];
    animationLayer.hidden = true;
    [self.animationView.layer addSublayer:[message getFaceLayer]];
    [message play];
}

- (void) stopPlayingMessage {
    [currentMessage stop];
    [[currentMessage getFaceLayer] removeFromSuperlayer];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kLeftEyeAnimationKey]) {
        leftEyeImageView.image = [UIImage imageNamed:[change objectForKey:NSKeyValueChangeNewKey]];
    }
    
    else if ([keyPath isEqualToString:kRightEyeAnimationKey]) {
        rightEyeImageView.image = [UIImage imageNamed:[change objectForKey:NSKeyValueChangeNewKey]];
    }
    
    else if ([keyPath isEqualToString:kHairAnimationKey]) {
        
    }
}

@end
