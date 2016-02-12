//
//  FriendCollectionViewCell.h
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "FaceView.h"

@interface FriendCollectionViewCell : UICollectionViewCell

@property (nonatomic) FaceView *faceView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void) setupForFriend: (User *)userFriend withInset:(float) inset;

@end
