//
//  SelectableFriendCollectionViewCell.m
//  Kiko
//
//  Created by Garrett Davidson on 1/4/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import "SelectableFriendCollectionViewCell.h"

#define kSelectionCircleRadius 10


@implementation SelectableFriendCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self drawSelectionCircle];

    return self;
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

@end
