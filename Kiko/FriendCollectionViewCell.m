//
//  FriendCollectionViewCell.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "FriendCollectionViewCell.h"


@implementation FriendCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //Create rounded rect drop shadow
        [self setupRoundedRectDropShadow];
        _faceView = [[FaceView alloc] initWithFrame:self.frame];
        [self addSubview:_faceView];
    }
    return self;
}

- (void) setupRoundedRectDropShadow {
    self.layer.cornerRadius = 10.0;
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.masksToBounds = NO;
}

- (void) setupForFriend: (User *)friend withInset:(float) inset{
    self.nameLabel.text = friend.name;
    
    float stringHeight = self.nameLabel.bounds.size.height;
    
    CGRect cellBounds = CGRectMake(self.bounds.origin.x + inset, self.bounds.origin.y + inset, self.bounds.size.width - inset*2, self.bounds.size.height - (inset * 2 + stringHeight));
    
    [_faceView drawFace:friend.face withFaceFrame:cellBounds];
}

@end
