//
//  Face.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KikoEyes.h"
#import "KikoHair.h"

@interface Face : PFObject<PFSubclassing>

@property (nonatomic) UIBezierPath *facePath;
@property (nonatomic) KikoEyes *eyes;
@property (nonatomic) KikoHair *hair;
@property (nonatomic) UIBezierPath *leftEyePath;
@property (nonatomic) UIBezierPath *rightEyePath;

- (id) initWithFacePath:(UIBezierPath *)path leftEyePath:(UIBezierPath *)leftEyePath rightEyePath:(UIBezierPath *)rightEyePath eyes:(KikoEyes*)eyes hair:(KikoHair*)hair;

@end
