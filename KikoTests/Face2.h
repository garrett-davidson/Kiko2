//
//  Face.h
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 9/16/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBezierPath+Interpolation.h"

//C++ vector array manipulation methods
#import <iostream>
#import <vector>
#import "Point.hpp"
#import <fstream>



@interface Face2 : NSObject

@property (strong, nonatomic) NSMutableArray *faceCurve;
@property (strong, nonatomic) NSMutableArray *hairCurve;
@property (strong, nonatomic) UIBezierPath *hairBezierPath;

@property (strong, nonatomic) NSMutableArray *rightEyebrow;
@property (strong, nonatomic) NSMutableArray *line;

@property (strong, nonatomic) NSMutableArray *leftEyebrow;
@property (strong, nonatomic) NSMutableArray *leftEye;
@property (strong, nonatomic) NSMutableArray *leftPupil;
@property (strong, nonatomic) NSMutableArray *rightEye;
@property (strong, nonatomic) NSMutableArray *rightPupil;
@property (strong, nonatomic) NSMutableArray *nose;
@property (strong, nonatomic) NSMutableArray *tempNose;
@property (strong, nonatomic) NSMutableArray *outerMouth;

@property (strong, nonatomic) NSMutableArray *dataPoints;
@property (strong, nonatomic) NSMutableArray *bezierPathArray;
@property (strong, nonatomic) NSMutableArray *colorArray;


@property (strong, nonatomic) NSArray *hairInfo;


@property (nonatomic) BOOL is1;
@property (nonatomic) BOOL is14;


-(id) initWithData:(std::vector< std::shared_ptr<brf::Point>>)pointsVector :(NSMutableArray *)hairInfo;
-(id) initWithFrame: (NSArray *)pointsArray;
-(UIBezierPath *)createSingleBezierPath;
-(UIBezierPath *) getHairPath;
-(void) initializeArrays;
-(NSMutableArray *) getDataPointArray;
-(NSMutableArray *) getBezierPathArray;
-(NSString *)getColorAtIndex : (int) index;



@end
