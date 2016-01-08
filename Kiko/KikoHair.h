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
@property (nonatomic) UIBezierPath *path;
@property (nonatomic) NSData *pathData;

- (id) initWithName:(NSString *)_name path:(UIBezierPath *)_path;

@end
