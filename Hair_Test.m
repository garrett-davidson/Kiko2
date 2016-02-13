//
//  Hair_Test.m
//  Kiko
//
//  Created by Garrett Davidson on 2/12/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "Hair_Test.h"

@implementation Hair_Test

@dynamic name, csv;

+ (NSString*) parseClassName {
    return @"Hair_Test";
}

+ (void) load {
    [self registerSubclass];
}

@end
