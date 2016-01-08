//
//  KikoEyes.m
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoEyes.h"

@interface KikoEyes () {
    UIImage *leftEyeImage;
    UIImage *rightEyeImage;
}

@end

@implementation KikoEyes

@dynamic name, leftEyeFile, rightEyeFile;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"KikoEyes";
}

- (UIImage *) getLeftEyeImage {
    if (!leftEyeImage) {
        leftEyeImage = [UIImage imageWithData:[self.leftEyeFile getData]];
    }
    return leftEyeImage;
}

- (UIImage *) getRightEyeImage {
    if (!rightEyeImage) {
        rightEyeImage = [UIImage imageWithData:[self.rightEyeFile getData]];
    }
    return rightEyeImage;
}

- (id) initWithName:(NSString *)name leftEyeFileName:(NSString *)leftEyeFileName rightEyeFileName:(NSString *)rightEyeFileName {
    self = [KikoEyes object];
    self.name = name;
    self.leftEyeFile = [PFFile fileWithData:UIImagePNGRepresentation([UIImage imageNamed:leftEyeFileName])];
    self.rightEyeFile = [PFFile fileWithData:UIImagePNGRepresentation([UIImage imageNamed:rightEyeFileName])];
    
    return self;
}

@end
