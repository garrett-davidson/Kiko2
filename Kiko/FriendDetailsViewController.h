//
//  FriendDetailsViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    Friends,
    SentRequest,
    ReceivedRequest,
    NotFriends
} FriendStatus;

@interface FriendDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *kikoMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *userFaceView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *friendButton;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;

@property (nonatomic) User *userFriend;
@property (nonatomic) FriendStatus status;

- (IBAction)friendButtonPressed:(id)sender;

@end
