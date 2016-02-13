//
//  KikoCustomization.m
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoCustomizations.h"

@implementation KikoCustomizations

@dynamic eyes, hair, hair_test;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"KikoCustomizations";
}

+ (KikoCustomizations *) sharedCustomizations {
    static KikoCustomizations *sharedCustomizations;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PFQuery *customizationsQuery = [PFQuery queryWithClassName:@"KikoCustomizations"];
        [customizationsQuery fromLocalDatastore];
//        [customizationsQuery includeKey:@"hair"];
        [customizationsQuery includeKey:@"eyes"];
        [customizationsQuery includeKey:@"hair_test"];
        sharedCustomizations = [customizationsQuery getObjectWithId:@"zaV9sxvDHn"];
     });

    return sharedCustomizations;
}

@end
