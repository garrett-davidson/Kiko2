//
//  Face.m
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 9/16/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import "Face2.h"
#import <Parse/Parse.h>


@implementation Face2 {
    double preXDimensions;
    double preYDimensions;
    CGPoint  bottomPoint;
    CGPoint topMidPoint;
    CGPoint  vertSlopeP2;
    CGPoint extendingPoint;
    CGFloat  verticalSlope;
    CGFloat horizontalSlope;
    CGPoint topLeftOfFaceCurve;
    CGPoint topRightOfFaceCurve;
    double faceWidth;
    double faceHeight;
    CGPoint initializingPoint;
    CGPoint endingPoint;
}

@synthesize is1, is14;

- (void) setData:(std::vector< std::shared_ptr<brf::Point>>)pointsVector hairInfo:(NSMutableArray *)hairInfo {
    [self initializeArrays];

    self.hairInfo = hairInfo;

    NSString *stringX = [hairInfo objectAtIndex:0];
    NSString *stringY = [hairInfo objectAtIndex:1];

    preXDimensions = [stringX doubleValue];
    preYDimensions = [stringY doubleValue];

    if ([[hairInfo objectAtIndex:2] intValue] == 1) {
        is1 = YES;
    } else {
        is1 = NO;

    }

    if ([[hairInfo objectAtIndex:4] intValue] == 14) {
        is14 = YES;
    } else {
        is14 = NO;

    }

    std::vector<std::shared_ptr<brf::Point>>::iterator iter;
    int counter = 0;
    for (iter = pointsVector.begin(); iter < pointsVector.end(); iter++) {
        counter ++;
        std::shared_ptr<brf::Point> point = *iter;
        CGFloat x = point->x;
        CGFloat y = point->y;
        NSNumber *xValue = [NSNumber numberWithFloat:x];
        NSNumber *yValue = [NSNumber numberWithFloat:y];
        [self storeDataPoints:xValue :yValue];
        [self addToArray:x :y :counter];
        if (counter == 18 || counter == 24) {
            CGPoint point24;
            CGPoint point18;
            if (counter == 24) {
                point24 = CGPointMake(x,y);
                topMidPoint = [self getMidpoint:point24 :point18];
            } else {
                point18 = CGPointMake(x,y);
            }
        }
    }
}

-(CGPoint)getPoint:(CGFloat)x :(CGFloat)y :(CGFloat)widthScalar :(CGFloat)heightScalar :(CGPoint)initializingP{
    CGFloat scaledX = x*widthScalar;
    CGFloat scaledY = y*heightScalar;
    CGFloat slope = [self getSlope:topLeftOfFaceCurve :topRightOfFaceCurve]  ;
    //NSLog(@"This is the slope %f", slope);
    CGFloat inverseSlope = (1.0/slope) * -1;
    CGFloat angleOne = [self getAngle:slope];
    //NSLog(@"This is angle one %f", angleOne);
    CGFloat angleTwo = [self getAngle:inverseSlope];
    //NSLog(@"This is angle two %f", angleTwo);
    CGFloat angleOneXComp;
    CGFloat angleOneYComp ;
    CGFloat angleTwoXComp ;
    CGFloat angleTwoYComp ;

    angleOneXComp = cos(angleOne) * scaledX;
    angleOneYComp = sin(angleOne) * scaledX;
    angleTwoXComp = cos(angleTwo) * scaledY;
    angleTwoYComp = sin(angleTwo) * scaledY;

    CGPoint finalPoint;

    if (slope > 0.0) {
        finalPoint = CGPointMake(initializingP.x + angleOneXComp - angleTwoXComp,  initializingP.y -angleTwoYComp + angleOneYComp);

    } else {
        finalPoint = CGPointMake(initializingP.x + angleOneXComp + angleTwoXComp, initializingP.y +angleTwoYComp + angleOneYComp);
    }

    return finalPoint;
}




-(NSMutableArray *) createHair :(CGFloat) heightScalar :(CGFloat) widthScalar :(CGPoint) initializingPoint :(CGPoint) endingPoint{
    int numberOfParts = [[self.hairInfo objectAtIndex:3] intValue];

    int startIndex = 0;
    int endIndex = 0;
    int partCount = 0;
    NSString *color = [[NSString alloc] init];
    NSMutableArray *allParts = [[NSMutableArray alloc]init];
    for (int i = 0; i < numberOfParts; i++) {
        NSMutableArray *anyPart = [[NSMutableArray alloc] init];
        if (i == 0) {
            startIndex = 9;
            partCount =  [[self.hairInfo objectAtIndex:8] intValue];
            color = [self.hairInfo objectAtIndex:6];
            endIndex = startIndex + 2*partCount;
            const char *encoding = @encode(CGPoint);
            [anyPart addObject:[NSValue valueWithBytes:&initializingPoint objCType:encoding]];

        }

        int loopCounter = 0;

        double xValue = 0.0;
        double yValue = 0.0;


        for (int j = startIndex; j < endIndex; j++) {
            loopCounter++;
            if (loopCounter%2 == 0) {

                yValue = [[self.hairInfo objectAtIndex:j] doubleValue];
                CGPoint point = [self getPoint:(xValue * -1) :(yValue *-1) :widthScalar :heightScalar :initializingPoint];
                const char *encoding = @encode(CGPoint);
                [anyPart addObject:[NSValue valueWithBytes:&point objCType:encoding]];


            } else {
                xValue = [[self.hairInfo objectAtIndex:j] doubleValue];
            }

        }
        [allParts addObject:anyPart];
        [self.colorArray addObject:color];

        if (i != numberOfParts - 1) {
            partCount = [[self.hairInfo objectAtIndex:(endIndex + 3)] intValue];
            color = [self.hairInfo objectAtIndex:(endIndex + 1)];
            startIndex = endIndex + 4;
            endIndex = startIndex + 2*partCount;

        }
    }
    return allParts;
}


-(void)addToArray:(CGFloat)x :(CGFloat)y :(int) counter {
    const char *encoding = @encode(CGPoint);
    if (counter >= 1 && counter <= 15) {

        CGPoint point = CGPointMake(x, y);
        if (counter == 8) {
            bottomPoint = point;
        }
        if (counter == 1) {
            topLeftOfFaceCurve = point;

        }

        if (counter == 15) {
            topRightOfFaceCurve = point;

        }

        if (counter == 1 && is1 == YES) {
            initializingPoint = point;
        }

        if (counter == 2 && is1 == NO) {
            initializingPoint = point;
        }

        if (counter == 14 && is14 == YES) {
            endingPoint = point;
        }

        if (counter == 15 && is14 == NO) {
            endingPoint = point;
        }

        if ((counter >= [[self.hairInfo objectAtIndex:2] intValue]) && (counter <= [[self.hairInfo objectAtIndex:4] intValue])) {
            [self.faceCurve addObject:[NSValue valueWithBytes:&point objCType:encoding]];

        }
    } else if (counter >= 16 && counter <= 20){
        CGPoint point = CGPointMake(x, y);
        [self.rightEyebrow addObject:[NSValue valueWithBytes:&point objCType:encoding]];
    } else if (counter >= 22 && counter <= 27) {
        CGPoint point = CGPointMake(x, y);
        [self.leftEyebrow addObject:[NSValue valueWithBytes:&point objCType:encoding]];
    } else if (counter >= 49 && counter <= 60) {
        CGPoint point = CGPointMake(x, y);
        [self.outerMouth addObject:[NSValue valueWithBytes:&point objCType:encoding]];
    } else if (counter >= 33 && counter <= 36) {
        CGPoint point = CGPointMake(x, y);
        [self.rightEye addObject:[NSValue valueWithBytes:&point objCType:encoding]];
    } else if (counter >= 28  && counter <= 31) {
        CGPoint point = CGPointMake(x, y);
        [self.leftEye addObject:[NSValue valueWithBytes:&point objCType:encoding]];
    } else if ((counter >= 38 && counter <= 40) || (counter >=47 && counter <= 48)|| (counter >=44 && counter <= 46)) {
        CGPoint point = CGPointMake(x, y);
        if (counter >=44 && counter <= 46) {
            [self.tempNose addObject:[NSValue valueWithBytes:&point objCType:encoding]];
        } else {
            [self.nose addObject:[NSValue valueWithBytes:&point objCType:encoding]];
            if (counter == 48) {
                [self.nose addObjectsFromArray:self.tempNose];
            }
        }
    }

    if (counter == 68) {
        faceWidth = [self getDistance:topLeftOfFaceCurve :topRightOfFaceCurve];
    }
}


- (double) getDistance : (CGPoint) p1 : (CGPoint) p2 {

    double dx = (p1.x-p2.x);
    double dy = (p1.y-p2.y);
    double dist = sqrt(dx*dx + dy*dy);
    return dist;
}

-(CGPoint) getMidpoint : (CGPoint) p1 : (CGPoint) p2 {


    double xMid = (p1.x + p2.x)/2.0;
    double yMid = (p1.y +p2.y)/2.0;
    CGFloat x = xMid;
    CGFloat y = yMid;
    return CGPointMake(x, y);
}


-(UIBezierPath *)createSingleBezierPath {
    UIBezierPath *faceCurvePath = [UIBezierPath interpolateCGPointsWithHermite:self.faceCurve closed:NO];
    UIBezierPath *rightEyePath = [UIBezierPath interpolateCGPointsWithHermite:self.rightEye closed:YES];



    UIBezierPath *outerMouthPath = [UIBezierPath interpolateCGPointsWithHermite:self.outerMouth closed:YES];
    UIBezierPath *rightEyebrowPath = [UIBezierPath interpolateCGPointsWithHermite:self.rightEyebrow closed:YES];
    UIBezierPath *leftEyebrowPath = [UIBezierPath interpolateCGPointsWithHermite:self.leftEyebrow closed:YES];
    UIBezierPath *leftEyePath = [UIBezierPath interpolateCGPointsWithHermite:self.leftEye closed:YES];
    UIBezierPath *nosePath = [UIBezierPath interpolateCGPointsWithHermite:self.nose closed:NO];

    _leftEyePath = leftEyePath;
    _rightEyePath = rightEyePath;

    if (!_eyes) {
        [faceCurvePath appendPath:rightEyePath];
        [faceCurvePath appendPath:leftEyePath];
    }

    [faceCurvePath appendPath:outerMouthPath];
    [faceCurvePath appendPath:rightEyebrowPath];
    [faceCurvePath appendPath:leftEyebrowPath];
    [faceCurvePath appendPath:nosePath];

    CGFloat height = [self getDistance:bottomPoint :topMidPoint ];

    CGFloat slope = [self getSlope:bottomPoint : topMidPoint];
    CGFloat radians = [self getAngle:slope];
    CGFloat finalHeight = fabs(sin(radians) * height);

    CGFloat width = faceWidth;


    CGFloat scaleWidth1 = width/preXDimensions;
    CGFloat scaleHeight1 = finalHeight/preYDimensions;

    NSMutableArray *array = [self createHair:scaleHeight1 :scaleWidth1 :initializingPoint :endingPoint];
    for (int k = 0; k < [array count]; k++) {
        NSMutableArray *innerArray = [array objectAtIndex:k];
        UIBezierPath *hair = [UIBezierPath interpolateCGPointsWithHermite:innerArray closed:YES];
        [self.hairPathArray addObject:hair];

    }
    return faceCurvePath;
}

-(double)getSlope :(CGPoint) p1 : (CGPoint) p2 {
    double y = p1.y - p2.y;
    double x = p1.x - p2.x;

    return (y/x);
}

-(double) getAngle:(CGFloat) slope {
    return atan(slope);
}

-(NSString *)getColorAtIndex : (int) index {
    return [self.colorArray objectAtIndex:index];
}

-(UIBezierPath *) getHairPath {
    return self.hairBezierPath;
}

-(NSMutableArray *) gethairPathArray {
    return self.hairPathArray;
}

-(void) initializeArrays {
    self.faceCurve = [NSMutableArray new];
    self.hairCurve = [NSMutableArray new];
    self.rightEye = [NSMutableArray new];
    self.rightEyebrow = [NSMutableArray new];
    self.rightPupil = [NSMutableArray new];
    self.leftEye = [NSMutableArray new];
    self.leftPupil = [NSMutableArray new];
    self.leftEyebrow = [NSMutableArray new];
    self.outerMouth =[NSMutableArray new];
    self.nose = [NSMutableArray new];
    self.tempNose = [NSMutableArray new];
    self.dataPoints = [NSMutableArray new];
    self.hairPathArray = [NSMutableArray new];
    self.colorArray = [NSMutableArray new];

}

-(void)storeDataPoints : (NSNumber *) xValue : (NSNumber *) yValue{
    [self.dataPoints addObject:xValue];
    [self.dataPoints addObject:yValue];
}

-(NSMutableArray *) getDataPointArray {
    return self.dataPoints;
}

@end

