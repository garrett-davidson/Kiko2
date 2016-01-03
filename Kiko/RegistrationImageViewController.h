//
//  RegistrationImageViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface RegistrationImageViewController : UIViewController

@property (nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *trackingView;

@property (strong, nonatomic) IBOutlet UIView *buttonsView;
- (IBAction)retakePhoto:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
