#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h> 
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <CoreVideo/CVPixelBuffer.h>
#import "Face2.h"
#import "FacesArray.h"
#import "NSMutableArray+MessageList.h"

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
}

@property(nonatomic, retain) AVCaptureVideoDataOutput *videoOutput;
@property (weak, nonatomic) IBOutlet UIView *imagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;

//Face variables
@property (strong, nonatomic) NSMutableArray *interpolationPoints;
@property (strong, nonatomic) Face2 *realTimeFace;
@property (strong, nonatomic) NSMutableArray *recordingLayerArray;
@property (strong, nonatomic) NSMutableArray *timeStampRecordArray;
@property (strong, nonatomic) NSMutableArray *diffTimeArray;
@property (strong, nonatomic) NSMutableArray *timeStampRecordArray2;
@property (strong, nonatomic) NSMutableArray *diffTimeArray2;

@property (strong, nonatomic) NSArray *csvArray;
@property (strong, nonatomic) NSMutableArray *csvFinal;




@property (retain, nonatomic) FacesArray *faceBeingRecorded;
@property (retain, nonatomic) FacesArray *faceBeingPlayed;

@property (strong, nonatomic) NSMutableArray *listOfMessages;
@property (nonatomic) NSUInteger animatingCellIndexPath;
@property (strong, nonatomic) NSMutableArray *errorTimeStampArray;
//@property (strong, nonatomic)


// User interface variables
@property (strong,nonatomic) UIView *bottomDrawerView;
@property (strong,nonatomic) UIView *progress;
@property (strong, nonatomic) UIProgressView *prog;
@property (strong, nonatomic) UIView *displayAnimationPlayback;
@property (strong, nonatomic) UIView *displayAnimationPlaybackTest;
@property (strong, nonatomic) UIView *hoverOverCaptureImageView;
@property (nonatomic) CGFloat  heightNavBar;
@property (nonatomic) int counterAvoidCrash;


@property (nonatomic) CGSize playBackSize;

//Interaction variables
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) BOOL hasUpdated;

@property (nonatomic) int loopingCounter;
@property (nonatomic) int recordingCount;

//Timer Variables
@property (strong, nonatomic) CADisplayLink * displayLink;

-(void)passingXYCoordinates:(std::vector< std::shared_ptr<brf::Point>>) pointsVector : (UIImage *) originalImage2 : (UIImage *) modifiedImage2;






@end
