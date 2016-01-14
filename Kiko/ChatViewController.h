//
//  ChatViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "KikoChat.h"

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *trackingView;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIView *sendOptionsView;

@property (nonatomic) KikoChat *currentChat;

- (void) createNewChatWithFriends:(NSArray *)friends;
- (IBAction)beginRecording:(id)sender;
- (IBAction)sendCurrentMessage:(id)sender;
- (IBAction)cancelCurrentMessage:(id)sender;

@end
