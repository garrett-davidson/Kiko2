//
//  Face.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Face : NSObject<NSCoding>

@property (nonatomic) UIBezierPath *path;

- (id) initWithPath:(UIBezierPath *)path;

@end
