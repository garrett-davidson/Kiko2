//
//  FaceCustomizationViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 1/3/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "FaceCustomizationViewController.h"
#import "KikoCustomizations.h"
#import "CAShapeLayer+Scaling.h"

typedef enum : NSUInteger {
    KikoCustomizationTypeHair = 1,
    KikoCustomizationTypeEyes = 2
} KikoCustomizationType;

@interface FaceCustomizationViewController ()<iCarouselDataSource, iCarouselDelegate> {
    KikoCustomizationType currentCustomization;
    KikoCustomizations *customizations;
    
    CAShapeLayer *hairPreviewLayer;
}
@end

@implementation FaceCustomizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentCustomization = KikoCustomizationTypeHair;
    customizations = nil;
    
    PFQuery *customizationsQuery = [PFQuery queryWithClassName:@"KikoCustomizations"];
    [customizationsQuery fromLocalDatastore];
    [customizationsQuery includeKey:@"hair"];
    [customizationsQuery includeKey:@"eyes"];
    [customizationsQuery getObjectInBackgroundWithId:@"zaV9sxvDHn" block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        customizations = (KikoCustomizations *) object;
        [_carouselView reloadData];
    }];
    
    _hairButton.layer.cornerRadius = 10;
    _eyesButton.layer.cornerRadius = 10;
    
    _carouselView.type = iCarouselTypeRotary;
    
    _faceView.face = _user.face;
    
    hairPreviewLayer = [[CAShapeLayer alloc] init];
    [_hairButton.layer addSublayer:hairPreviewLayer];
    
    self.navigationItem.hidesBackButton = true;
}

- (void) viewWillDisappear:(BOOL)animated {
    [_user saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfItemsInCarousel:(iCarousel *)carousel {
    switch (currentCustomization) {
        case KikoCustomizationTypeHair:
            return customizations.hair.count;
            break;
            
        case KikoCustomizationTypeEyes:
            return customizations.eyes.count;
            break;
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *cell = view.tag == currentCustomization ? view : [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    cell.tag = currentCustomization;
    
    switch (cell.tag) {
        case KikoCustomizationTypeHair: {
            cell.backgroundColor = [UIColor blueColor];
            KikoHair *hair = customizations.hair[index];
            CAShapeLayer *hairLayer;
            if (cell.layer.sublayers.count == 0) {
                hairLayer = [CAShapeLayer new];
                hairLayer.strokeColor = [UIColor blackColor].CGColor;
                hairLayer.fillColor = [UIColor blackColor].CGColor;
                [cell.layer addSublayer:hairLayer];
            }
            else {
                hairLayer = (CAShapeLayer*) cell.layer.sublayers[0];
            }
            
            [hairLayer setPath:hair.path.CGPath inRect:cell.frame];
            
            break;
        }
            
        case KikoCustomizationTypeEyes: {
            cell.backgroundColor = [UIColor blueColor];
            KikoEyes *eyes = customizations.eyes[index];
            UIImageView *leftEyeImageView;
            UIImageView *rightEyeImageView;
            
            if (cell.subviews.count == 0) {
                leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 40, 40)];
                rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 30, 40, 40)];
                
                leftEyeImageView.tag = 1;
                rightEyeImageView.tag = 2;
                [cell addSubview:leftEyeImageView];
                [cell addSubview:rightEyeImageView];
            }
            else {
                leftEyeImageView = [cell viewWithTag:1];
                rightEyeImageView = [cell viewWithTag:2];
            }
            
            leftEyeImageView.image = [eyes getLeftEyeImage];
            rightEyeImageView.image = [eyes getRightEyeImage];
            
            break;
        }
    }
    
    return cell;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return true;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.1f;
        }
        case iCarouselOptionFadeMax:
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel{
    switch (currentCustomization) {
        case KikoCustomizationTypeHair: {
            [self displayHair:customizations.hair[self.carouselView.currentItemIndex]];
            break;
        }
            
        case KikoCustomizationTypeEyes: {
            [self displayEyes:customizations.eyes[self.carouselView.currentItemIndex]];
            break;
        }
    }
}

- (void) displayHair: (KikoHair *) hair {
    _user.face.hair = hair;
    _customizationNameLabel.text = hair.name;
    [hairPreviewLayer setPath:hair.path.CGPath inRect:_hairButton.bounds];
    [_faceView redraw];
}

- (void) displayEyes: (KikoEyes *) eyes {
    _user.face.eyes = eyes;
    _customizationNameLabel.text = eyes.name;
    
    _leftEyeImagePreview.image = [eyes getLeftEyeImage];
    _rightEyeImagePreview.image = [eyes getRightEyeImage];
    [_faceView redraw];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchCustomizationType:(id)sender {
    currentCustomization = ((UITapGestureRecognizer*)sender).view.tag;
    [_carouselView reloadData];
}

- (IBAction)saveFace:(id)sender {
    if (_isRegistering) {
        [self performSegueWithIdentifier:@"PlaygroundSegue" sender:self];
    }
    
    else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}
@end
