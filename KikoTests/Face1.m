//
//  Face1.m
//  Kiko
//
//  Created by Rahul Kapur on 2/14/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "Face1.h"

@implementation Face1 {
    int beginning;
    int ending;
}

-(void)createFaceWithPoints:(std::vector< std::shared_ptr<brf::Point>>)pointsVector {
    [self createFaceWithPoints:pointsVector :1 :15];
}

-(void)createFaceWithPoints:(std::vector< std::shared_ptr<brf::Point>>)pointsVector :(int) beginningValue :(int) endingValue {
    
    [self initialize];
    [self setBeginningAndEnding:beginningValue :endingValue];
    [self setFacePoints: pointsVector];
    
    
    
    
}






-(void) setFacePoints :(std::vector< std::shared_ptr<brf::Point>>) pointsVector {
    std::vector<std::shared_ptr<brf::Point>>::iterator iter;
    int counter = 0;
    for (iter = pointsVector.begin(); iter < pointsVector.end(); iter++) {
        counter ++;
        std::shared_ptr<brf::Point> point = *iter;
        CGFloat x = point->x;
        CGFloat y = point->y;
        
        [self populateFaceArrays: x :y :counter];
        
    }
    
    
    
    
    
}



- (void)populateFaceArrays:(CGFloat)x :(CGFloat)y :(int)counter {
    const char *encoding = @encode(CGPoint);
    
    if (counter >= 1 && counter <= 15) {
        CGPoint point = CGPointMake(x, y);
        int beginning = [self getBeginningOfFaceCurve];
        int ending = [self getEndingOfFaceCurve];
        if (counter >= beginning && counter <= ending) {
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
    
    
}



-(UIBezierPath *)getFaceBezierPath {
    UIBezierPath *faceCurvePath = [UIBezierPath interpolateCGPointsWithHermite:self.faceCurve closed:NO];
    UIBezierPath *rightEyePath = [UIBezierPath interpolateCGPointsWithHermite:self.rightEye closed:YES];
    UIBezierPath *outerMouthPath = [UIBezierPath interpolateCGPointsWithHermite:self.outerMouth closed:YES];
    UIBezierPath *rightEyebrowPath = [UIBezierPath interpolateCGPointsWithHermite:self.rightEyebrow closed:YES];
    UIBezierPath *leftEyebrowPath = [UIBezierPath interpolateCGPointsWithHermite:self.leftEyebrow closed:YES];
    UIBezierPath *leftEyePath = [UIBezierPath interpolateCGPointsWithHermite:self.leftEye closed:YES];
    UIBezierPath *nosePath = [UIBezierPath interpolateCGPointsWithHermite:self.nose closed:NO];
    
    
    [faceCurvePath appendPath:rightEyePath];
    [faceCurvePath appendPath:leftEyePath];
    
    
    [faceCurvePath appendPath:outerMouthPath];
    [faceCurvePath appendPath:rightEyebrowPath];
    [faceCurvePath appendPath:leftEyebrowPath];
    [faceCurvePath appendPath:nosePath];
    
    
    return faceCurvePath;
}



-(void)setBeginningAndEnding:(int) beginningValue :(int) endingValue {
    beginning = beginningValue;
    ending = endingValue;
}


-(int)getBeginningOfFaceCurve {
    return beginning;
}

-(int) getEndingOfFaceCurve {
    return ending;
}


-(void)initialize {
    
    self.faceCurve = [NSMutableArray new];
    self.rightEye = [NSMutableArray new];
    self.rightEyebrow = [NSMutableArray new];
    self.rightPupil = [NSMutableArray new];
    self.leftEye = [NSMutableArray new];
    self.leftPupil = [NSMutableArray new];
    self.leftEyebrow = [NSMutableArray new];
    self.outerMouth =[NSMutableArray new];
    self.nose = [NSMutableArray new];
    self.tempNose = [NSMutableArray new];
    
}

@end
