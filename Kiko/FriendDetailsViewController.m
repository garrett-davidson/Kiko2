//
//  FriendDetailsViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "FriendDetailsViewController.h"
#import "FriendCollectionViewCell.h"

@interface FriendDetailsViewController () {
//    User *_friend;
//    FriendStatus _status;
    
    NSArray *friendsToShow;
    PFQuery *friendQuery;
}

@end

@implementation FriendDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friendQuery = [PFQuery queryWithClassName:@"_User"];
    [friendQuery whereKey:@"username" notEqualTo:_friend.username];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            friendsToShow = objects;
            [self.collectionView reloadData];
            NSLog(@"Retrieved %ld friends", objects.count);
        }
        
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    self.kikoMinutesLabel.text = [NSString stringWithFormat:@"%ld Kiko Minutes", _friend.totalKikoMinutes.longValue];
    self.friendCountLabel.text = [NSString stringWithFormat:@"%ld Friends", _friend.friends.count];
    self.usernameLabel.text = _friend.name;
    CGRect bounds = CGRectInset(self.userFaceView.bounds, 5, 5);
    
    [self.userFaceView.layer addSublayer:[_friend getImageScaledForRect:bounds]];
    
    [self setupButtonForStatus:_status];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupButtonForStatus:(FriendStatus)status {
    switch (status) {
        case Friends:
            _friendButton.backgroundColor = [UIColor redColor];
            _friendLabel.text = @"Remove friend";
            break;
            
        case SentRequest:
            _friendButton.backgroundColor = [UIColor grayColor];
            _friendLabel.text = @"Request sent";
            break;
            
        case ReceivedRequest:
            _friendButton.backgroundColor = [UIColor grayColor];
            _friendLabel.text = @"Confirm friend";
            break;
            
        case NotFriends:
            _friendButton.backgroundColor = [UIColor greenColor];
            _friendLabel.text = @"Add friend";
            break;
    }
}

- (IBAction)friendButtonPressed:(id)sender {
    User *currentUser = [User currentUser];
    
    switch (_status) {
        case Friends:
            //TODO:
            break;
            
        case SentRequest:
            //Nothing
            break;
            
        case ReceivedRequest:
            //TODO:
            break;
            
        case NotFriends:
            [self sendFriendRequest];
            break;
    }
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Added friend");
        }
        
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

- (void) sendFriendRequest {
    [PFCloud callFunctionInBackground:@"addFriend" withParameters:@{@"recipientId": _friend.objectId} block:
     
     ^(NSString *success, NSError *error) {
        if (!error) {
            // Push sent successfully
            NSLog(@"Sent friend request");
        }
         
         NSLog(@"%@", success);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return friendsToShow.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    User *friend = friendsToShow[indexPath.row];
    float inset = cell.bounds.size.width * 0.20;
    
    
    [cell setupForFriend:friend withInset:inset];
    
    return cell;
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
