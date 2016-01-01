//
//  User.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "User.h"

@implementation User

+ (id) getCurrentUser {
    static User *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = (User *) [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    });
    
    return currentUser;
}

- (id)initWithName:(NSString *)name andFace:(Face *)face {
    self.name = name;
    self.userFace = face;
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userFace forKey:@"face"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self.userFace = [aDecoder decodeObjectForKey:@"face"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    return self;
}

- (CAShapeLayer *) getImage {
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:self.userFace.path.CGPath];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    return layer;
}

@end
