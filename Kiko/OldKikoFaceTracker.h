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
#import "OldKikoAnimator.h"

@interface OldKikoFaceTracker : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) double cameraHeight;
@property (nonatomic) double cameraWidth;

@property (nonatomic) OldKikoAnimator *animator;

@property(nonatomic) AVCaptureVideoDataOutput *videoOutput;

@property (weak, nonatomic) UIImageView *trackingImageView;

- (void) pause;
- (void) unpause;

+ (id) sharedTracker;

@end
