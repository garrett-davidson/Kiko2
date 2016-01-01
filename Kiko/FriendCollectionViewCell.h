//
//  FriendCollectionViewCell.h
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendCollectionViewCell : UICollectionViewCell

@property (nonatomic) CAShapeLayer *faceLayer;
@property (nonatomic) CAShapeLayer *circleLayer;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void) setupForFriend: (User *)friend withInset:(float) inset;

@end
