//
//  KikoChat.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoChat.h"

@implementation KikoChat

@dynamic name, users, messages;

- (id) initWithName:(NSString *)name andFriends:(NSArray *)friends {
    self = [super init];
    self.name = name;
    self.users = friends;
    
    return self;
}

+ (void) load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"KikoChat";
}

@end
