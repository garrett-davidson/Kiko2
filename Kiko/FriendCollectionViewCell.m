//
//  FriendCollectionViewCell.m
//  Kiko
//
//  Created by Garrett Davidson on 12/31/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "FriendCollectionViewCell.h"

#define kSelectionCircleRadius 10

@implementation FriendCollectionViewCell

- (void) setFaceLayer:(CAShapeLayer *)faceLayer {
    [_faceLayer removeFromSuperlayer];
    
    _faceLayer = faceLayer;
    
    [self.layer addSublayer:_faceLayer];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //Create rounded rect drop shadow
        [self setupRoundedRectDropShadow];
        [self drawSelectionCircle];
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

- (void) drawSelectionCircle {
    self.circleLayer = [CAShapeLayer new];
    [self.layer addSublayer:self.circleLayer];
    
    float diameter = 2*kSelectionCircleRadius;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width - 5, 5, diameter, diameter)];
    [self.circleLayer setPath:circlePath.CGPath];
    
    [self.circleLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [self.circleLayer setLineWidth:0.5];
    
    [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.circleLayer setFillColor:selected ? [UIColor purpleColor].CGColor : [UIColor clearColor].CGColor];
}

- (void) setupForFriend: (User *)friend withInset:(float) inset{
    self.nameLabel.text = friend.name;
    
    float stringHeight = self.nameLabel.bounds.size.height;
    CAShapeLayer *image = [friend getImage];
    
    //Draw face
    CGRect cellBounds = CGRectMake(self.bounds.origin.x + inset, self.bounds.origin.y + inset, self.bounds.size.width - inset*2, self.bounds.size.height - (inset * 2 + stringHeight));
    CGRect imageBounds = CGPathGetBoundingBox(image.path);
    self.faceLayer = image;
    float widthScale = cellBounds.size.width/imageBounds.size.width;
    float heightScale = cellBounds.size.height/imageBounds.size.height;
    image.transform = CATransform3DMakeScale(widthScale, heightScale, 1);
    image.position = CGPointMake(-imageBounds.origin.x * widthScale + inset, -imageBounds.origin.y * heightScale + inset);
}

@end
