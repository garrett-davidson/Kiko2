//
//  KikoHair.h
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <Parse/Parse.h>

@interface KikoHair : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) PFFile *imageFile;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSNumber *mountingX;
@property (nonatomic) NSNumber *mountingY;

- (id) initWithName:(NSString *)name fileName:(NSString *)fileName;

@end
