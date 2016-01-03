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

@dynamic name, userFace;

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

- (id) initWithName:(NSString*)name email:(NSString *)email username:(NSString *)username {
    self = [User user];
    self.name = name;
    self.email = email;
    self.username = username;
    
    return self;
}

//- (void) encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.userFace forKey:@"face"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//}
//
//- (id) initWithCoder:(NSCoder *)aDecoder {
//    self.userFace = [aDecoder decodeObjectForKey:@"face"];
//    self.name = [aDecoder decodeObjectForKey:@"name"];
//    return self;
//}

- (CAShapeLayer *) getImage {
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:self.userFace.path.CGPath];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    return layer;
}

//+ (NSString *)parseClassName {
//    return @"User";
//}

@end
