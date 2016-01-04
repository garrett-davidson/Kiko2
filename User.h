//
//  User.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Face.h"
#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *friends;

+ (id)getCurrentUser;

- (CAShapeLayer *) getImage;

- (Face*) getFace;
- (void) setFace:(Face *) face;
@end
