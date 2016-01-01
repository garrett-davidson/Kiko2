//
//  RegisterViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegistrationImageViewController.h"

@interface RegisterViewController ()

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
    [self performSegueWithIdentifier:@"TakeImageSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[RegistrationImageViewController class]]) {
        RegistrationImageViewController *dest = (RegistrationImageViewController*)segue.destinationViewController;
        
        dest.userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         self.nameField.text, @"name",
                         self.emailField.text, @"email",
                         self.usernameField.text, @"username",
                         self.passwordField.text, @"password", nil];
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
