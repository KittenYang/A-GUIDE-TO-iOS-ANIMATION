//
//  ViewController.m
//  KYAnimatedPageControl-Demo
//
//  Created by Kitten Yang on 6/9/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "KYAnimatedPageControl.h"
#import "DemoCell.h"


@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)KYAnimatedPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *demoCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.pageControl = [[KYAnimatedPageControl alloc]initWithFrame:CGRectMake(20, 450, 280, 50)];
    self.pageControl.pageCount = 8;
    self.pageControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.pageControl.selectedColor = [UIColor redColor];
    self.pageControl.bindScrollView = self.demoCollectionView;
    self.pageControl.shouldShowProgressLine = YES;
    
    self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle;
    self.pageControl.indicatorSize = 20;
    self.pageControl.swipeEnable = YES;
    [self.view addSubview:self.pageControl];
    
    self.pageControl.didSelectIndexBlock = ^(NSInteger index){
        NSLog(@"Did Selected index : %ld",(long)index);
    };
    
}




#pragma mark  -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pageControl.pageCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DemoCell *democell = (DemoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"democell" forIndexPath:indexPath];
    democell.cellNumLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    
    return democell;
    
}



#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //Indicator动画
    [self.pageControl.indicator animateIndicatorWithScrollView:scrollView andIndicator:self.pageControl];

    if (scrollView.dragging || scrollView.isDecelerating || scrollView.tracking) {
        //背景线条动画
        [self.pageControl.pageControlLine animateSelectedLineWithScrollView:scrollView];
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    
    [self.pageControl.indicator restoreAnimation:@(1.0/self.pageControl.pageCount)];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)animateToForthPage:(id)sender
{
    [self.pageControl animateToIndex:3];
}

- (IBAction)swipeEnableChanged:(UISwitch *)sender
{
    self.pageControl.swipeEnable = sender.isOn;
}






@end
