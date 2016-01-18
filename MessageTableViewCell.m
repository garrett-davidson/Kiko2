//
//  MessageTableViewCell.m
//  Kiko
//
//  Created by Garrett Davidson on 1/3/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWidth:(CGFloat)width {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _backgroundImageView = [UIImageView new];
    [self addSubview:_backgroundImageView];
    
    _faceView = [[FaceView alloc] init];
    _faceView.layer.cornerRadius = 10;

    switch (style) {
        case UITableViewCellStyleValue1:
            _backgroundImageView.frame = CGRectMake(0, 0, kFaceViewWidth + kTailWidth, kFaceViewHeight + kTailHeight);

            _faceView.frame = CGRectMake(65, 3, kFaceViewWidth - 1, kFaceViewHeight);
            break;
            
        case UITableViewCellStyleValue2:
            _backgroundImageView.frame = CGRectMake(width - (kFaceViewWidth + kTailWidth), 0, kFaceViewWidth + kTailWidth, kFaceViewHeight + kTailHeight);
            _backgroundImageView.transform = CGAffineTransformMakeScale(-1, 1);
            _faceView.frame = CGRectMake(width - (65 + kFaceViewWidth - 1), 3, kFaceViewWidth - 1, kFaceViewHeight);
            break;
            
        default:
            break;
    }
    
    [self addSubview:_faceView];
    _faceView.backgroundColor = [UIColor greenColor];
    
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
