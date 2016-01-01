//
//  KikoFaceTracker.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "KikoFaceTracker.h"
#include <cstdlib>
#import "BRFTracker.h"

//#include "com/tastenkunst/cpp/brf/nxt/utils/StringUtils.hpp"

#define kDefaultAVCaptureSessionPreset AVCaptureSessionPreset640x480
#define kDefaultAVCaptureVideoOrientation AVCaptureVideoOrientationPortrait
#define kMirrored true
#define _cameraWidth 480
#define _cameraHeight 640

@interface KikoFaceTracker () {
    AVCaptureVideoPreviewLayer *captureLayer;
}

@end

@implementation KikoFaceTracker

AVCaptureSession *session;
dispatch_queue_t videoQueue;

BRFTracker *tracker = [[BRFTracker alloc] initWithWidth:_cameraWidth height:_cameraHeight];
const std::function< void() > brf::BRFManager::READY = []{ [tracker onReadyBRF]; };
double DrawingUtils::CANVAS_WIDTH = (double)_cameraWidth;
double DrawingUtils::CANVAS_HEIGHT = (double)_cameraHeight;

+ (id) sharedTracker {
    static KikoFaceTracker *sharedTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTracker = [[KikoFaceTracker alloc] init];
    });
    
    return sharedTracker;
}

- (id) init {
    self = [super init];
    
    self.cameraHeight = _cameraHeight;
    self.cameraWidth = _cameraWidth;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [tracker initialize:true];
        [self initializeCamera];
    });
    
    return self;
}

- (void) setTrackingImageView:(UIImageView *)trackingImageView {
    _trackingImageView = trackingImageView;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    int width = (int)CVPixelBufferGetWidth(imageBuffer);
    int height = (int)CVPixelBufferGetHeight(imageBuffer);
    
    if(width != _cameraWidth || height != _cameraHeight) {
        
        brf::trace("Error: wrong video input size: width: " + brf::to_string(width) +
                   " height: " + brf::to_string(height));
        brf::trace("... changing videoOrientation ...");
        
        [connection setVideoOrientation: kDefaultAVCaptureVideoOrientation];
        [connection setVideoMirrored: kMirrored];
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
    }
    
    else {
        uint8_t* baseAddress = (uint8_t*) CVPixelBufferGetBaseAddress(imageBuffer);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, CVPixelBufferGetBytesPerRow(imageBuffer), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        
        [tracker update:baseAddress];
        std::vector<std::shared_ptr<brf::Point>> points = [tracker updateGUI:context];
        
        if (!points.empty())
            [self.animator updateAnimationWithFacePoints:points];
        
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        
        CGImageRelease(quartzImage);
        
        [self.trackingImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }
}

- (void) initializeCamera {
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = kDefaultAVCaptureSessionPreset;
    
    captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    //    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //    UIView *view = [self imagePreview];
    //    CALayer *viewLayer = [view layer];
    //    [viewLayer setMasksToBounds:YES];
    //
    //    CGRect bounds = [view bounds];
    CGRect bounds = self.trackingImageView.bounds;
    bounds.size.width /= 2;
    [captureLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionFront) {
                frontCamera = device;
                break;
            }
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if (error) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    NSDictionary *rgbOutputSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [_videoOutput setVideoSettings:rgbOutputSettings];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    //    // Configure your output.
    videoQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    [_videoOutput setSampleBufferDelegate:self queue:videoQueue];
    //    //dispatch_release(videoQueue);
    
    [session addOutput:_videoOutput];
    
    //    // Start the session running to start the flow of data
    [session startRunning];
}

- (void) pause {
    [session stopRunning];
}

- (void) unpause {
    [session startRunning];
}
@end
