#import "ViewController.h"

#import <Parse/Parse.h>
#import "BRFTracker.h"

#define kRealtimeCameraViewWidth2 self.view.bounds.size.width/2.5
#define kRealtimeCameraViewHeight2 self.view.bounds.size.height/2.5

#import "NewKikoFaceTracker.h"
#import "NewKikoAnimator.h"


@implementation ViewController

#pragma mark - ViewLoadMethods

- (void) viewDidLoad {
    [super viewDidLoad];
    NewKikoFaceTracker *newKikoFaceTracker = [NewKikoFaceTracker sharedTracker];
    newKikoFaceTracker.trackingImageView = _captureImage;
    [NewKikoAnimator sharedAnimator].animationView = _realtimeAnimationView;
}
@end