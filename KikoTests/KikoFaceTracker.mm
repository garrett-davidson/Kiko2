//
//  NewKikoFaceTracker.m
//  Kiko
//
//  Created by Garrett Davidson on 2/8/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "KikoFaceTracker.h"
#import "BRFTracker.h"
#import "KikoAnimator.h"

#define kDefaultAVCaptureSessionPreset AVCaptureSessionPreset640x480
#define kDefaultAVCaptureVideoOrientation AVCaptureVideoOrientationPortrait
#define kMirrored true
#define kCameraWidth 480
#define kCameraHeight 640

@interface KikoFaceTracker() {
    AVCaptureVideoDataOutput *videoOutput;
    KikoAnimator *animator;
    int discardFrames;
    AVCaptureSession *session;
    dispatch_queue_t videoQueue;
    dispatch_queue_t pointParsingQueue;
    bool isAnimating;
}

@end

@implementation KikoFaceTracker



BRFTracker *newTracker = [[BRFTracker alloc] initWithWidth:kCameraWidth height:kCameraHeight];
const std::function< void() > brf::BRFManager::READY = []{ [newTracker onReadyBRF]; };
double DrawingUtils::CANVAS_WIDTH = (double)kCameraWidth;
double DrawingUtils::CANVAS_HEIGHT = (double)kCameraHeight;


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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [newTracker initialize:true];
        [self initializeCamera];
    });

    discardFrames = 0;
    animator = [KikoAnimator sharedAnimator];
    isAnimating = true;

    return self;
}

- (void) setTrackingImageView:(UIImageView *)trackingImageView {
    _trackingImageView = trackingImageView;
    _trackingImageView.layer.masksToBounds = true;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{

    // Create autorelease pool because we are not in the main_queue
    @autoreleasepool {

        discardFrames++;
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        //CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

        CVPixelBufferLockBaseAddress(imageBuffer, 0);

        // Get the pixel buffer width and height
        int width = (int)CVPixelBufferGetWidth(imageBuffer);
        int height = (int)CVPixelBufferGetHeight(imageBuffer);

        if(width != kCameraWidth || height != kCameraHeight) {

            brf::trace("Error: wrong video input size: width: " + brf::to_string(width) +
                       " height: " + brf::to_string(height));
            brf::trace("... changing videoOrientation ...");

            [connection setVideoOrientation: 	kDefaultAVCaptureVideoOrientation];
            [connection setVideoMirrored: 		kMirrored];

            //We unlock the  image buffer
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

        } else {

            // Get the number of bytes per row for the pixel buffer
            uint8_t* baseAddress = (uint8_t*) CVPixelBufferGetBaseAddress(imageBuffer);

            // Create a device-dependent RGB color space
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

            // Create a bitmap graphics context with the sample buffer data
            CGContextRef context = CGBitmapContextCreate(
                                                         baseAddress, width, height, 8, CVPixelBufferGetBytesPerRow(imageBuffer),
                                                         colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);

            CGImageRef originalImageRef = CGBitmapContextCreateImage(context);
            CGImageRelease(originalImageRef);
            if (discardFrames > 10) {
                [newTracker update:baseAddress];


                std::vector< std::shared_ptr<brf::Point>> pointsVector = [newTracker updateGUI:context];
                [newTracker updateGUI:context];



                CGImageRef quartzImage = CGBitmapContextCreateImage(context);
                CVPixelBufferUnlockBaseAddress(imageBuffer, 0);




                UIImage *modifiedImage = [UIImage imageWithCGImage:quartzImage];
                CGImageRelease(quartzImage);


                if (!pointsVector.empty()) {
                    if (!pointParsingQueue) {
                        pointParsingQueue =dispatch_queue_create("Point Parsing Queue", NULL);
                    }
                    dispatch_async(pointParsingQueue, ^{
                        [animator updateAnimationWithFacePoints:pointsVector];
                    });
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isAnimating) {
                        [_trackingImageView setImage:modifiedImage];
                    }
                });
            }

            CGColorSpaceRelease(colorSpace);
            CGContextRelease(context);
        }
    }
    
}

- (void) initializeCamera {

    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = kDefaultAVCaptureSessionPreset;


    _trackingImageView.layer.masksToBounds = true;


    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;

    for (AVCaptureDevice *device in devices) {

        NSLog(@"Device name: %@", [device localizedName]);

        if ([device hasMediaType:AVMediaTypeVideo]) {

            if ([device position] == AVCaptureDevicePositionFront) {
                frontCamera = device;
                break;
            }
        }
    }

    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];

    // Create a VideoDataOutput and add it to the session
    videoOutput = [[AVCaptureVideoDataOutput alloc] init];

    NSDictionary *rgbOutputSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];

    [videoOutput setVideoSettings:rgbOutputSettings];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)

    // Configure your output.
    videoQueue = dispatch_queue_create("Video capture queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    //dispatch_release(videoQueue);

    [session addOutput:videoOutput];

    // Start the session running to start the flow of data
    [session startRunning];
}

- (void) pause {
    isAnimating = false;
    [session stopRunning];
}

- (void) unpause {
    isAnimating = true;
    [session startRunning];
}

@end
