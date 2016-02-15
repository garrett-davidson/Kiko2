//
//  Hair1.h
//  Kiko
//
//  Created by Rahul Kapur on 2/14/16.
//  Copyright © 2016 G&R. All rights reserved.
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

@interface Hair1 : NSObject

@property (strong, nonatomic) NSMutableArray *hairCSV;
@property (strong, nonatomic) NSMutableArray *hairColorArray;
@property (strong, nonatomic) NSMutableArray *scaledDataArray;
@property (strong, nonatomic) NSMutableArray *scaledBezierPathArray;




-(void)createHairWithFacePointsAndCSV:(std::vector< std::shared_ptr<brf::Point>>) facePointsVector :(NSMutableArray *) hairCSV;
-(NSMutableArray *)getHairBezierPathArray;
-(NSMutableArray *)getScaledHairDataArray;
-(int) getBeginning;
-(int) getEnding;



@end
