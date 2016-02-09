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
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIView *realtimeAnimationView;

@end
