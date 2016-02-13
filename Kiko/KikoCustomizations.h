//
//  KikoCustomization.h
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "KikoEyes.h"
#import "Hair_Test.h"

@interface KikoCustomizations : PFObject<PFSubclassing>

@property (nonatomic) NSArray *eyes;
@property (nonatomic) NSArray *hair;
@property (nonatomic) NSArray *hair_test;

+ (KikoCustomizations *) sharedCustomizations;

@end
