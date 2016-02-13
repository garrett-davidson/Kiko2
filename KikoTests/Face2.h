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

#import "KikoEyes.h"
#import "Hair_Test.h"

@interface Face2 : PFObject<PFSubclassing>

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
@property (strong, nonatomic) NSMutableArray *hairPathArray;
@property (strong, nonatomic) NSMutableArray *colorArray;


@property (strong, nonatomic) NSArray *hairInfo;

@property (nonatomic) KikoEyes *eyes;
@property (nonatomic) UIBezierPath *leftEyePath;
@property (nonatomic) UIBezierPath *rightEyePath;

@property (nonatomic) Hair_Test *hair;

@property (nonatomic) BOOL is1;
@property (nonatomic) BOOL is14;


- (void) setData:(std::vector< std::shared_ptr<brf::Point>>)pointsVector hairInfo:(NSMutableArray *)hairInfo;
-(UIBezierPath *)createSingleBezierPath;
-(UIBezierPath *) getHairPath;
-(void) initializeArrays;
-(NSMutableArray *) getDataPointArray;
-(NSString *)getColorAtIndex : (int) index;



@end
