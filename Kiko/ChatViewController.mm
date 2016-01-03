//
//  ChatViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "ChatViewController.h"
#import "KikoAnimator.h"
#import "KikoFaceTracker.h"

@interface ChatViewController ()< UITableViewDelegate, UITableViewDataSource> {
    KikoAnimator *animator;
    KikoFaceTracker *tracker;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tracker = [KikoFaceTracker sharedTracker];
    [tracker setTrackingImageView:self.trackingView];
    animator = [KikoAnimator sharedAnimator];
    [animator setAnimationView:self.animationView];
}

- (void) setCurrentChat:(KikoChat *)currentChat {
    [self.tableView reloadData];
    
    _currentChat = currentChat;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    if (!self.currentChat.name) {
        [animator pause];
        [tracker pause];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Chat name"
                                                                       message:@"Please enter a name for this chat."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // optionally configure the text field
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *textField = [alert.textFields firstObject];
                                                             NSString *chatName = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                                                             self.navigationItem.title = chatName;
                                                             self.currentChat.name = chatName;
                                                             [tracker unpause];
                                                             [animator unpause];
                                                         }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else {
        [tracker unpause];
        [animator unpause];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [animator pause];
    [tracker pause];
}

- (void) createNewChatWithFriends:(NSArray *)friends {
    self.currentChat = [[KikoChat alloc] initWithName:nil andFriends:friends];
    if (friends.count == 1) {
        self.currentChat.name = ((User*)friends[0]).name;
    }
}

- (IBAction)beginRecording:(id)sender {
    UILongPressGestureRecognizer *press = sender;
    
    switch (press.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Began recording");
            [animator startRecording];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Saved recording");
            [self saveMessage];
            break;
        default:
            break;
    }
}

- (void) saveMessage {
    NSArray *recording = [animator endRecording];
    
    KikoMessage *newMessage = [[KikoMessage alloc] initWithSender:[User getCurrentUser] andFrames:recording];
    
    [animator playMessage:newMessage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentChat.messages.count;
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
