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

@dynamic name, faceData, friends, totalKikoMinutes, sentFriendRequests, receivedFriendRequests;

+ (id) getCurrentUser {
    PFUser *currentUser = [PFUser currentUser];
    
    if ([currentUser isMemberOfClass:User.self]) {
        return currentUser;
    }
    
    return nil;
}

+ (void)load {
    [self registerSubclass];
}

- (CAShapeLayer *) getImageScaledForRect:(CGRect)bounds {
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:[self getFace].path.CGPath];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    
    CGRect imageBounds = CGPathGetBoundingBox(layer.path);

    float widthScale = bounds.size.width/imageBounds.size.width;
    float heightScale = bounds.size.height/imageBounds.size.height;
    layer.transform = CATransform3DMakeScale(widthScale, heightScale, 1);
    layer.position = CGPointMake(-imageBounds.origin.x * widthScale + bounds.origin.x, -imageBounds.origin.y * heightScale + bounds.origin.y);
    
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
