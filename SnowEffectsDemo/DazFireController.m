//
//  DazFireController.m
//  Dazzle
//
//  Created by Leonhard Lichtschlag on 9/Feb/12.
//  Copyright (c) 2012 Leonhard Lichtschlag. All rights reserved.
//

#import "DazFireController.h"
#import <QuartzCore/CoreAnimation.h>

// ===============================================================================================================
@implementation DazFireController
// ===============================================================================================================

@synthesize fireEmitter;
@synthesize smokeEmitter;


// ---------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle
// ---------------------------------------------------------------------------------------------------------------

- (void) viewDidLoad
{
    [super viewDidLoad];
	
	CGRect viewBounds = self.view.layer.bounds;
	
	// Create the emitter layers
	self.fireEmitter	= [CAEmitterLayer layer];
	self.smokeEmitter	= [CAEmitterLayer layer];
	
	// Place layers just above the tab bar
	self.fireEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height - 60);
	self.fireEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0);
	self.fireEmitter.emitterMode	= kCAEmitterLayerOutline;
	self.fireEmitter.emitterShape	= kCAEmitterLayerLine;
	// with additive rendering the dense cell distribution will create "hot" areas
	self.fireEmitter.renderMode		= kCAEmitterLayerAdditive;
	
	self.smokeEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height - 60);
	self.smokeEmitter.emitterMode	= kCAEmitterLayerPoints;
	
	// Create the fire emitter cell
	CAEmitterCell* fire = [CAEmitterCell emitterCell];
	[fire setName:@"fire"];

	fire.birthRate			= 100;
	fire.emissionLongitude  = M_PI;
	fire.velocity			= -80;
	fire.velocityRange		= 30;
	fire.emissionRange		= 1.1;
	fire.yAcceleration		= -200;
	fire.scaleSpeed			= 0.3;
	fire.lifetime			= 50;
	fire.lifetimeRange		= (50.0 * 0.35);

	fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
	fire.contents = (id) [[UIImage imageNamed:@"DazFire"] CGImage];
	
	
	// Create the smoke emitter cell
	CAEmitterCell* smoke = [CAEmitterCell emitterCell];
	[smoke setName:@"smoke"];

	smoke.birthRate			= 11;
	smoke.emissionLongitude = -M_PI / 2;
	smoke.lifetime			= 10;
	smoke.velocity			= -40;
	smoke.velocityRange		= 20;
	smoke.emissionRange		= M_PI / 4;
	smoke.spin				= 1;
	smoke.spinRange			= 6;
	smoke.yAcceleration		= -160;
	smoke.contents			= (id) [[UIImage imageNamed:@"DazSmoke"] CGImage];
	smoke.scale				= 0.1;
	smoke.alphaSpeed		= -0.12;
	smoke.scaleSpeed		= 0.7;
	
	
	// Add the smoke emitter cell to the smoke emitter layer
	self.smokeEmitter.emitterCells	= [NSArray arrayWithObject:smoke];
	self.fireEmitter.emitterCells	= [NSArray arrayWithObject:fire];
	[self.view.layer addSublayer:self.smokeEmitter];
	[self.view.layer addSublayer:self.fireEmitter];
	
	[self setFireAmount:0.9];
}


- (void) viewWillUnload
{
	[super viewWillUnload];
	[self.fireEmitter removeFromSuperlayer];
	self.fireEmitter = nil;
	[self.smokeEmitter removeFromSuperlayer];
	self.smokeEmitter = nil;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIDeviceOrientationPortrait);
}


// ---------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Interaction
// ---------------------------------------------------------------------------------------------------------------

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self controlFireHeight:event];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self controlFireHeight:event];
}


- (void) controlFireHeight:(UIEvent *)event
{
	UITouch *touch			= [[event allTouches] anyObject];
	CGPoint touchPoint		= [touch locationInView:self.view];
	float distanceToBottom	= self.view.bounds.size.height - touchPoint.y;
	float percentage		= distanceToBottom / self.view.bounds.size.height;
	percentage				= MAX(MIN(percentage, 1.0), 0.1);
	[self setFireAmount:2 *percentage];
}


- (void) setFireAmount:(float)zeroToOne
{
	// Update the fire properties
	[self.fireEmitter setValue:[NSNumber numberWithInt:(zeroToOne * 500)]
					forKeyPath:@"emitterCells.fire.birthRate"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:zeroToOne]
					forKeyPath:@"emitterCells.fire.lifetime"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:(zeroToOne * 0.35)]
					forKeyPath:@"emitterCells.fire.lifetimeRange"];
	self.fireEmitter.emitterSize = CGSizeMake(50 * zeroToOne, 0);
	
	[self.smokeEmitter setValue:[NSNumber numberWithInt:zeroToOne * 4]
					 forKeyPath:@"emitterCells.smoke.lifetime"];
	[self.smokeEmitter setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:zeroToOne * 0.3] CGColor]
					 forKeyPath:@"emitterCells.smoke.color"];
}


@end


