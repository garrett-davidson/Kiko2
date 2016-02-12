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

@dynamic name, friends, totalKikoMinutes, sentFriendRequests, receivedFriendRequests, face, allFaces, face2;

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

@end
