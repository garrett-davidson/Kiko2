//
//  Face.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "Face.h"

@implementation Face


- (id) initWithPath:(UIBezierPath *)path {
    self.path = path;
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.path forKey:@"path"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self.path = [aDecoder decodeObjectForKey:@"path"];
    
    return self;
}

@end
