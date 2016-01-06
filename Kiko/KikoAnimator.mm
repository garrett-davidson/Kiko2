//
//  KikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 12/14/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoAnimator.h"
#import "UIBezierPath+Interpolation.h"
#import "User.h"
#import "AnimationOptions.h"

@interface KikoAnimator () {
    BOOL paused;
    BOOL isRecording;
    CAShapeLayer *animationLayer;
    NSMutableArray *recording;
    KikoMessage *currentMessage;
    
    UIImageView *leftEyeImageView;
    UIImageView *rightEyeImageView;
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
    leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, eyeSize, eyeSize)];
    rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, eyeSize, eyeSize)];
    
    User* currentUser = [User currentUser];
    [currentUser addObserver:self forKeyPath:kLeftEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kRightEyeAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    [currentUser addObserver:self forKeyPath:kHairAnimationKey options:NSKeyValueObservingOptionNew context:nil];
    
    NSString *leftEyeImage = currentUser.leftEyeAnimation;
    NSString *rightEyeImage = currentUser.rightEyeAnimation;
    
//    leftEyeImageView.hidden = true;
//    rightEyeImageView.hidden = true;
    
    if (leftEyeImage) {
        leftEyeImageView.image = [UIImage imageNamed:leftEyeImage];
    }
    
    if (rightEyeImage) {
        rightEyeImageView.image = [UIImage imageNamed:rightEyeImage];
    }
    
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
        
        UIBezierPath *facePath = [self createFacePath:pointsArray];
        
        UIBezierPath *leftEyePath = [self getLeftEyePath:pointsArray];
        UIBezierPath *rightEyePath = [self getRightEyePath:pointsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (leftEyeImageView.image) {
                CGRect bounds = CGPathGetBoundingBox(leftEyePath.CGPath);
                leftEyeImageView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) + 10);
            }
            else {
                [facePath appendPath:leftEyePath];
            }
            
            if (rightEyeImageView.image) {
                CGRect bounds = CGPathGetBoundingBox(rightEyePath.CGPath);
                rightEyeImageView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) + 10);
            }
            else {
                [facePath appendPath:rightEyePath];
            }
            
            [animationLayer setPath:facePath.CGPath];
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
    UIBezierPath *facePath = [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kFaceCurveStart, kFaceCurveLength)] closed:false];
    [facePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kOuterMouthStart, kOuterMouthLength)] closed:true]];
    [facePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyebrowStart, kRightEyebrowLength)] closed:true]];
    [facePath appendPath: [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyebrowStart, kLeftEyebrowLength)] closed:true]];

//    UIBezierPath *leftEyePath = [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kLeftEyeStart, kLeftEyeLength)] closed:true];
//    if (!leftEyeImageView.image)
//        [facePath appendPath: leftEyePath];
//    
//    else {
//        leftEyeImageView.frame = CGPathGetBoundingBox(leftEyePath.CGPath);
//    }
//
//    UIBezierPath *rightEyePath = [UIBezierPath interpolateCGPointsWithHermite:[points subarrayWithRange:NSMakeRange(kRightEyeStart, kRightEyeLength)] closed:true];
//    if (!rightEyeImageView.image)
//        [facePath appendPath:rightEyePath];
//    
//    else {
//        rightEyeImageView.frame = CGPathGetBoundingBox(rightEyePath.CGPath);
//    }

    
    NSArray *noseArray = [[[points subarrayWithRange:NSMakeRange(kNose1Start, kNose1Length)] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(kNose2Start, kNose2Length)]] arrayByAddingObjectsFromArray:[points subarrayWithRange:NSMakeRange(kNose3Start, kNose3Length)]];
    [facePath appendPath:[UIBezierPath interpolateCGPointsWithHermite:noseArray closed:false]];
    
    return facePath;
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
