
//
//  KikoUITests.m
//  KikoUITests
//
//  Created by Garrett Davidson on 12/7/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <XCTest/XCTest.h>

#define kExistingUsername @"rkapurbh"
#define kExistingEmail @"rk2749@columbia.edu"

@interface KikoUITests : XCTestCase

@end

@implementation KikoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self basicSignUp:app];
    //[self signUpWithExistingUserName:app];
    //[self signUpWithExistingEmail:app];
    //[self randomizedFillInSignUp:app];
    
    
    [self takePicMoveNext:app];
    //[self takePicAndReset:app];
    
    
    
    
    
    //[self selectEyesOnly:app];
    //[self selectHairOnly:app];
    //[self selectNeitherHairNorEyes:app];
    [self selectEveyrthing:app];
    
    
    
    
    
    
    
    
    
    
    
        
    
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void) basicSignUp : (XCUIApplication *) app{
    
    [app.buttons[@"Sign Up"] tap];
    
    
    int randomInt = arc4random_uniform(1000);
    
    NSString *name = @"Rahul Kapur";
    NSString *uni = [NSString stringWithFormat:@"rk%u@columbia.edu", randomInt];
    NSString *username = [NSString stringWithFormat:@"Rasta%u", randomInt];
    NSString *password = @"rasta123";

    [self fillName:app :name];
    [self fillSchoolEmail:app :uni];
    [self fillUsername:app :username];
    [self fillPassword:app :password];
    
    
    [app.staticTexts[@"Submit"] tap];
    
    
}

- (void) signUpWithExistingUserName : (XCUIApplication *) app{
    [app.buttons[@"Sign Up"] tap];
    
    int randomInt = arc4random_uniform(1000);
    
    NSString *name = @"Rahul Kapur";
    NSString *uni = [NSString stringWithFormat:@"rk%u@columbia.edu", randomInt];
    NSString *username = kExistingUsername;
    NSString *password = @"rasta123";
    
    [self fillName:app :name];
    [self fillSchoolEmail:app :uni];
    [self fillUsername:app :username];
    [self fillPassword:app :password];

    
    
    [app.staticTexts[@"Submit"] tap];
    
}

- (void) signUpWithExistingEmail : (XCUIApplication *) app {
    
    [app.buttons[@"Sign Up"] tap];
    
    int randomInt = arc4random_uniform(1000);
    
    NSString *name = @"Rahul Kapur";
    NSString *uni = kExistingEmail;
    NSString *username = [NSString stringWithFormat:@"Rasta%u", randomInt];
    NSString *password = @"rasta123";
    
    [self fillName:app :name];
    [self fillSchoolEmail:app :uni];
    [self fillUsername:app :username];
    [self fillPassword:app :password];
    
    
    [app.staticTexts[@"Submit"] tap];
    
    
}

- (void) randomizedFillInSignUp : (XCUIApplication *) app{
    [app.buttons[@"Sign Up"] tap];
    
    int randomInt = arc4random_uniform(1000);
    
    NSString *name = @"Rahul Kapur";
    NSString *uni = [NSString stringWithFormat:@"rk%u@columbia.edu", randomInt];
    NSString *username = [NSString stringWithFormat:@"Rasta%u", randomInt];
    NSString *password = @"rasta123";
    
    
    NSArray *randomIntArray = @[@3,@1,@2,@0];
    
    
    
    for (int i = 0; i < [randomIntArray count]; i++) {
        
        int number = [(NSNumber *)randomIntArray[i] intValue];
        switch (number) {
            case 0:
                [self fillName:app :name];
                break;
            case 1:
                [self fillSchoolEmail:app :uni];
                break;
            case 2:
                [self fillUsername:app :username];
                break;
            case 3:
                [self fillPassword:app :password];
                break;
        }
    }
    
    
    
    
    [app.staticTexts[@"Submit"] tap];
    
    
    
    
}

- (void) fillName: (XCUIApplication *) app :(NSString *)name {
    XCUIElement *fullNameTextField = app.textFields[@"Full Name"];
    [fullNameTextField tap];
    [fullNameTextField typeText:name];
    
}

- (void) fillSchoolEmail: (XCUIApplication *) app :(NSString *)schoolEmail {
    XCUIElement *schoolEmailTextField = app.textFields[@"School Email"];
    [schoolEmailTextField tap];
    [schoolEmailTextField typeText:schoolEmail];
    
}

- (void) fillUsername: (XCUIApplication *) app :(NSString *)userName {
    
    XCUIElement *usernameTextField = app.textFields[@"Username"];
    [usernameTextField tap];
    [usernameTextField typeText:userName];
    
}

-(void) fillPassword : (XCUIApplication *) app : (NSString *) password {
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField tap];
    [passwordSecureTextField typeText:password];
}



-(void) takePicMoveNext : (XCUIApplication *) app{
    [self takePic:app];
    [self clickNext:app];
    
    
}

-(void) takePicAndReset : (XCUIApplication *) app{
    [self takePic:app];
    [self resetPic:app];
    [self takePic:app];
    [self clickNext:app];
    
}

-(void)takePic : (XCUIApplication *) app {
    XCUIElement *takePictureStaticText = app.staticTexts[@"Take Picture!"];
    [takePictureStaticText tap];
}

-(void)clickNext : (XCUIApplication *) app {
    XCUIElement *next= app.images[@"nextbutton"];
    [next tap];
    
}

-(void)resetPic : (XCUIApplication *) app {
    XCUIElement *reset= app.images[@"resetbutton"];
    [reset tap];
}

- (void) selectHairOnly : (XCUIApplication *) app{
    [self tapHairSelection:app];
     XCUIElement *swipeElement = [self returnSwipeElement:app];
    [swipeElement swipeRight];
    [self doneCustomization:app];
    
    
}

- (void) selectEyesOnly : (XCUIApplication *) app{
    [self tapEyesSelection:app];
    XCUIElement *swipeElement = [self returnSwipeElement:app];
    [swipeElement swipeRight];
    [self doneCustomization:app];
    
}

-(void) selectNeitherHairNorEyes : (XCUIApplication *) app{
    [self doneCustomization:app];
    
}

-(void) selectEveyrthing : (XCUIApplication *) app{
    [self selectHairOnly:app];
    [self selectEyesOnly:app];
    [self doneCustomization:app];
    
    
}



-(XCUIElement *) returnSwipeElement : (XCUIApplication *) app {
    
    XCUIElement *element1 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    
    
    XCUIElement *element2 = [[[[[element1 childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3];
    
    return element2;

    
}

-(void) tapHairSelection : (XCUIApplication *) app{
    XCUIElement *hairButton = app.buttons[@"hair"];
    [hairButton tap];
    
}

-(void) tapEyesSelection  : (XCUIApplication *) app{
    XCUIElement *eyesButton = app.buttons[@"eyes"];
    [eyesButton tap];
    
}

-(void) doneCustomization : (XCUIApplication *) app {
    [app.navigationBars[@"Face Customization"].buttons[@"Done"] tap];

}

-(void) logIn {
    
}

-(void) randomizedChangeSelection {
    
}



@end
