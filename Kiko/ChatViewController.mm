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
#import "MessageTableViewCell.h"

@interface ChatViewController ()< UITableViewDelegate, UITableViewDataSource> {
    KikoAnimator *animator;
    KikoFaceTracker *tracker;
    KikoMessage *currentMessage;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tracker = [KikoFaceTracker sharedTracker];
    [tracker setTrackingImageView:self.trackingView];
    self.trackingView.layer.borderColor = [UIColor blackColor].CGColor;
    self.trackingView.layer.borderWidth = 3.0;
    animator = [KikoAnimator sharedAnimator];
    [animator setAnimationView:self.animationView];
    self.animationView.layer.borderColor = [UIColor blackColor].CGColor;
    self.animationView.layer.borderWidth = 3.0;
}

- (void) setCurrentChat:(KikoChat *)currentChat {
    _currentChat = currentChat;
    [self.tableView reloadData];
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
            [self showSendOptions];
            break;
        default:
            break;
    }
}

- (void) showSendOptions {
    [UIView setAnimationDuration:0.5];
    _sendOptionsView.frame = CGRectOffset(_sendOptionsView.frame, _sendOptionsView.frame.size.width, 0);
    [UIView commitAnimations];
}

- (void) hideSendOptions {
    [UIView setAnimationDuration:0.5];
    _sendOptionsView.frame = CGRectOffset(_sendOptionsView.frame, -_sendOptionsView.frame.size.width, 0);
    [UIView commitAnimations];
}

- (IBAction)sendCurrentMessage:(id)sender {
    [_currentChat addMessage:currentMessage];
    [self cancelCurrentMessage:nil];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentChat.messages.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [_currentChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved conversation");
        }

        if (error) {
            NSLog(@"Conversation saving error: %@", error);
        }
    }];
}

- (IBAction)cancelCurrentMessage:(id)sender {
    [currentMessage stop];
    currentMessage = nil;
    [animator unpause];
    [self hideSendOptions];
}

- (void) saveMessage {
    FacesArray *recording = [animator stopRecording];

    //TODO: Implement actal messaging
    currentMessage = [[KikoMessage alloc] initWithSender:[User getCurrentUser] andFrames:recording];

    //TODO: Implement playback
    [animator playMessage:currentMessage];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KikoMessage *selectedMessage = _currentChat.messages[indexPath.row];
    if (selectedMessage.isPlaying) {
        [animator stopPlayingMessage];
    }
    else {
        [animator playMessage:selectedMessage inView:((MessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).messageView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KikoMessage *message = _currentChat.messages[indexPath.row];

    bool isLeftCell = message.sender != [User currentUser];
    NSString *identifier;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"LeftPinch.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:80 topCapHeight:20];


    if (isLeftCell) {
        identifier = @"leftCell";
    }
    else {
        identifier = @"rightCell";
    }
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:isLeftCell ?  UITableViewCellStyleValue1 : UITableViewCellStyleValue2 reuseIdentifier:identifier andWidth:tableView.frame.size.width];
    }
    
    cell.backgroundImageView.image = backgroundImage;

    cell.faceLayer = message.faceFrames.layerArray[0];
//    cell.faceView.face = message.face;
//    message.view = cell.faceView;

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
    return self.currentChat.messages.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFaceViewHeight + kTailHeight;
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
