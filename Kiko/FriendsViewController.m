//
//  FriendsViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendCollectionViewCell.h"
#import "User.h"
#import "FriendDetailsViewController.h"

@interface FriendsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *friendsToShow;
    PFQuery *friendQuery;
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friendQuery = [PFQuery queryWithClassName:@"_User"];
    [friendQuery whereKey:@"username" notEqualTo:[User currentUser].username];
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
    User *currentUser = [User currentUser];
    self.kikoMinutesLabel.text = [NSString stringWithFormat:@"%ld Kiko Minutes", currentUser.totalKikoMinutes.longValue];
    self.friendCountLabel.text = [NSString stringWithFormat:@"%ld Friends", currentUser.friends.count];
    self.usernameLabel.text = currentUser.name;
    CGRect bounds = CGRectInset(self.userFaceView.bounds, 5, 5);
    
    [self.userFaceView.layer addSublayer:[currentUser getImageScaledForRect:bounds]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"FriendDetailsSegue" sender:friendsToShow[indexPath.row]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FriendDetailsViewController *dest = (FriendDetailsViewController*) ((UINavigationController*)segue.destinationViewController).topViewController;
    
    dest.friend = sender;
    dest.status = [self statusForFriend:sender];
}

- (FriendStatus) statusForFriend:(User *)friend {
    User *currentUser = [User currentUser];
    if ([currentUser.friends containsObject:friend]) {
        return Friends;
    }
    
    else if ([currentUser.sentFriendRequests containsObject:friend]) {
        return SentRequest;
    }
    
    else if ([currentUser.receivedFriendRequests containsObject:friend]) {
        return ReceivedRequest;
    }
    
    else {
        return NotFriends;
    }
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
