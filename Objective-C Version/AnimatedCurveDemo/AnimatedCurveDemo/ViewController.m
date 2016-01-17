//
//  ViewController.m
//  AnimatedCurveDemo
//
//  Created by Kitten Yang on 7/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Convenient.h"
#import "KYPullToCurveVeiw.h"
#import "KYPullToCurveVeiw_footer.h"


#define initialOffset 50.0
#define targetHeight 500.0

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController{
    UILabel *navTitle;
    UIView *bkView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    [self.tableView layoutIfNeeded];
    
    bkView = [[UIView alloc]init];
    bkView.center = CGPointMake(self.view.center.x, 22);
    bkView.bounds = CGRectMake(0, 0, 250, 44);
    bkView.clipsToBounds = YES;
    [self.navigationController.navigationBar addSubview:bkView];
    
    navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 44+initialOffset,bkView.frame.size.width, 44)];
    navTitle.alpha = 0;
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor blackColor];
    navTitle.text = @"Fade in/out navbar title";
    [bkView addSubview:navTitle];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat transitionY = MIN(MAX(0, scrollView.contentOffset.y+64), 44+initialOffset+targetHeight);
    NSLog(@"%f",transitionY);
    if (transitionY <= initialOffset) {
        navTitle.frame = CGRectMake(0, 44+initialOffset-transitionY,bkView.frame.size.width , 44);
    }else{
        
        CGFloat factor = MAX(0, MIN(1, (transitionY-initialOffset)/targetHeight));
        navTitle.frame = CGRectMake(0, 44-factor*44,bkView.frame.size.width , 44);
        navTitle.alpha = factor*factor*1;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    KYPullToCurveVeiw *headerView = [[KYPullToCurveVeiw alloc]initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak KYPullToCurveVeiw *weakHeaderView = headerView;

    [headerView triggerPulling];
    [headerView addRefreshingBlock:^{
        //具体的操作
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakHeaderView stopRefreshing];
        });
        
    }];
    
    KYPullToCurveVeiw_footer *footerView = [[KYPullToCurveVeiw_footer alloc]initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak KYPullToCurveVeiw_footer *weakFooterView= footerView;
    
    [footerView addRefreshingBlock:^{
        //具体的操作
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakFooterView stopRefreshing];
            
        });
    }];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *testCell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    testCell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row];
    return testCell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
