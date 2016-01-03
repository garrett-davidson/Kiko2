//
//  LoginViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
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

- (BOOL) isLoggedIn {
    if ([User currentUser]) {
        return true;
    }
    return false;
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self isLoggedIn]) {
        [self performSegueWithIdentifier:@"isLoggedInSegue" sender:self];
    }
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

@end
