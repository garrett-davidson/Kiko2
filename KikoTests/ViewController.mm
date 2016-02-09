#import "ViewController.h"

#import <Parse/Parse.h>
#import "BRFTracker.h"

#define kRealtimeCameraViewWidth2 self.view.bounds.size.width/2.5
#define kRealtimeCameraViewHeight2 self.view.bounds.size.height/2.5

#import "NewKikoFaceTracker.h"


@interface ViewController () {
    NewKikoFaceTracker *newKikoFaceTracker;
}

@end

@implementation ViewController

@synthesize captureImage, isRecording, recordingLayerArray, timeStampRecordArray, diffTimeArray, isAnimating, displayLink, loopingCounter, recordingCount, timeStampRecordArray2, diffTimeArray2, playBackSize, displayAnimationPlaybackTest, faceBeingRecorded, errorTimeStampArray, csvArray;


int _cameraWidth  = 480;
int _cameraHeight = 640;
NSString* _defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;

AVCaptureSession *session2;
AVCaptureVideoOrientation _defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
dispatch_queue_t videoQueue2;
UIView *realTimeAnimationView;

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

    newKikoFaceTracker = [[NewKikoFaceTracker alloc] init];
    newKikoFaceTracker.trackingImageView = captureImage;

    //TODO: Remove me
    newKikoFaceTracker.temp = self;
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
    recordingLayerArray = [[NSMutableArray alloc] init];
    timeStampRecordArray = [[NSMutableArray alloc] init];
    diffTimeArray = [[NSMutableArray alloc] init];
    timeStampRecordArray2 = [[NSMutableArray alloc] init];
    faceBeingRecorded = [[FacesArray alloc] init];
    errorTimeStampArray = [[NSMutableArray alloc]init];
}

#pragma mark - RealTimeAnimationProcessingMethods

-(void)passingXYCoordinates:(std::vector< std::shared_ptr<brf::Point>>) pointsVector : (UIImage *) originalImage2 : (UIImage *) modifiedImage2{
        self.realTimeFace = [[Face2 alloc] initWithData:pointsVector :self.csvFinal];
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