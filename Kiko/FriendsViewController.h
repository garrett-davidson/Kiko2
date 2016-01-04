//
//  FriendsViewController.h
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *kikoMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *userFaceView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
