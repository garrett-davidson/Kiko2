//
//  FacesArray.h
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 10/8/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceLayer.h"

@interface FacesArray : NSObject <NSCopying>


@property (strong, nonatomic) NSMutableArray *layerArray;
@property (strong, nonatomic) NSMutableArray *timeStampArray;
@property (strong, nonatomic) NSMutableArray *timeDiffArray;
@property (strong, nonatomic) NSMutableArray *dataPointArray;
@property (nonatomic) BOOL isMessage;

-(void) setLayer: (NSMutableArray *)layerArray :(NSMutableArray *)timDiffArray;
-(void)addLayer:(FaceLayer *)layer :(NSDate*)timeStamp;
-(void)addLayer:(FaceLayer *)layer :(NSDate*)timeStamp :(NSMutableArray *)dataPointsArray;
-(FaceLayer *)getCoverLayer;
-(FaceLayer *)getLayer: (NSUInteger) index;
-(NSMutableArray *) getDataPointArray;
-(NSDate *)getTimeStamp: (NSUInteger) index;
-(NSTimeInterval)getTimeDiff: (NSUInteger) index;
-(void)isMessage:(BOOL)isAMessage;
-(NSUInteger)count;
-(NSUInteger) countTime;
-(void) clear;
-(void)createTimeDiffArray;


@end
