//
//  NewKikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoAnimator.h"
#import "FaceLayer.h"
#import <Parse/Parse.h>
#import "KikoFaceTracker.h"

@interface KikoAnimator() {
    NSMutableArray *hairArray;
    bool isAnimating;
    bool isRecording;
    KikoFaceTracker *KikoFaceTracker;

    FacesArray *recordedFace;

    KikoMessage *currentMessage;
}

@end

@implementation KikoAnimator

-(void) populateCSV: (NSMutableArray *)csvArr :(NSURL *) url {
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    NSString *newString = [string stringByReplacingOccurrencesOfString:@",,," withString:@""];

    NSString *stringWithoutSpaces = [newString stringByReplacingOccurrencesOfString:@",," withString:@""];

    NSArray* lines = [stringWithoutSpaces componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    hairArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < [lines count]; i++) {
        NSString *string = [lines objectAtIndex:i];
        NSArray *array = [string componentsSeparatedByString:@","];
        for (int j = 0; j < [array count]; j++) {
            [hairArray addObject:[array objectAtIndex:j]];
        }
    }
}

- (void)viewDidLoad {
    PFQuery *query = [PFQuery queryWithClassName:@"Hair_Test"];
    [query whereKey:@"objectId" equalTo:@"vvBNXlXKj2"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"hair_1"];
            NSURL *url = [NSURL URLWithString:file.url];
            [self populateCSV:nil :url];
        }
        else {
            NSLog(@"Parse error: %@", error);
        }
    }];

    recordedFace = [[FacesArray alloc] init];
}

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point> >)points {
    _currentFace = [[Face2 alloc] initWithData:points :hairArray];
    UIBezierPath *path = [_currentFace createSingleBezierPath];
    //UIBezierPath *hairPath = [self.]
    UIBezierPath *hairPath = [_currentFace getHairPath];
    NSMutableArray *hairPaths = [_currentFace getBezierPathArray];

    CAShapeLayer *faceLayer = [[CAShapeLayer alloc] init];
    faceLayer.frame = CGRectMake(0, 0, 480.0, 640.0);
    [faceLayer setFillColor:[[UIColor clearColor] CGColor]];
    [faceLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [faceLayer setPath: path.CGPath];

    FaceLayer *realtimeFaceLayer = [[FaceLayer alloc] init];
    realtimeFaceLayer.name = @"Layer";
    [realtimeFaceLayer addSublayer:faceLayer];

    for (int i = 0; i < [hairPaths count]; i++) {
        UIBezierPath *hairBezier = [hairPaths objectAtIndex:i];
        CAShapeLayer *hair = [[CAShapeLayer alloc] init];
        hair.frame = CGRectMake(0, 0, 480.0, 640.0);
        NSString *string = [_currentFace getColorAtIndex:i];
        if ([string isEqualToString:@"DARK"]) {
            [hair setFillColor:[UIColor yellowColor].CGColor];

        } else {
            [hair setFillColor:[UIColor yellowColor].CGColor];
        }
        [hair setStrokeColor:[[UIColor blackColor] CGColor]];
        [hair setPath: hairBezier.CGPath];
        [realtimeFaceLayer addSublayer:hair];

    }

    CAShapeLayer *hairLayer = [[CAShapeLayer alloc] init];
    hairLayer.frame = CGRectMake(0, 0, 480.0, 640.0);
    [hairLayer setFillColor:[[UIColor yellowColor] CGColor]];
    [hairLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [hairLayer setPath: hairPath.CGPath];

    if (isAnimating) {
        [self playFrameWithLayer:realtimeFaceLayer inView:_animationView];

        if (isRecording) {
            [recordedFace addLayer:realtimeFaceLayer :[NSDate dateWithTimeIntervalSinceNow:0]];
        }

    }
}

- (void) playFrameWithLayer:(FaceLayer *) frameLayer inView:(UIView *)playbackView {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (CAShapeLayer *layer in playbackView.layer.sublayers) {
            [layer removeFromSuperlayer];
        }

        frameLayer.frame = _animationView.bounds;
        [[playbackView layer] addSublayer:frameLayer];


        [_currentFace initializeArrays];
    });
}

+ (KikoAnimator*) sharedAnimator {
    static KikoAnimator *sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[KikoAnimator alloc] init];
        [sharedAnimator viewDidLoad];
    });

    return sharedAnimator;
}

- (void) pause {
    isAnimating = false;
    isRecording = false;
}

- (void) unpause {
    isAnimating = true;
}

- (void) startRecording {
    isRecording = true;
}

- (FacesArray *) stopRecording {
    isRecording = false;

    FacesArray *finishedRecording = recordedFace;

    recordedFace = [[FacesArray alloc] init];

    return finishedRecording;
}

- (void) playMessage:(KikoMessage *)message {
    [self playMessage:message inView:_animationView];
}

- (void) playMessage: (KikoMessage *)message inView:(UIView *)view {
    currentMessage = message;
    [self pause];
    [message playInView:view];
}

- (void) stopPlayingMessage {
    [self unpause];
    [currentMessage stop];
}

@end
