//
//  ViewController.m
//  CADemos
//
//  Created by Kitten Yang on 9/20/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "DownloadButton.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UIView *AnimateView;
@property (weak, nonatomic) IBOutlet DownloadButton *downloadButton;

@end

@implementation ViewController{
    BOOL animating;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadButton.progressBarWidth  = 200;
    self.downloadButton.progressBarHeight = 30;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
