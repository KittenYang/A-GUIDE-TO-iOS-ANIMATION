//
//  LabelView.m
//  AnimatedCurveDemo
//
//  Created by yangqitao on 15/7/8.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import "LabelView.h"
#import "UIView+Convenient.h"

#define kPullingDownString   @"下拉即可刷新..."
#define kPullingUpString     @"上拉即可刷新"
#define kReleaseString       @"松开即可刷新..."

#define kPullingString   self.state == UP ? kPullingUpString : kPullingDownString

#define LabelHeight 50

@interface LabelView()

@end

@implementation LabelView{
    UILabel *titleLabel;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}


-(void)setUp {
    self.state = DOWN;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2-LabelHeight/2, self.width, LabelHeight)];
    titleLabel.text = kPullingString;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
}

-(void)setProgress:(CGFloat)progress{
    titleLabel.alpha = progress;
    if (!self.loading) {
        if (progress >= 1.0) {
            titleLabel.text = kReleaseString;
        }else{
            titleLabel.text = kPullingString;
        }
    }else{
        if (progress >= 0.91) {
            titleLabel.text = kReleaseString;
        }else{
            titleLabel.text = kPullingString;
        }
    }
    
}


@end
