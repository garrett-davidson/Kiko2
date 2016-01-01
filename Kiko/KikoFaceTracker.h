//
//  KikoFaceTracker.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KikoAnimator.h"

@interface KikoFaceTracker : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) double cameraHeight;
@property (nonatomic) double cameraWidth;

@property (nonatomic) KikoAnimator *animator;

@property(nonatomic) AVCaptureVideoDataOutput *videoOutput;

@property (weak, nonatomic) UIImageView *trackingImageView;

- (void) pause;
- (void) unpause;

+ (id) sharedTracker;

@end
