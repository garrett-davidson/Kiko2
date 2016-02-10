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
#import "FaceView.h"
#import "FacesArray.h"

@interface KikoMessage : PFObject<PFSubclassing>

@property (nonatomic) User* sender;
@property (nonatomic) Face* face;

@property (nonatomic) FacesArray *faceFrames;
@property (nonatomic) NSUInteger messageLength;
@property (nonatomic) FaceView *view;
@property (nonatomic) NSArray *xValues;
@property (nonatomic) NSArray *yValues;

@property (nonatomic) BOOL isPlaying;

- (id) initWithSender:(User*)sender andFrames: (FacesArray*)frames;

- (void) playInView:(UIView *)view;
- (void) pause;
- (void) stop;

@end
