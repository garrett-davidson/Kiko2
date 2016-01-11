//
//  KikoHair.m
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoHair.h"

@implementation KikoHair

@dynamic name, pathData;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"KikoHair";
}

- (id) initWithName:(NSString *)_name path:(UIBezierPath *)_path {
    self = [KikoHair object];
    self.name = _name;
    self.path = _path;
    
    return self;
}

- (void) setPath:(UIBezierPath *)path {
    self.pathData = [NSKeyedArchiver archivedDataWithRootObject:path];
}

- (UIBezierPath*)path {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self fetchIfNeeded].pathData];
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"Hair named %@ with path %@", self.name, self.path];
//}

@end
