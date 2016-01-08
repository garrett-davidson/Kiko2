//
//  PlaygroundViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/10/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "PlaygroundViewController.h"
#import "KikoAnimator.h"
#import "KikoFaceTracker.h"
#import "FaceCustomizationViewController.h"

@interface PlaygroundViewController () {
    KikoAnimator *animator;
    KikoFaceTracker *tracker;
}

@end

@implementation PlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tracker = [KikoFaceTracker sharedTracker];
    [tracker setTrackingImageView:self.trackingView];
    animator = [KikoAnimator sharedAnimator];
    animator.animationView = self.animationView;
    
    [self drawCustomizeButton];
}

- (void) viewDidDisappear:(BOOL)animated {
    [animator pause];
    [tracker pause];
}

- (void) viewWillAppear:(BOOL)animated {
    User *currentUser = [User currentUser];
    animator.currentEyes = [[currentUser.face fetchIfNeeded].eyes fetchIfNeeded];
    animator.currentHair = [currentUser.face.hair fetchIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated {
    [tracker unpause];
    [animator unpause];
}

- (void) drawCustomizeButton {
    UIBezierPath *buttonPath = [UIBezierPath new];
    [buttonPath moveToPoint:CGPointMake(0, 0)];
    float width = self.customizeButton.frame.size.width;
    [buttonPath addArcWithCenter:CGPointMake(width, 0) radius:width startAngle:M_PI endAngle:M_PI/2 clockwise:false];
    [buttonPath addLineToPoint:CGPointMake(width, 0)];
    [buttonPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.frame = CGRectMake(0, 0, width, self.customizeButton.frame.size.height);
    [layer setFillColor:[[UIColor purpleColor] CGColor]];
    [layer setStrokeColor:[[UIColor blackColor] CGColor]];
    [layer setLineWidth:2];
    [layer setPath:buttonPath.CGPath];
    
    [self.customizeButton.layer addSublayer:layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)customize:(id)sender {
    [self performSegueWithIdentifier:@"CustomizeSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FaceCustomizationViewController *dest = (FaceCustomizationViewController*) ((UINavigationController*)segue.destinationViewController).topViewController;
    dest.user = [User currentUser];
}

@end
