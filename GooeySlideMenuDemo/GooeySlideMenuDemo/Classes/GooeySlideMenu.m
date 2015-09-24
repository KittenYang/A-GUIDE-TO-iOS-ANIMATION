//
//  GooeySlideMenu.m
//  GooeySlideMenuDemo
//
//  Created by Kitten Yang on 15/8/11.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideMenuButton.h"


#define SPACE 30
#define EXTRAAREA 50
#define BUTTONHEIGHT 40

@interface GooeySlideMenu()

@property (nonatomic,strong) CADisplayLink *displayLink;
@property  NSInteger animationCount; // 动画的数量

@end

@implementation GooeySlideMenu{
    
    UIView *helperCenterView;
    UIView *helperSideView;
    UIVisualEffectView *blurView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
}


-(id)initWithTitles:(NSArray *)titles{
    
    return [self initWithTitles:titles withButtonHeight:40.0f withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}


-(id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style{
    
    self = [super init];
    if (self) {
        
        keyWindow = [[UIApplication sharedApplication]keyWindow];
        
        blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:style]];
        blurView.frame = keyWindow.frame;
        blurView.alpha = 0.0f;
        
        helperSideView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        helperSideView.backgroundColor = [UIColor redColor];
        helperSideView.hidden = YES;
        [keyWindow addSubview:helperSideView];
        
        helperCenterView = [[UIView alloc]initWithFrame:CGRectMake(-40, CGRectGetHeight(keyWindow.frame)/2 - 20, 40, 40)];
        helperCenterView.backgroundColor = [UIColor yellowColor];
        helperCenterView.hidden = YES;
        [keyWindow addSubview:helperCenterView];
        
        
        self.frame = CGRectMake(- keyWindow.frame.size.width/2 - EXTRAAREA, 0, keyWindow.frame.size.width/2+EXTRAAREA, keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [keyWindow insertSubview:self belowSubview:helperSideView];
        
        _menuColor = menuColor;
        self.menuButtonHeight = height;
        [self addButtons:titles];
        
    }
    
    return self;
}



-(void)addButtons:(NSArray *)titles{

    
    
    if (titles.count % 2 == 0) {
        
        NSInteger index_down = titles.count/2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {


            NSString *title = titles[i];
            SlideMenuButton *home_button = [[SlideMenuButton alloc]initWithTitle:title];
            if (i >= titles.count / 2) {

                index_up ++;
                home_button.center = CGPointMake(keyWindow.frame.size.width/4, keyWindow.frame.size.height/2 + self.menuButtonHeight*index_up + SPACE*index_up + SPACE/2 + self.menuButtonHeight/2);
            }else{
                
                index_down --;
                home_button.center = CGPointMake(keyWindow.frame.size.width/4, keyWindow.frame.size.height/2 - self.menuButtonHeight*index_down - SPACE*index_down - SPACE/2 - self.menuButtonHeight/2);
            }
            
            home_button.bounds = CGRectMake(0, 0, keyWindow.frame.size.width/2 - 20*2, self.menuButtonHeight);
            home_button.buttonColor = _menuColor;
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            
            home_button.buttonClickBlock = ^(){
              
                [WeakSelf tapToUntrigger:nil];
                WeakSelf.menuClickBlock(i,title,titles.count);
            };
            
        }
        


        
        
    }else{
        
        NSInteger index = (titles.count - 1) /2 +1;
        for (NSInteger i = 0; i < titles.count; i++) {
            
            index --;
            NSString *title = titles[i];
            SlideMenuButton *home_button = [[SlideMenuButton alloc]initWithTitle:title];
            home_button.center = CGPointMake(keyWindow.frame.size.width/4, keyWindow.frame.size.height/2 - self.menuButtonHeight*index - 20*index);
            home_button.bounds = CGRectMake(0, 0, keyWindow.frame.size.width/2 - 20*2, self.menuButtonHeight);
            home_button.buttonColor = _menuColor;
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.buttonClickBlock = ^(){
                
                [WeakSelf tapToUntrigger:nil];
                WeakSelf.menuClickBlock(i,title,titles.count);
            };
            
        }
    }
    
    
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, 0)];
    
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, self.frame.size.height) controlPoint:CGPointMake(keyWindow.frame.size.width/2+diff, keyWindow.frame.size.height/2)];

    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);

}



-(void)trigger{
    

    if (!triggered) {
        
        [keyWindow insertSubview:blurView belowSubview:self];
        

        [UIView animateWithDuration:0.3 animations:^{
        
            self.frame = self.bounds;
        
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            helperSideView.center = CGPointMake(keyWindow.center.x, helperSideView.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
    
        [UIView animateWithDuration:0.3 animations:^{
            blurView.alpha = 1.0f;
            
        }];
        
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            helperCenterView.center = keyWindow.center;
            
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger:)];
                [blurView addGestureRecognizer:tapGes];
                
                [self finishAnimation];
            }
        }];
        

        [self animateButtons];
        
        triggered = YES;
        
    }else{
        
        [self tapToUntrigger:nil];
    }
    
}


-(void)animateButtons{
    
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            menuButton.transform =  CGAffineTransformIdentity;
            
        } completion:NULL];
        
    }

    
}


-(void)tapToUntrigger:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(-keyWindow.frame.size.width/2-EXTRAAREA, 0, keyWindow.frame.size.width/2+EXTRAAREA, keyWindow.frame.size.height);
    }];
    
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperSideView.center = CGPointMake(-helperSideView.frame.size.height/2, helperSideView.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{

        blurView.alpha = 0.0f;
        
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperCenterView.center = CGPointMake(-helperSideView.frame.size.height/2, CGRectGetHeight(keyWindow.frame)/2);
        
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    triggered = NO;
    
}



//动画之前调用
-(void)beforeAnimation{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

//动画完成之后调用
-(void)finishAnimation{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}



-(void)displayLinkAction:(CADisplayLink *)dis{
    
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[helperCenterView.layer presentationLayer];

    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    
    
    diff = sideRect.origin.x - centerRect.origin.x;
//    NSLog(@"diff:%f",diff);
    
    [self setNeedsDisplay];
    
}


@end






