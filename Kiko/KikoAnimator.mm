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
    Face2 *currentFace;
    NSMutableArray *hairArray;
    bool isAnimating;
    bool isRecording;
    KikoFaceTracker *KikoFaceTracker;
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
}

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point> >)points {
    currentFace = [[Face2 alloc] initWithData:points :hairArray];
    UIBezierPath *path = [currentFace createSingleBezierPath];
    //UIBezierPath *hairPath = [self.]
    UIBezierPath *hairPath = [currentFace getHairPath];
    NSMutableArray *hairPaths = [currentFace getBezierPathArray];

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
        NSString *string = [currentFace getColorAtIndex:i];
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

    dispatch_async(dispatch_get_main_queue(), ^{
        for (CAShapeLayer *layer in _animationView.layer.sublayers) {
            if (isAnimating) {
                [layer removeFromSuperlayer];
            }
        }

        realtimeFaceLayer.frame = _animationView.bounds;

        if (isAnimating) {
            [[_animationView layer] addSublayer:realtimeFaceLayer];
        }

        [currentFace initializeArrays];
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

- (NSArray *) stopRecording {
    isRecording = false;

    //TODO: Return array with recorded frames
    return nil;
}

@end
