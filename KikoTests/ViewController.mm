#import "ViewController.h"

// Import of the 3 example classes. Choose one example below.

//#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExampleFaceTrackingIOS.hpp"

#import <Parse/Parse.h>
#import "BRFTracker.h"

#define kRealtimeCameraViewWidth2 self.view.bounds.size.width/2.5
#define kRealtimeCameraViewHeight2 self.view.bounds.size.height/2.5




@interface ViewController () {
    dispatch_queue_t secondQueue;
}

@end

@implementation ViewController

@synthesize imagePreview, captureImage, videoOutput, isRecording, recordingLayerArray, timeStampRecordArray, diffTimeArray, isAnimating, displayLink, loopingCounter, recordingCount, timeStampRecordArray2, diffTimeArray2, playBackSize, displayAnimationPlaybackTest, faceBeingRecorded, listOfMessages, animatingCellIndexPath, errorTimeStampArray, faceBeingPlayed, hasUpdated, heightNavBar, counterAvoidCrash, csvArray;


int _cameraWidth  = 480;
int _cameraHeight = 640;
NSString* _defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;

AVCaptureSession *session2;
AVCaptureVideoOrientation _defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
dispatch_queue_t videoQueue2;
UIView *realTimeAnimationView;


BRFTracker *_example = [[BRFTracker alloc] initWithWidth:_cameraWidth height:_cameraHeight];


const std::function< void() > brf::BRFManager::READY = []{ [_example onReadyBRF]; };
double DrawingUtils::CANVAS_WIDTH = (double)_cameraWidth;
double DrawingUtils::CANVAS_HEIGHT = (double)_cameraHeight;



bool _mirrored = true;


bool _useFrontCam = true;

#pragma mark - ViewLoadMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Hair_Test"];
    [query whereKey:@"objectId" equalTo:@"vvBNXlXKj2"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"hair_1"];
            NSURL *url = [NSURL URLWithString:file.url];
            [self populateCSV:self.csvFinal :url];
        }
        else {
            NSLog(@"Parse error: %@", error);
        }
    }];
}

-(void) populateCSV: (NSMutableArray *)csvArr :(NSURL *) url {
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    NSString *newString = [string stringByReplacingOccurrencesOfString:@",,," withString:@""];
    
    NSString *stringWithoutSpaces = [newString stringByReplacingOccurrencesOfString:@",," withString:@""];
    
    NSArray* lines = [stringWithoutSpaces componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    self.csvFinal = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [lines count]; i++) {
        NSString *string = [lines objectAtIndex:i];
        NSArray *array = [string componentsSeparatedByString:@","];
        for (int j = 0; j < [array count]; j++) {
            [self.csvFinal addObject:[array objectAtIndex:j]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    counterAvoidCrash = 0;
    [self initializeCamera];
    [_example initialize:true];
}


-(void) viewDidLayoutSubviews {
    // Resize capture image view
    
    CGFloat width = kRealtimeCameraViewWidth2/480.0;
    CGFloat height = kRealtimeCameraViewHeight2/640.0;
    CGFloat x;
    CGFloat y;

    CGFloat heightofImage;
    CGFloat widthofImage;
    CGFloat widthOfBorderLine = 3.0;
    
    if (height > width) {
        x = 0;
        y = self.view.bounds.size.height - (kRealtimeCameraViewHeight2 - ((kRealtimeCameraViewHeight2 - 640.0*width)/2.0));
        heightofImage = width * 640.0;
        widthofImage = width * 480.0;
    } else {
        x =  -((kRealtimeCameraViewWidth2 - 480.0*height)/2.0);
        y = self.view.bounds.size.height - kRealtimeCameraViewHeight2;
        heightofImage = height * 640.0;
        widthofImage = height * 480.0;

    }
    
    CGFloat widthOfAnimationArea = self.view.bounds.size.width - widthofImage;

    captureImage.frame = CGRectMake(x, y, kRealtimeCameraViewWidth2, kRealtimeCameraViewHeight2);
    captureImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // Add Realtime Animation View
    
    realTimeAnimationView = [[UIView alloc] initWithFrame:CGRectMake(widthofImage + widthOfBorderLine, self.view.bounds.size.height - heightofImage + widthOfBorderLine, widthOfAnimationArea - widthOfBorderLine, heightofImage - (2*widthOfBorderLine))];
    
    [self.view addSubview:realTimeAnimationView];
    
    
    //Add Display Animation Playback
    
    playBackSize = CGSizeMake(widthOfAnimationArea - widthOfBorderLine, heightofImage - (2*widthOfBorderLine));
    
    self.displayAnimationPlayback = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - heightofImage - ( heightofImage - (3*widthOfBorderLine)), widthOfAnimationArea - widthOfBorderLine, heightofImage - (2*widthOfBorderLine))];

    UIColor *displayColor = [UIColor colorWithRed:0.902 green:0.176 blue:0.478 alpha:1] ;
    
    
    UIView *displayBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - heightofImage - ( heightofImage - (3*widthOfBorderLine)), self.view.bounds.size.width, heightofImage - (2*widthOfBorderLine))];
    
    displayBackgroundView.layer.borderColor = [UIColor colorWithRed:0.475 green:0.2 blue:0.894 alpha:1].CGColor;
    displayBackgroundView.layer.borderWidth = 3.0;
    displayBackgroundView.backgroundColor = displayColor;
    
    //Draw Lines for bottom drawer and add views to bottom drawer view
    
    self.bottomDrawerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - heightofImage)];
    self.bottomDrawerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:realTimeAnimationView];
    
    
    [self.view insertSubview:self.bottomDrawerView belowSubview:captureImage];
    
    //Variables
    
    isRecording = NO;
    isAnimating = NO;
    hasUpdated = NO;
    recordingLayerArray = [[NSMutableArray alloc] init];
    timeStampRecordArray = [[NSMutableArray alloc] init];
    diffTimeArray = [[NSMutableArray alloc] init];
    timeStampRecordArray2 = [[NSMutableArray alloc] init];
    faceBeingRecorded = [[FacesArray alloc] init];
    faceBeingPlayed = [[FacesArray alloc] init];
    listOfMessages = [[NSMutableArray alloc]init];
    errorTimeStampArray = [[NSMutableArray alloc]init];
}

#pragma mark - RealTimeImageProcessingMethods

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
         didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
         fromConnection:(AVCaptureConnection *)connection
{

// Create autorelease pool because we are not in the main_queue
    @autoreleasepool {

        counterAvoidCrash++;
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        //CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        // Get the pixel buffer width and height
        int width = (int)CVPixelBufferGetWidth(imageBuffer);
        int height = (int)CVPixelBufferGetHeight(imageBuffer);
        
        if(width != _cameraWidth || height != _cameraHeight) {
            
            brf::trace("Error: wrong video input size: width: " + brf::to_string(width) +
                    " height: " + brf::to_string(height));
            brf::trace("... changing videoOrientation ...");
            
            [connection setVideoOrientation: 	_defaultAVCaptureVideoOrientation];
            [connection setVideoMirrored: 		_mirrored];
            
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
            UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef];
            CGImageRelease(originalImageRef);
            if (counterAvoidCrash > 10) {
                [_example update:baseAddress];


                std::vector< std::shared_ptr<brf::Point>> pointsVector = [_example updateGUI:context];
                [_example updateGUI:context];
                
                
            
                CGImageRef quartzImage = CGBitmapContextCreateImage(context);
                CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
                
                CGContextRelease(context);
                CGColorSpaceRelease(colorSpace);
                
                
             
                UIImage *modifiedImage = [UIImage imageWithCGImage:quartzImage];
                CGImageRelease(quartzImage);
                
                
                if (!pointsVector.empty()) {
                    if (!secondQueue) {
                        secondQueue =dispatch_queue_create("secondQueue", NULL);
                    }
                    dispatch_async(secondQueue, ^{
                        [self passingXYCoordinates:pointsVector: originalImage: modifiedImage];
                        
                    });
                    
                
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!isAnimating) {
                        [captureImage setImage:modifiedImage];
                    }
                   
                });
            }
        }
    }

}

- (void) initializeCamera {
    
    session2 = [[AVCaptureSession alloc] init];
    session2.sessionPreset = _defaultAVCaptureSessionPreset;
    
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!_useFrontCam) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session2 addInput:input];
    }
    
    if (_useFrontCam) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session2 addInput:input];
    }
    
    // Create a VideoDataOutput and add it to the session
    videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    NSDictionary *rgbOutputSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [videoOutput setVideoSettings:rgbOutputSettings];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    // Configure your output.
    videoQueue2 = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue2];
    //dispatch_release(videoQueue2);
    
    [session2 addOutput:videoOutput];
    
    // Start the session running to start the flow of data
    [session2 startRunning];
}

#pragma mark - RealTimeAnimationProcessingMethods

-(void)passingXYCoordinates:(std::vector< std::shared_ptr<brf::Point>>) pointsVector : (UIImage *) originalImage : (UIImage *) modifiedImage{
        self.realTimeFace = [[Face2 alloc] initWithData:(pointsVector) :self.csvFinal];
        NSMutableArray *faceDataPoints = [self.realTimeFace getDataPointArray];
        UIBezierPath *path = [self.realTimeFace createSingleBezierPath];
        //UIBezierPath *hairPath = [self.]
        UIBezierPath *hairPath = [self.realTimeFace getHairPath];
        NSMutableArray *hairPaths = [self.realTimeFace getBezierPathArray];
    
        CAShapeLayer *faceLayer = [[CAShapeLayer alloc] init];
        faceLayer.frame = CGRectMake(0, 0, 480.0, 640.0);
        [faceLayer setFillColor:[[UIColor clearColor] CGColor]];
        [faceLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [faceLayer setPath: path.CGPath];
    
        FaceLayer *realtimeFaceLayer = [[FaceLayer alloc] init];
        realtimeFaceLayer.name = @"Layer";
        [realtimeFaceLayer addSublayer:faceLayer];
    
        for (int i = 0; i < [hairPaths count]; i++) {
            UIBezierPath *hairBezier = [hairPaths objectAtIndex:i];
            CAShapeLayer *hair = [[CAShapeLayer alloc] init];
            hair.frame = CGRectMake(0, 0, 480.0, 640.0);
            NSString *string = [self.realTimeFace getColorAtIndex:i];
            if ([string isEqualToString:@"DARK"]) {
                [hair setFillColor:[UIColor yellowColor].CGColor];
                
            } else {
                [hair setFillColor:[UIColor yellowColor].CGColor];
            }
            [hair setStrokeColor:[[UIColor blackColor] CGColor]];
            [hair setPath: hairBezier.CGPath];
            [realtimeFaceLayer addSublayer:hair];
            
        }
    
        CAShapeLayer *hairLayer = [[CAShapeLayer alloc] init];
        hairLayer.frame = CGRectMake(0, 0, 480.0, 640.0);
        [hairLayer setFillColor:[[UIColor yellowColor] CGColor]];
        [hairLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [hairLayer setPath: hairPath.CGPath];
        
       dispatch_async(dispatch_get_main_queue(), ^{
            for (CAShapeLayer *layer in realTimeAnimationView.layer.sublayers) {
                if (!isAnimating) {
                    [layer removeFromSuperlayer];
                }
            }
           
           if(isRecording) {
               [faceBeingRecorded addLayer:realtimeFaceLayer :[NSDate date] :faceDataPoints];
               [recordingLayerArray addObject:realtimeFaceLayer];
               [timeStampRecordArray addObject:[NSDate date]];
           }

           realtimeFaceLayer.frame = realTimeAnimationView.bounds;
           
           if (!isAnimating) {
               [[realTimeAnimationView layer] addSublayer:realtimeFaceLayer];
           }
        
           [self.realTimeFace initializeArrays];
        });
}
@end