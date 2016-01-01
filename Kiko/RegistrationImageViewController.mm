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

#define DEBUGGING

//If debugging
#ifdef DEBUGGING
#import "Face.h"
#import "User.h"
#endif

@interface RegistrationImageViewController () {
    KikoAnimator *animator;
    KikoFaceTracker *tracker;
}



@end

@implementation RegistrationImageViewController

#ifdef DEBUGGING
//For debugging only
- (void) savePersonAsFriend {
    Face *face = [[Face alloc] initWithPath:self.userInfo[@"userFacePath"]];
    User *newFriend = [[User alloc] initWithName:self.userInfo[@"name"]  andFace:face];
    
    NSArray *oldFriends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
    
    if (oldFriends == nil) {
        oldFriends = [NSArray array];
    }
    
    oldFriends = [oldFriends arrayByAddingObject:[NSKeyedArchiver archivedDataWithRootObject:newFriend]];
    
    [[NSUserDefaults standardUserDefaults] setObject:oldFriends forKey:@"friends"];
}
#endif

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
}


- (IBAction)retakePhoto:(id)sender {
    [animator unpause];
    [self hideButtons];
}

- (IBAction)savePhoto:(id)sender {
    [self.userInfo setObject:[animator getCurrentPath] forKey:@"userFacePath"];
    [self performSegueWithIdentifier:@"CustomizeFaceSegue" sender:self];
    
#ifdef DEBUGGING
    [self savePersonAsFriend];
#endif
}

- (IBAction)takePhoto:(id)sender {
    [animator pause];
    [self showButtons];
}

- (void) showButtons {[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelay:1.0];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
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
