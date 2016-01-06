//
//  JumpStarView.m
//  CoreAnimations
//
//  Created by Kitten Yang on 9/17/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "JumpStarView.h"


#define jumpDuration 0.125
#define downDuration 0.215

@interface JumpStarView()
@property(nonatomic,strong)UIImageView *starView;
@property(nonatomic,strong)UIImageView *shadowView;
@end

@implementation JumpStarView{
    BOOL animating;
}

-(id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    if (self.starView == nil) {
        self.starView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - (self.bounds.size.width-6)/2, 0, self.bounds.size.width-6, self.bounds.size.height - 6)];
        self.starView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.starView];
    }
    if (self.shadowView == nil) {
        self.shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 10/2, self.bounds.size.height - 3, 10, 3)];
        self.shadowView.alpha = 0.4;
        self.shadowView.image = [UIImage imageNamed:@"shadow_new"];
        [self addSubview:self.shadowView];
    }
    
}

-(void)setState:(STATE)state{
    _state = state;
    self.starView.image = _state==Mark? _markedImage : _non_markedImage;
}

//上弹动画
-(void)animate{

    if (animating == YES) {
        return;
    }
    
    animating = YES;
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(M_PI_2);
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.fromValue = @(self.starView.center.y);
    positionAnima.toValue = @(self.starView.center.y - 14);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = jumpDuration;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    animGroup.delegate = self;
    animGroup.animations = @[transformAnima,positionAnima];
    
    [self.starView.layer addAnimation:animGroup forKey:@"jumpUp"];
}

- (void)animationDidStart:(CAAnimation *)anim{
    
    if ([anim isEqual:[self.starView.layer animationForKey:@"jumpUp"]]) {
        [UIView animateWithDuration:jumpDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _shadowView.alpha = 0.2;
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width*1.6, _shadowView.bounds.size.height);
        } completion:NULL];
        
    }else if ([anim isEqual:[self.starView.layer animationForKey:@"jumpDown"]]){
        
        [UIView animateWithDuration:jumpDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _shadowView.alpha = 0.4;
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width/1.6, _shadowView.bounds.size.height);
            
        } completion:NULL];
        
    }
}

//下落动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if ([anim isEqual:[self.starView.layer animationForKey:@"jumpUp"]]) {
        
        self.state = self.state==Mark?NONMark:Mark;
        NSLog(@"state:%ld",_state);
        CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        transformAnima.fromValue = @(M_PI_2);
        transformAnima.toValue = @(M_PI);
        transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
        positionAnima.fromValue = @(self.starView.center.y - 14);
        positionAnima.toValue = @(self.starView.center.y);
        positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.duration = downDuration;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = NO;
        animGroup.delegate = self;
        animGroup.animations = @[transformAnima,positionAnima];
        
        [self.starView.layer addAnimation:animGroup forKey:@"jumpDown"];
        
    }else if([anim isEqual:[self.starView.layer animationForKey:@"jumpDown"]]){
        
        [self.starView.layer removeAllAnimations];
        animating = NO;
    }
    
}

@end
