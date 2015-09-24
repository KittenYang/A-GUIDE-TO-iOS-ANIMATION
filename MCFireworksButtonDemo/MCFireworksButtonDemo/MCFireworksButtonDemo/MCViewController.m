//
//  MCViewController.m
//  MCFireworksButtonDemo
//
//  Created by Matthew Cheok on 17/3/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import "MCViewController.h"
#import "MCFireworksButton.h"

@interface MCViewController ()

@property (weak, nonatomic) IBOutlet MCFireworksButton *likeButton;

@end

@implementation MCViewController {
	BOOL _selected;
}

- (IBAction)handleButtonPress:(id)sender {
	_selected = !_selected;
	if (_selected) {
		[self.likeButton popOutsideWithDuration:0.5];
		[self.likeButton setImage:[UIImage imageNamed:@"Like-Blue"] forState:UIControlStateNormal];
		[self.likeButton animate];
	}
	else {
		[self.likeButton popInsideWithDuration:0.4];
		[self.likeButton setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.likeButton.particleImage = [UIImage imageNamed:@"Sparkle"];
	self.likeButton.particleScale = 0.05;
    self.likeButton.particleScaleRange = 0.02;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
