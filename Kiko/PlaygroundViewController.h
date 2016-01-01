//
//  PlaygroundViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 12/10/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaygroundViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *trackingView;
@property (weak, nonatomic) IBOutlet UIView *customizeButton;


- (IBAction)customize:(id)sender;

@end