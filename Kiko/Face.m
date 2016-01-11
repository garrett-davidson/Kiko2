//
//  Face.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "Face.h"

@interface Face()

@property (nonatomic) NSData *pathData;
@property (nonatomic) NSData *leftEyePathData;
@property (nonatomic) NSData *rightEyePathData;

@end

@implementation Face

@dynamic eyes, hair, pathData, leftEyePathData, rightEyePathData;

- (id) initWithFacePath:(UIBezierPath *)path leftEyePath:(UIBezierPath *)leftEyePath rightEyePath:(UIBezierPath *)rightEyePath eyes:(KikoEyes *)eyes hair:(KikoHair *)hair {
    self = [Face object];
    self.facePath = path;
    self.eyes = eyes;
    self.hair = hair;
    self.leftEyePath = leftEyePath;
    self.rightEyePath = rightEyePath;
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.facePath forKey:@"path"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self.facePath = [aDecoder decodeObjectForKey:@"path"];
    
    return self;
}

+ (NSString*) parseClassName {
    return @"KikoFace";
}

+ (void)load {
    [self registerSubclass];
}

- (void) setFacePath:(UIBezierPath *)facePath {
    self.pathData = [NSKeyedArchiver archivedDataWithRootObject:facePath];
}

- (UIBezierPath *)facePath {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self fetchIfNeeded].pathData];
}

- (void) setLeftEyePath:(UIBezierPath *)leftEyePath {
    self.leftEyePathData = [NSKeyedArchiver archivedDataWithRootObject:leftEyePath];
}

- (UIBezierPath *)leftEyePath {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.leftEyePathData];
}

- (void) setRightEyePath:(UIBezierPath *)rightEyePath {
    self.rightEyePathData = [NSKeyedArchiver archivedDataWithRootObject:rightEyePath];
}

- (UIBezierPath *)rightEyePath {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.rightEyePathData];
}

@end
