//
//  KYAnimatedPageControl.m
//  KYAnimatedPageControl-Demo
//
//  Created by Kitten Yang on 6/10/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#import "KYAnimatedPageControl.h"
#import "GooeyCircle.h"
#import "RotateRect.h"


@interface KYAnimatedPageControl()

@property(nonatomic,strong)Line *line;
//Indicator-STYLE
@property(nonatomic,strong)GooeyCircle *gooeyCircle;
@property(nonatomic,strong)RotateRect  *rotateRect;


@property (nonatomic) NSInteger lastIndex;

@end

@implementation KYAnimatedPageControl

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.layer addSublayer:self.line];
    [self.layer insertSublayer:self.indicator above:self.line];
    [self.line setNeedsDisplay];
}

#pragma mark - Helper

- (Line *)line {
    if (!_line) {
        _line = [Line layer];
        _line.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _line.pageCount = self.pageCount;
        _line.selectedPage = 1;
        _line.shouldShowProgressLine = self.shouldShowProgressLine;
        _line.unSelectedColor = self.unSelectedColor;
        _line.selectedColor = self.selectedColor;
        _line.bindScrollView = self.bindScrollView;
        _line.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _line;
}

- (GooeyCircle *)gooeyCircle {
    if (!_gooeyCircle) {
        _gooeyCircle = [GooeyCircle layer];
        _gooeyCircle.indicatorColor = self.selectedColor;
        _gooeyCircle.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _gooeyCircle.indicatorSize  = self.indicatorSize;
        _gooeyCircle.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _gooeyCircle;
}

- (RotateRect *)rotateRect
{
    if (!_rotateRect) {
        _rotateRect = [RotateRect layer];
        _rotateRect.indicatorColor = self.selectedColor;
        _rotateRect.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _rotateRect.indicatorSize  = self.indicatorSize;
        _rotateRect.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _rotateRect;
}

- (Indicator *)indicator {
    if (!_indicator) {
        switch (self.indicatorStyle) {
            case IndicatorStyleGooeyCircle:
                _indicator = self.gooeyCircle;
                break;
            case IndicatorStyleRotateRect:
                _indicator = self.rotateRect;
                break;
            default:
                break;
        }
        
        [_indicator animateIndicatorWithScrollView:self.bindScrollView andIndicator:self];
    }
    
    return _indicator;
}

#pragma mark -- PUBLIC Method

-(Line *)pageControlLine{
    return self.line;
}

#pragma mark -- UITapGestureRecognizer tapAction
-(void)tapAction:(UITapGestureRecognizer *)ges{
    
    NSAssert(self.bindScrollView != nil, @"You can not scroll without assigning bindScrollView");
    CGPoint location = [ges locationInView:self];
    if (CGRectContainsPoint(self.line.frame, location)) {
        CGFloat ballDistance = self.frame.size.width / (self.pageCount - 1);
        NSInteger index =  location.x / ballDistance;
        if ((location.x - index*ballDistance) >= ballDistance/2) {
            index += 1;
        }
        CGFloat HOWMANYDISTANCE =  ABS((self.line.selectedLineLength - index *((self.line.frame.size.width - self.line.ballDiameter) / (self.line.pageCount - 1)))) / ((self.line.frame.size.width - self.line.ballDiameter) / (self.line.pageCount - 1));
//        NSLog(@"howmanydistance:%f",HOWMANYDISTANCE/self.pageCount);
        
        //背景线条动画
        [self.line animateSelectedLineToNewIndex:index+1];

        //scrollview 滑动
        [self.bindScrollView setContentOffset:CGPointMake(self.bindScrollView.frame.size.width *index, 0) animated:YES];
        
        //恢复动画
        [self.indicator performSelector:@selector(restoreAnimation:) withObject:@(HOWMANYDISTANCE/self.pageCount) afterDelay:0.2];

        if(self.didSelectIndexBlock) {
            self.didSelectIndexBlock(index+1);
        }
    }
    
}

-(void)animateToIndex:(NSInteger)index
{
    NSAssert(self.bindScrollView != nil, @"You can not scroll without assigning bindScrollView");
    CGFloat HOWMANYDISTANCE =  ABS((self.line.selectedLineLength - index *((self.line.frame.size.width - self.line.ballDiameter) / (self.line.pageCount - 1)))) / ((self.line.frame.size.width - self.line.ballDiameter) / (self.line.pageCount - 1));
//    NSLog(@"howmanydistance:%f",HOWMANYDISTANCE/self.pageCount);
    
    //背景线条动画
    [self.line animateSelectedLineToNewIndex:index+1];
    
    //scrollview 滑动
    [self.bindScrollView setContentOffset:CGPointMake(self.bindScrollView.frame.size.width *index, 0) animated:YES];
    
    //恢复动画
    [self.indicator performSelector:@selector(restoreAnimation:) withObject:@(HOWMANYDISTANCE/self.pageCount) afterDelay:0.2];
    
//    NSLog(@"DidSelected index:%ld",(long)index+1);
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (!_swipeEnable) {
        return;
    }
    
    CGPoint location = [pan locationInView:self];
    if (CGRectContainsPoint(self.line.frame, location)) {
        CGFloat ballDistance = self.frame.size.width / (self.pageCount - 1);
        NSInteger index =  location.x / ballDistance;
        if ((location.x - index*ballDistance) >= ballDistance/2) {
            index += 1;
        }
        
        if (index != _lastIndex) {
            [self animateToIndex:index];
            _lastIndex = index;
        }
    }
}

@end
