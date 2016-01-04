//
//  User.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@interface User() {
    Face *userFace;
}

@property (nonatomic) NSData *faceData;


@end

@implementation User

@dynamic name, faceData, friends;

+ (id) getCurrentUser {
    PFUser *currentUser = [PFUser currentUser];
    
    if ([currentUser isMemberOfClass:User.self]) {
        return currentUser;
    }
    
    return nil;
}

+ (void)load {
    [self registerSubclass];
    [self enableAutomaticUser];
}

- (CAShapeLayer *) getImage {
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:userFace.path.CGPath];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    return layer;
}

- (Face*) getFace {
    if (!userFace) {
        userFace = [NSKeyedUnarchiver unarchiveObjectWithData:self.faceData];
    }
    return userFace;
}

- (void) setFace:(Face *) face {
    userFace = face;
    self.faceData = [NSKeyedArchiver archivedDataWithRootObject:face];
}

@end
