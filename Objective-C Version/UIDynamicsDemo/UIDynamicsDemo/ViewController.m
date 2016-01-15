//
//  ViewController.m
//  UIDynamicsDemo
//
//  Created by Kitten Yang on 9/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIImageView *lockScreenView;
@property(nonatomic,strong)UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior* pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehaviour;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lockScreenView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.lockScreenView.image = [UIImage imageNamed:@"lockScreen"];
    self.lockScreenView.contentMode = UIViewContentModeScaleToFill;
    self.lockScreenView.userInteractionEnabled = YES;
    [self.view addSubview:_lockScreenView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnIt:)];
    [self.lockScreenView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnIt:)];
    [self.lockScreenView addGestureRecognizer:pan];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc]initWithItems:@[self.lockScreenView]];
    [collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-_lockScreenView.frame.size.height, 0, 0, 0)];
    [self.animator addBehavior:collisionBehaviour];
    
    
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.gravityBehaviour.gravityDirection = CGVectorMake(0.0, 1.0);
//    self.gravityBehaviour.angle = M_PI/3;
    self.gravityBehaviour.magnitude = 2.6f;
    [self.animator addBehavior:self.gravityBehaviour];
    
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.lockScreenView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 2.0f;
    self.pushBehavior.angle = M_PI;
    [self.animator addBehavior:self.pushBehavior];
    
    self.itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.itemBehaviour.elasticity = 0.35f;//1.0 完全弹性碰撞，需要非常久才能恢复；
    [self.animator addBehavior:_itemBehaviour];

}

-(void)tapOnIt:(UITapGestureRecognizer *)tapGes{
    self.pushBehavior.pushDirection = CGVectorMake(0.0f, -80.0f);
    self.pushBehavior.active = YES;//active is set to NO once the instantaneous force is applied. All we need to do is reactivate it on each button press.
}

-(void)panOnIt:(UIPanGestureRecognizer *)panGes{
    
    CGPoint location = CGPointMake(CGRectGetMidX(_lockScreenView.frame), [panGes locationInView:self.view].y);
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        [self.animator removeBehavior:self.gravityBehaviour];
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc]initWithItem:self.lockScreenView attachedToAnchor:location];
        [self.animator addBehavior:_attachmentBehaviour];
        
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        
        self.attachmentBehaviour.anchorPoint = location;
        NSLog(@"location:%@",NSStringFromCGPoint(location));
        NSLog(@"length:%f",self.attachmentBehaviour.length);
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        
        CGPoint velocity = [panGes velocityInView:_lockScreenView];
        NSLog(@"v:%@",NSStringFromCGPoint(velocity));
        
        [self.animator removeBehavior:_attachmentBehaviour];
        _attachmentBehaviour = nil;
        
        if (velocity.y < -1300.0f) {
            [self.animator removeBehavior:_gravityBehaviour];
            [self.animator removeBehavior:_itemBehaviour];
            _gravityBehaviour = nil;
            _itemBehaviour = nil;

            //gravity
            self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.lockScreenView]];
            self.gravityBehaviour.gravityDirection = CGVectorMake(0.0, -1.0);
            self.gravityBehaviour.magnitude = 2.6f;
            [self.animator addBehavior:self.gravityBehaviour];
            
            //item
            self.itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lockScreenView]];
            self.itemBehaviour.elasticity = 0.0f;//1.0 完全弹性碰撞，需要非常久才能恢复；
            [self.animator addBehavior:_itemBehaviour];
            
            self.pushBehavior.pushDirection = CGVectorMake(0.0f, -200.0f);
            self.pushBehavior.active = YES;
        }else{
            
            [self restore:nil];
            
        }
    }
    
}

- (IBAction)restore:(id)sender {
    [_animator removeBehavior:_gravityBehaviour];
    [_animator removeBehavior:_itemBehaviour];
    _gravityBehaviour = nil;
    _itemBehaviour = nil;
    
    //gravity
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.gravityBehaviour.gravityDirection = CGVectorMake(0.0, 1.0);
    self.gravityBehaviour.magnitude = 2.6f;
    
    //item
    self.itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lockScreenView]];
    self.itemBehaviour.elasticity = 0.35f;//1.0 完全弹性碰撞，需要非常久才能恢复；
    [self.animator addBehavior:_itemBehaviour];
    
    [self.animator addBehavior:self.gravityBehaviour];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
