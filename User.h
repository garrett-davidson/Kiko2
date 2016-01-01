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

@interface User : NSObject<NSCoding>

@property (nonatomic) Face *userFace;
@property (nonatomic) NSString *name;

- (id) initWithName:(NSString*)name andFace: (Face *)face;
+ (id)getCurrentUser;

- (CAShapeLayer *) getImage;

- (id) initWithCoder:(NSCoder *)aDecoder;
- (void) encodeWithCoder:(NSCoder *)aCoder;

@end
