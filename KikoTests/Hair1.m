//
//  Hair1.m
//  Kiko
//
//  Created by Rahul Kapur on 2/14/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "Hair1.h"

@implementation Hair1 {
    
    double XDimensions;
    double YDimensions;
    
    
    CGPoint  bottomPoint;
    CGPoint topMidPoint;
    
    
    CGPoint topLeftOfFaceCurve;
    CGPoint topRightOfFaceCurve;
    
    
    CGPoint initializingPoint;
    CGPoint endingPoint;
    
    
    CGPoint highestPointRight;
    CGPoint highestPointLeft;
    
    BOOL is1;
    BOOL is14;
}

-(void)createHairWithFacePointsAndCSV:(std::vector< std::shared_ptr<brf::Point>>) facePointsVector :(NSMutableArray *) hairCSV {
    
    [self initializers];
    self.hairCSV = hairCSV;
    [self getHairInfoFromCSVArray:hairCSV];
    [self setHairPoints:facePointsVector];
    
}



-(void) getHairInfoFromCSVArray: (NSArray *)parsedCSV {
    XDimensions = [[parsedCSV objectAtIndex:0] doubleValue];
    YDimensions = [[parsedCSV objectAtIndex:1] doubleValue];
    
    if ([[parsedCSV objectAtIndex:2] intValue] == 1) {
        is1 = YES;
    } else {
        is1 = NO;
        
    }
    
    if ([[parsedCSV objectAtIndex:4] intValue] == 14) {
        is14 = YES;
    } else {
        is14 = NO;
        
    }
    
    
}

-(void) setHairPoints :(std::vector< std::shared_ptr<brf::Point>>) pointsVector {
    
    std::vector<std::shared_ptr<brf::Point>>::iterator iter;
    int counter = 0;
    for (iter = pointsVector.begin(); iter < pointsVector.end(); iter++) {
        counter ++;
        std::shared_ptr<brf::Point> point = *iter;
        CGFloat x = point->x;
        CGFloat y = point->y;
        CGPoint pointValue = CGPointMake(x, y);
        
        [self getHairInitializers:pointValue:counter];
        
    }
    
    
    
    
    CGFloat height = [self getFaceHeight];
    CGFloat width = [self getFaceWidth];
    
    
    CGFloat scaleWidth = width/XDimensions;
    CGFloat scaleHeight = height/YDimensions;
    
    self.scaledDataArray = [self getHairPartsArray:scaleHeight :scaleWidth :initializingPoint :endingPoint];
    
    for (int k = 0; k < [self.scaledDataArray count]; k++) {
        NSMutableArray *innerArray = [self.scaledDataArray objectAtIndex:k];
        UIBezierPath *hair = [UIBezierPath interpolateCGPointsWithHermite:innerArray closed:YES];
        [self.scaledBezierPathArray addObject:hair];
        
    }
    
    
}

-(void) getHairInitializers: (CGPoint) point :(int) counter {
    
    if (counter == 8) {
        bottomPoint = point;
    } else if (counter == 1) {
        topLeftOfFaceCurve = point;
    } else if (counter == 15) {
        topRightOfFaceCurve = point;
    } else if (counter == 1 && is1 == YES) {
        initializingPoint = point;
    } else if (counter == 2 && is1 == NO) {
        initializingPoint = point;
    } else if (counter == 14 && is14 == YES) {
        endingPoint = point;
    } else if (counter == 15 && is14 == NO) {
        endingPoint = point;
    } /*else if (counter == 68) {
       faceWidth = [self getDistance:topLeftOfFaceCurve :topRightOfFaceCurve];
       }*/ else if (counter == 18) {
           highestPointLeft = point;
       } else if (counter == 24) {
           highestPointRight = point;
           topMidPoint = [self getMidpoint:highestPointRight :highestPointLeft];
           
       }
    
    
}


-(NSMutableArray *) getHairPartsArray :(CGFloat) heightScalar :(CGFloat) widthScalar :(CGPoint) initializingPoint :(CGPoint) endingPoint{
    
    int numberOfParts = [[self.hairCSV objectAtIndex:3] intValue];
    
    int startIndex = 0;
    int endIndex = 0;
    int partCount = 0;
    
    
    NSString *color = [[NSString alloc] init];
    NSMutableArray *allParts = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < numberOfParts; i++) {
        NSMutableArray *anyPart = [[NSMutableArray alloc] init];
        if (i == 0) {
            startIndex = 9;
            partCount =  [[self.hairCSV objectAtIndex:8] intValue];
            color = [self.hairCSV objectAtIndex:6];
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
                
                yValue = [[self.hairCSV objectAtIndex:j] doubleValue];
                CGPoint point = [self getPoint:(xValue * -1) :(yValue *-1) :widthScalar :heightScalar :initializingPoint];
                const char *encoding = @encode(CGPoint);
                [anyPart addObject:[NSValue valueWithBytes:&point objCType:encoding]];
                
                
            } else {
                xValue = [[self.hairCSV objectAtIndex:j] doubleValue];
            }
            
        }
        [allParts addObject:anyPart];
        [self.hairColorArray addObject:color];
        
        if (i != numberOfParts - 1) {
            partCount = [[self.hairCSV objectAtIndex:(endIndex + 3)] intValue];
            color = [self.hairCSV objectAtIndex:(endIndex + 1)];
            startIndex = endIndex + 4;
            endIndex = startIndex + 2*partCount;
            
        }
    }
    return allParts;
}

-(NSMutableArray *)getHairBezierPathArray {
    return self.scaledBezierPathArray;
}

-(NSMutableArray *)getScaledHairDataArray {
    return self.scaledDataArray;
}

-(int) getBeginning {
    if (is1) {
        return 1;
    } else {
        return 2;
    }
}

-(int) getEnding {
    if (is14) {
        return 14;
    } else {
        return 15;
    }
    
}



-(void) initializers {
    self.hairColorArray = [[NSMutableArray alloc] init];
    self.hairCSV =[[NSMutableArray alloc] init];
    self.scaledBezierPathArray = [[NSMutableArray alloc] init];
    self.scaledDataArray =[[NSMutableArray alloc] init];
}


#pragma mark - Rotation Math


-(CGFloat) getFaceHeight {
    CGFloat height = [self getDistance:bottomPoint :topMidPoint ];
    CGFloat slope = [self getSlope:bottomPoint : topMidPoint];
    CGFloat radians = [self getAngle:slope];
    CGFloat finalHeight = fabs(sin(radians) * height);
    
    return finalHeight;
    
}

-(CGFloat) getFaceWidth {
    
    CGFloat width = [self getDistance:topLeftOfFaceCurve :topRightOfFaceCurve];
    
    return  width;
    
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


-(double)getSlope :(CGPoint) p1 : (CGPoint) p2 {
    double y = p1.y - p2.y;
    double x = p1.x - p2.x;
    
    return (y/x);
}

-(double) getAngle:(CGFloat) slope {
    return atan(slope);
}


-(CGPoint)getPoint:(CGFloat)x :(CGFloat)y :(CGFloat)widthScalar :(CGFloat)heightScalar :(CGPoint)initializingP{
    CGFloat scaledX = x*widthScalar;
    CGFloat scaledY = y*heightScalar;
    
    CGFloat slope = [self getSlope:topLeftOfFaceCurve :topRightOfFaceCurve]  ;
    CGFloat inverseSlope = (1.0/slope) * -1;
    
    CGFloat angleOne = [self getAngle:slope];
    CGFloat angleTwo = [self getAngle:inverseSlope];
    
    
    CGFloat angleOneXComp = cos(angleOne) * scaledX;
    CGFloat angleOneYComp = sin(angleOne) * scaledX;
    CGFloat angleTwoXComp = cos(angleTwo) * scaledY;
    CGFloat angleTwoYComp = sin(angleTwo) * scaledY;
    
    CGPoint finalPoint;
    
    if (slope > 0.0) {
        finalPoint = CGPointMake(initializingP.x + angleOneXComp - angleTwoXComp,  initializingP.y -angleTwoYComp + angleOneYComp);
        
    } else {
        finalPoint = CGPointMake(initializingP.x + angleOneXComp + angleTwoXComp, initializingP.y +angleTwoYComp + angleOneYComp);
    }
    
    return finalPoint;
}





@end
