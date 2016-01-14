//
//  MessageTableViewCell.h
//  Kiko
//
//  Created by Garrett Davidson on 1/3/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) FaceView *faceView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWidth: (CGFloat) width;

@end
