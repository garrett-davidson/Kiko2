//
//  User.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

@dynamic name, friends, totalKikoMinutes, sentFriendRequests, receivedFriendRequests, face, allFaces;

+ (id) getCurrentUser {
    User *currentUser = [User currentUser];
    
    if ([currentUser isMemberOfClass:User.self]) {
        return currentUser;
    }
    
    return nil;
}

+ (id) currentUser {
    return [super currentUser];
}

+ (void)load {
    [self registerSubclass];
}

- (CAShapeLayer *) getImageScaledForRect:(CGRect)bounds {
    NSLog(@"TODO: Replace me with category");
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:self.face.facePath.CGPath];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    
    CGRect imageBounds = CGPathGetBoundingBox(layer.path);

    float widthScale = bounds.size.width/imageBounds.size.width;
    float heightScale = bounds.size.height/imageBounds.size.height;
    layer.transform = CATransform3DMakeScale(widthScale, heightScale, 1);
    layer.position = CGPointMake(-imageBounds.origin.x * widthScale + bounds.origin.x, -imageBounds.origin.y * heightScale + bounds.origin.y);
    
    return layer;
}

@end
