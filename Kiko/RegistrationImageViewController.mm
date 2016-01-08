//
//  RegistrationImageViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "RegistrationImageViewController.h"
#import "KikoAnimator.h"
#import "KikoFaceTracker.h"
#import "FaceCustomizationViewController.h"

@interface RegistrationImageViewController () {
    KikoAnimator *animator;
    KikoFaceTracker *tracker;
}

@end

@implementation RegistrationImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.buttonsView.center = CGPointMake(-self.view.frame.size.width / 2, self.view.frame.size.height - self.buttonsView.frame.size.height/2);
    [self.view addSubview:self.buttonsView];
    
    tracker = [KikoFaceTracker sharedTracker];
    [tracker setTrackingImageView:self.trackingView];
    animator = [KikoAnimator sharedAnimator];
    animator.animationView = self.animationView;
    tracker.animator = animator;
    
    self.navigationItem.hidesBackButton = true;
}

- (void) viewDidAppear:(BOOL)animated {
    [tracker unpause];
    [animator unpause];
}

- (void) viewDidDisappear:(BOOL)animated {
    [tracker pause];
    [animator pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FaceCustomizationViewController *dest = segue.destinationViewController;
    
    dest.user = self.user;
    dest.isRegistering = true;
}


- (IBAction)retakePhoto:(id)sender {
    [animator unpause];
    [self hideButtons];
}

- (IBAction)savePhoto:(id)sender {
    Face *newFace = [animator getCurrentFace];
    [_user setFace:newFace];
    
    [_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved face");
            [self performSegueWithIdentifier:@"CustomizeFaceSegue" sender:self];
        }
    
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)takePhoto:(id)sender {
    [animator pause];
    [self showButtons];
}

- (void) showButtons {[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGPoint oldCenter = self.buttonsView.center;
    self.buttonsView.center = CGPointMake(oldCenter.x + self.view.frame.size.width, oldCenter.y);
    
    [UIView commitAnimations];
}

- (void) hideButtons {
    [UIView setAnimationDuration:0.5];
    CGPoint oldCenter = self.buttonsView.center;
    self.buttonsView.center = CGPointMake(oldCenter.x - self.view.frame.size.width, oldCenter.y);
    [UIView commitAnimations];
}
@end
