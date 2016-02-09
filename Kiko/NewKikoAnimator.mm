//
//  NewKikoAnimator.m
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "NewKikoAnimator.h"

@implementation NewKikoAnimator

- (void) updateAnimationWithFacePoints:(std::vector<std::shared_ptr<brf::Point> >)points {

}

+ (id) sharedAnimator {
    static NewKikoAnimator *sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[NewKikoAnimator alloc] init];
    });

    return sharedAnimator;
}

@end
