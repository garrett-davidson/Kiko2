//
//  AddFriendsViewController.m
//  Kiko
//
//  Created by Garrett Davidson on 12/29/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "FriendSelectionViewController.h"
#import "ChatViewController.h"
#import "SelectableFriendCollectionViewCell.h"
#import "User.h"

#define kDefaultCellSize 120

@interface FriendSelectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *userFriends;
    NSMutableArray *selectedFriends;
}

@end

@implementation FriendSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    userFriends = [User currentUser].friends;
    
    self.collectionView.allowsMultipleSelection = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"StartChatSegue"]) {
        ChatViewController *dest = (ChatViewController*) ((UINavigationController *)segue.destinationViewController).topViewController;

        [dest createNewChatWithFriends:selectedFriends];
    }
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [selectedFriends addObject:userFriends[indexPath.row]];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [selectedFriends removeObject:userFriends[indexPath.row]];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return userFriends.count;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectableFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    User *userFriend = [userFriends[indexPath.row] fetchIfNeeded];
    
    float inset = cell.bounds.size.width * 0.20;
    
    [cell setupForFriend:userFriend withInset:inset];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kDefaultCellSize, kDefaultCellSize);
}

@end
