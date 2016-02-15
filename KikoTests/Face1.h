//
//  Face1.h
//  Kiko
//
//  Created by Rahul Kapur on 2/14/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBezierPath+Interpolation.h"

#import <UIKit/UIKit.h>


#import <iostream>
#import <vector>
#import "Point.hpp"
#import <fstream>

@interface Face1 : NSObject


@property (strong, nonatomic) NSMutableArray *faceCurve;
@property (strong, nonatomic) NSMutableArray *rightEyebrow;
@property (strong, nonatomic) NSMutableArray *leftEyebrow;
@property (strong, nonatomic) NSMutableArray *leftEye;
@property (strong, nonatomic) NSMutableArray *leftPupil;
@property (strong, nonatomic) NSMutableArray *rightEye;
@property (strong, nonatomic) NSMutableArray *rightPupil;
@property (strong, nonatomic) NSMutableArray *nose;
@property (strong, nonatomic) NSMutableArray *tempNose;
@property (strong, nonatomic) NSMutableArray *outerMouth;


-(id)createFaceWithPoints:(std::vector< std::shared_ptr<brf::Point>>)pointsVector;
-(void)createFaceWithPoints:(std::vector< std::shared_ptr<brf::Point>>)pointsVector :(int) beginning :(int) ending;
-(UIBezierPath *)getFaceBezierPath;

@end
