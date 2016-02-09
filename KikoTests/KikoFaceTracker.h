//
//  NewKikoFaceTracker.h
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface KikoFaceTracker : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

+ (id) sharedTracker;
- (void) pause;
- (void) unpause;

@property (nonatomic) UIImageView *trackingImageView;

@end
