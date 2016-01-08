//
//  KikoEyes.h
//  Kiko
//
//  Created by Garrett Davidson on 1/6/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <Parse/Parse.h>

@interface KikoEyes : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) PFFile *leftEyeFile;
@property (nonatomic) PFFile *rightEyeFile;

- (UIImage *) getLeftEyeImage;
- (UIImage *) getRightEyeImage;

- (id) initWithName:(NSString *)name leftEyeFileName:(NSString *)leftEyeFileName rightEyeFileName:(NSString*)rightEyeFileName;

@end
