//
//  RegisterViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegistrationImageViewController.h"
#import "User.h"

@interface RegisterViewController () {
    User *newUser;
}

@end

@implementation RegisterViewController

enum InputFields {
    name = 0,
    email = 1,
    username = 2,
    password = 3
};

NSArray *fields;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fields = [NSArray arrayWithObjects:self.nameField, self.emailField, self.usernameField, self.passwordField, nil];
    
    for (UITextField *field in fields) {
        field.inputAccessoryView = self.nextButton;
    }
    
    self.activityView.layer.cornerRadius = 10;
    [User logOut];
}

- (void) viewDidAppear:(BOOL)animated {
    [fields[0] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextField:(id)sender {
    NSInteger tag = [self findFirstResponder].tag;
    if (tag < password) {
        [fields[tag+1] becomeFirstResponder];
    }
    else {
        [fields[password] resignFirstResponder];
        
        BOOL shouldSubmit = true;
        for (UITextField *field in fields) {
            if (![self isValid:field]) {
                shouldSubmit = false;
                break;
            }
        }
        
        if (shouldSubmit) [self submit];
    }
}

- (void) submit {
    
    [self showSpinner];
    
    newUser = [User object];
    
    newUser.name = self.nameField.text;
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    newUser.friends = [NSArray array];
    newUser.sentFriendRequests = [NSArray array];
    newUser.receivedFriendRequests = [NSArray array];
    newUser.allFaces = [NSArray array];

    newUser.totalKikoMinutes = @0;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"New user created");
            [PFInstallation currentInstallation][@"user"] = newUser;
            [[PFInstallation currentInstallation] saveInBackground];
            [self performSegueWithIdentifier:@"TakeImageSegue" sender:self];
        }
        
        if (error) {
            NSLog(@"%@", error);
            [self hideSpinner];
            [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert] animated:true completion:nil];
        }
    }];
}

- (void) showSpinner {
    self.activityView.hidden = false;
    [self.activityIndicator startAnimating];
}

- (void) hideSpinner {
    self.activityView.hidden = true;
    [self.activityIndicator stopAnimating];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[RegistrationImageViewController class]]) {
        RegistrationImageViewController *dest = (RegistrationImageViewController*)segue.destinationViewController;
        dest.user = newUser;
    }
}

- (UITextField *) findFirstResponder {
    for (UITextField *field in fields) {
        if (field.isFirstResponder) {
            return field;
        }
    }
    
    return nil;
}

- (IBAction) validateInputField: (UITextField *)field {
    if (field.tag != password)
        field.text = [field.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    field.backgroundColor = [self isValid:field] ? [UIColor whiteColor] : [UIColor redColor];
}

- (BOOL) isValid: (UITextField*)field {
    NSRegularExpression *validationRegex;
    NSError *err;
    
    switch (field.tag) {
        case name:
            validationRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9]{2,}$" options:0 error:&err];
            break;
            
        case email:
            //Full email regex
            //([-!#-'*+/-9=?A-Z^-~]+(\\.[-!#-'*+/-9=?A-Z^-~]+)*|\"([]!#-[^-~ \\t]|(\\\\[\\t -~]))+\")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+
            validationRegex = [NSRegularExpression regularExpressionWithPattern:@".+@(purdue|columbia)\\.edu$" options:0 error:&err];
            break;
            
        case username:
            validationRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9]{1,}$" options:0 error:&err];
            break;
            
        case password:
            validationRegex = [NSRegularExpression regularExpressionWithPattern:@".{8,}" options:0 error:&err];
            break;
            
        default:
            NSLog(@"Unrecognized field");
            break;
    }
    
    if (err) {
        NSLog(@"%@", err);
    }
    
    return [validationRegex firstMatchInString:field.text options:0 range:NSMakeRange(0, field.text.length)] != nil;
    
//    return true;
}

- (IBAction)updateButtonText:(id)sender {
    UITextField *field = (UITextField *)sender;
    self.nextButtonLabel.text = field.tag == password ? @"Submit" : @"Next";
}

@end
