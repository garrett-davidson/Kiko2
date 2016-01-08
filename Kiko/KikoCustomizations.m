//
//  KikoCustomization.m
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoCustomizations.h"

@implementation KikoCustomizations

@dynamic eyes, hair;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"KikoCustomizations";
}

@end
