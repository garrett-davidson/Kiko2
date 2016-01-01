//
//  KikoChat.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoChat.h"

@implementation KikoChat

- (id) initWithName:(NSString *)name andFriends:(NSArray *)friends {
    self = [super init];
    self.name = name;
    self.users = friends;
    
    return self;
}

@end
