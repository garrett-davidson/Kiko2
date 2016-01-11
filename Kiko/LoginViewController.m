//
//  LoginViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)login:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self displayError:error];
        }
        
        else {
            [PFInstallation currentInstallation][@"user"] = user;
            [[PFInstallation currentInstallation] saveInBackground];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        }
    }];
}

- (void) displayError:(NSError *)error {
    
}
@end
