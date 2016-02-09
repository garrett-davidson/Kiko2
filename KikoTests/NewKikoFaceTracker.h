//
//  NewKikoFaceTracker.h
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


//TODO: Remove me
#import "ViewController.h"


@interface NewKikoFaceTracker : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

+ (id) sharedTracker;
- (void) pause;
- (void) unpause;

@property (nonatomic) UIImageView *trackingImageView;

//TODO: Remove me
@property (nonatomic) ViewController *temp;

@end
