//
//  FaceCustomizationViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 1/3/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <iCarousel/iCarousel.h>
#import "FaceView.h"

@interface FaceCustomizationViewController : UIViewController

@property (nonatomic) User *user;
@property (nonatomic) BOOL isRegistering;

@property (weak, nonatomic) IBOutlet FaceView *faceView;
@property (weak, nonatomic) IBOutlet UIView *hairButton;
@property (weak, nonatomic) IBOutlet UIView *eyesButton;
@property (weak, nonatomic) IBOutlet iCarousel *carouselView;
@property (weak, nonatomic) IBOutlet UILabel *customizationNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftEyeImagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *rightEyeImagePreview;

- (IBAction)switchCustomizationType:(id)sender;
- (IBAction)saveFace:(id)sender;

@end
