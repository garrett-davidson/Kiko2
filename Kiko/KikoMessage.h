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

@interface KikoMessage : PFObject<PFSubclassing>

@property (nonatomic) User* sender;
@property (nonatomic) Face* face;

@property (nonatomic) NSArray *faceFrames;
@property (nonatomic) NSUInteger messageLength;
@property (nonatomic) FaceView *view;
@property (nonatomic) NSArray *xValues;
@property (nonatomic) NSArray *yValues;

@property (nonatomic) BOOL isPlaying;

- (id) initWithSender:(User*)sender andFrames: (NSArray*)frames;

- (void) play;
- (void) pause;
- (void) stop;

@end
