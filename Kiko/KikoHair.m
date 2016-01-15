//
//  KikoHair.m
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoHair.h"

@implementation KikoHair

@dynamic name, imageFile, mountingX, mountingY;

@synthesize image = _image;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"KikoHair";
}

- (id) initWithName:(NSString *)name fileName:(NSString *)fileName {
    self = [KikoHair object];
    self.name = name;

    self.imageFile = [PFFile fileWithData:UIImagePNGRepresentation([UIImage imageNamed:fileName])];
    
    return self;
}

- (UIImage *)image {
    if (!_image) {
        _image = [UIImage imageWithData:[self fetchIfNeeded].imageFile.getData];
    }

    return _image;
}

@end
