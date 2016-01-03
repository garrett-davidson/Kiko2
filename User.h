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

@property (nonatomic) Face *userFace;
@property (nonatomic) NSString *name;

- (id) initWithName:(NSString*)name email:(NSString *)email username:(NSString *)username;
+ (id)getCurrentUser;

- (CAShapeLayer *) getImage;

//- (id) initWithCoder:(NSCoder *)aDecoder;
//- (void) encodeWithCoder:(NSCoder *)aCoder;

//+ (NSString *)parseClassName;

@end
