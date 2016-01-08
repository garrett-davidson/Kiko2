//
//  KikoMessage.h
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface KikoMessage : PFObject<PFSubclassing>

@property (nonatomic) User* sender;

- (id) initWithSender:(User*)sender andFrames: (NSArray*)frames;

- (void) play;
- (void) pause;
- (void) stop;

- (CAShapeLayer *) getFaceLayer;

@end
