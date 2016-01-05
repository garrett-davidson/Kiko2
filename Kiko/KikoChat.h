//
//  KikoChat.h
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KikoMessage.h"
#import "User.h"


@interface KikoChat : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *users;
@property (nonatomic) NSArray *messages;

- (id) initWithName: (NSString *)name andFriends: (NSArray *)friends;

+ (NSString *)parseClassName;

@end
