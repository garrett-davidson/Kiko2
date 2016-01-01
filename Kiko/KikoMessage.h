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

@interface KikoMessage : NSObject

@property (nonatomic) CAShapeLayer *previewFace;
@property (nonatomic) User* sender;

@end
