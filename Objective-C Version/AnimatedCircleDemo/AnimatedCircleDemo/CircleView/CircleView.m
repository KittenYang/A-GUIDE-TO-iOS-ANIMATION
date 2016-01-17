//
//  CircleView.m
//  AnimatedCircleDemo
//
//  Created by Kitten Yang on 7/23/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

+ (Class)layerClass{
    return [CircleLayer class];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleLayer = [CircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

@end
