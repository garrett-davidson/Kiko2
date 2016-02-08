//
//  FacesArray.m
//  BRF_NXT_CPP_IOS_EXAMPLES
//
//  Created by Rahul Kapur on 10/8/15.
//  Copyright (c) 2015 Tastenkunst GmbH. All rights reserved.
//

#import "FacesArray.h"

@implementation FacesArray


- (id) init {
    self = [super init];
    if (self) {
        self.timeStampArray = [[NSMutableArray alloc] init];
        self.layerArray = [[NSMutableArray alloc] init];
        self.timeDiffArray = [[NSMutableArray alloc] init];
        self.dataPointArray = [[NSMutableArray alloc] init];
    }
    
    return self;

}

-(void) setLayer: (NSMutableArray *)layerArray :(NSMutableArray *)timDiffArray {
    //self.layerArray = layerArray
    self.layerArray = [[NSMutableArray alloc] initWithArray:layerArray copyItems:YES];
    self.timeDiffArray =  [[NSMutableArray alloc] initWithArray:timDiffArray copyItems:YES];

}

-(void)addLayer:(FaceLayer *)layer :(NSDate*)timeStamp {
    [self.layerArray addObject:layer];
    [self.timeStampArray addObject:timeStamp];
    
}

-(void)addLayer:(FaceLayer *)layer :(NSDate*)timeStamp :(NSMutableArray *)dataPointsArray{
    [self.layerArray addObject:layer];
    [self.timeStampArray addObject:timeStamp];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataPointsArray copyItems:YES];
    [self.dataPointArray addObject:array];
    
}

//Getters

-(FaceLayer *)getCoverLayer {
    return [self.layerArray objectAtIndex:0];
}


-(FaceLayer *)getLayer: (NSUInteger) index {
    return [self.layerArray objectAtIndex:index];
}

-(NSDate *)getTimeStamp: (NSUInteger) index {
    return [self.timeStampArray objectAtIndex:index];
}

-(NSMutableArray *) getDataPointArray {
    return self.dataPointArray;
}

-(NSTimeInterval)getTimeDiff: (NSUInteger) index {
   
    NSTimeInterval interval =[[self.timeDiffArray objectAtIndex:(index)] doubleValue];
    return interval;
}

-(NSUInteger)count {
    return [self.layerArray count];
}

-(NSUInteger) countTime {
    return [self.timeStampArray count];
}

-(void) clear {
    self.timeStampArray = [[NSMutableArray alloc] init];
    self.layerArray = [[NSMutableArray alloc] init];
    self.timeDiffArray = [[NSMutableArray alloc] init];
    self.dataPointArray = [[NSMutableArray alloc] init];
}




-(void)createTimeDiffArray {
    for (int i = 0; i < ([self.timeStampArray  count] - 1); i++) {
        NSTimeInterval interval = [[self getTimeStamp:(i + 1)] timeIntervalSinceDate:[self getTimeStamp:(i)]];
        [self.timeDiffArray addObject:[NSNumber numberWithDouble:interval]];
        
    }
}

-(id) copyWithZone: (NSZone *) zone
{
    
    NSMutableArray *timeStamp = [[NSMutableArray alloc] initWithArray:self.timeStampArray copyItems:YES];
    NSMutableArray *timeDiff = [[NSMutableArray alloc] initWithArray:self.timeDiffArray copyItems:YES];
    NSMutableArray *layer = [[NSMutableArray alloc] initWithArray:self.layerArray copyItems:YES];
    NSMutableArray *dataPoints = [[NSMutableArray alloc] initWithArray:self.dataPointArray copyItems:YES];

    FacesArray *array = [[FacesArray allocWithZone: zone] init];
    array.timeStampArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:timeStamp]];
    array.layerArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:layer]];
    array.timeDiffArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:timeDiff]];
    array.dataPointArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:dataPoints]];
    
    return array;
}


@end
