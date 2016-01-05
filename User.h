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
@property (nonatomic) NSNumber *totalKikoMinutes;

@property (nonatomic) NSArray *friends;
@property (nonatomic) NSArray *sentFriendRequests;
@property (nonatomic) NSArray *receivedFriendRequests;

+ (id)getCurrentUser;

- (CAShapeLayer *) getImageScaledForRect:(CGRect)bounds;

- (Face*) getFace;
- (void) setFace:(Face *) face;
@end
