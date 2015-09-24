//
//  UCZProgressView.m
//  UCZProgressView
//
//  Created by kishikawa katsumi on 12/13/2014.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

#import "UCZProgressView.h"


@interface UCZProgressView ()

@property (nonatomic) CALayer *backgroundLayer;
@property (nonatomic) CAShapeLayer *progressLayer;
@property (nonatomic,copy)void(^progressDidStopBlock)(void);

@end

@implementation UCZProgressView

@synthesize textLabel = _textLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    self.lineWidth = 3.0;
    self.tintColor = [UIColor colorWithRed:181.0 / 255.0 green:182.0 / 255.0 blue:183.0 / 255.0 alpha:1.0];
    self.radius = 20.0;
    self.usesVibrancyEffect = YES;
    
    [self.backgroundLayer addSublayer:self.progressLayer];
    
    self.backgroundView = [self defaultBackgroundView];
    
    self.indeterminate = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundLayer.frame = self.bounds;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = self.lineWidth;
    [path addArcWithCenter:self.backgroundView.center radius:self.radius + self.lineWidth / 2 startAngle:-M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    
    self.progressLayer.path = path.CGPath;
    
    [self layoutTextLabel];
}

#pragma mark -

- (UIView *)defaultBackgroundView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    return backgroundView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView.superview) {
        [_backgroundView removeFromSuperview];
    }
    
    backgroundView.frame = self.bounds;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.backgroundLayer removeFromSuperlayer];
    [self.textLabel removeFromSuperview];
    [backgroundView.layer addSublayer:self.backgroundLayer];
    [backgroundView addSubview:self.textLabel];
    
    [self addSubview:backgroundView];
    
    _backgroundView = backgroundView;
}

- (CALayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [CALayer layer];
        _backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _backgroundLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.lineWidth = self.lineWidth;
        _progressLayer.strokeStart = 0.0;
        _progressLayer.strokeEnd = 0.0;
    }
    return _progressLayer;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = self.tintColor;
        _textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0];
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

#pragma mark -

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsLayout];
}

- (UIColor *)tintColor {
    return [UIColor colorWithCGColor:self.progressLayer.strokeColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _progressLayer.strokeColor = tintColor.CGColor;
}

- (void)setShowsText:(BOOL)showsText {
    _showsText = showsText;
    [self layoutTextLabel];
}

- (void)setBlurEffect:(UIBlurEffect *)blurEffect {
    _blurEffect = blurEffect;
    
    if (blurEffect) {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        
        self.backgroundView = visualEffectView;
        
        if (self.usesVibrancyEffect) {
            [self applyVibrancyEffect];
        }
    } else {
        self.backgroundView = [self defaultBackgroundView];
    }
}

- (void)setUsesVibrancyEffect:(BOOL)usesVibrancyEffect {
    _usesVibrancyEffect = usesVibrancyEffect;
    if (usesVibrancyEffect) {
        [self applyVibrancyEffect];
    } else {
        [self ignoreVibrancyEffect];
    }
}

- (void)applyVibrancyEffect {
    if (self.blurEffect) {
        [self.backgroundLayer removeFromSuperlayer];
        [self.textLabel removeFromSuperview];
    
        UIVisualEffectView *visualEffectView = (UIVisualEffectView *)self.backgroundView;
        
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:self.blurEffect]];
        vibrancyEffectView.frame = visualEffectView.bounds;
        [visualEffectView.contentView addSubview:vibrancyEffectView];
        
        [vibrancyEffectView.contentView addSubview:self.textLabel];
        [vibrancyEffectView.contentView.layer addSublayer:self.backgroundLayer];
    }
}

- (void)ignoreVibrancyEffect {
    if (self.blurEffect) {
        [self.backgroundLayer removeFromSuperlayer];
        [self.textLabel removeFromSuperview];
        [self.backgroundView.layer addSublayer:self.backgroundLayer];
        [self.backgroundView addSubview:self.textLabel];
    }
}

#pragma mark -

- (void)setIndeterminate:(BOOL)indeterminate {
    if (_indeterminate == indeterminate) {
        return;
    }
    _indeterminate = indeterminate;
    
    self.hidden = NO;
    
    if (indeterminate) {
        _progressLayer.strokeStart = 0.1;
        _progressLayer.strokeEnd = 1.0;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.toValue = @(M_PI);
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.repeatCount = MAXFLOAT;
        animation.cumulative = YES;
        
        [self.backgroundLayer addAnimation:animation forKey:nil];
    } else {
#if !TARGET_INTERFACE_BUILDER
        _progressLayer.actions = @{@"strokeStart": [NSNull null], @"strokeEnd": [NSNull null]};
        _progressLayer.strokeStart = 0.0;
        _progressLayer.strokeEnd = 0.0;
        
        [self.backgroundLayer removeAllAnimations];
#endif
    }
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (self.indeterminate) {
        self.indeterminate = NO;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    }
    
    if (_progress >= 1.0 && progress >= 1.0) {
        _progress = 1.0;
        return;
    }
    
    if (progress < 0.0) {
        progress = 0.0;
    }
    if (progress > 1.0) {
        progress = 1.0;
    }
    
    if (progress > 0.0) {
        self.hidden = NO;
    }
    
    self.progressLayer.actions = animated ? nil : @{@"strokeEnd": [NSNull null]};
    self.progressLayer.strokeEnd = progress;
    
    self.textLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    [self layoutTextLabel];
    
    if (progress >= 1.0) {
#if !TARGET_INTERFACE_BUILDER
        [self performFinishAnimation];
#endif
    }
    
    _progress = progress;
}

#pragma mark -

- (void)performFinishAnimation {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    CGPoint center = self.backgroundView.center;
    
    UIBezierPath *initialPath = [UIBezierPath bezierPathWithRect:self.backgroundView.bounds];
    [initialPath moveToPoint:center];
    [initialPath addArcWithCenter:center radius:self.radius startAngle:0.0 endAngle:2.0 * M_PI clockwise:YES];
    [initialPath addArcWithCenter:center radius:self.radius + self.lineWidth startAngle:0.0 endAngle:2.0 * M_PI clockwise:YES];
    initialPath.usesEvenOddFillRule = YES;
    
    maskLayer.path = initialPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.backgroundView.layer.mask = maskLayer;
    
    CGFloat outerRadius;
    CGFloat width = CGRectGetWidth(self.bounds) / 2;
    CGFloat height = CGRectGetHeight(self.bounds) / 2;
    if (width < height) {
        outerRadius = height * 1.5;
    } else {
        outerRadius = width * 1.5;
    }
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithRect:self.backgroundView.bounds];
    [finalPath moveToPoint:center];
    [finalPath addArcWithCenter:center radius:0.0 startAngle:0.0 endAngle:2.0 * M_PI clockwise:YES];
    [finalPath addArcWithCenter:center radius:outerRadius startAngle:0.0 endAngle:2.0 * M_PI clockwise:YES];
    finalPath.usesEvenOddFillRule = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.toValue = (id)finalPath.CGPath;
    animation.duration = 0.4;
    animation.beginTime = CACurrentMediaTime() + 0.4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [maskLayer addAnimation:animation forKey:@"path"];
}


- (void)progressAnimiationDidStop:(void(^)(void))block{
    self.progressDidStopBlock = block;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.progressDidStopBlock();
    self.backgroundView.layer.mask = nil;
    self.hidden = YES;
}

#pragma mark -

- (void)layoutTextLabel {
    self.textLabel.hidden = !self.showsText || self.indeterminate;
    
    if (!self.textLabel.hidden) {
        self.textLabel.textColor = self.textColor ?: self.tintColor;
        
        if (self.textSize > 0.0) {
            self.textLabel.font = [self.textLabel.font fontWithSize:self.textSize];
        }
        
        [self.textLabel sizeToFit];
        self.textLabel.center = self.backgroundView.center;
    }
}

@end
