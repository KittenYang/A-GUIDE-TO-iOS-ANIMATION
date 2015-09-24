//
//  ViewController.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define IMAGE_SIZE  60
#define PADDING (SCREENWIDTH-IMAGE_SIZE*3)/4

#import "ViewController.h"
#import "KYPhotoGallery.h"
#import "Macro.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

//@property(nonatomic,strong)KYPhotoGallery *photoGallery;
@property(nonatomic,strong)NSMutableArray *bigImagesUrls;
@property(nonatomic,strong)NSMutableArray *thumbImagesUrls;
@property(nonatomic,strong)NSMutableArray *imageViewArray;  //保存所有UIImageView

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.thumbImagesUrls = [NSMutableArray arrayWithObjects:
                            @"http://ww2.sinaimg.cn/thumbnail/53932067gw1esjqfk3z6zj20hh09uabk.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/53932067gw1esphcqgpurj20gy09bq46.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/0061yvm6jw1estimj38bdj31cv4o87wh.jpg",
                            @"http://ww4.sinaimg.cn/thumbnail/53932067gw1eshmw8t1s9j20jt0bw77l.jpg",
                            @"http://ww4.sinaimg.cn/thumbnail/7f5cf1ffgw1esrte8exluj20zk0k0di1.jpg",
                            @"http://ww4.sinaimg.cn/thumbnail/7f5cf1ffgw1esrt4kpyjuj20zk0k0ac9.jpg",
                            nil];
    
    self.bigImagesUrls = [NSMutableArray arrayWithObjects:
                            @"http://ww2.sinaimg.cn/bmiddle/53932067gw1esjqfk3z6zj20hh09uabk.jpg",
                            @"http://ww3.sinaimg.cn/bmiddle/53932067gw1esphcqgpurj20gy09bq46.jpg",
                            @"http://ww3.sinaimg.cn/bmiddle/0061yvm6jw1estimj38bdj31cv4o87wh.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/53932067gw1eshmw8t1s9j20jt0bw77l.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/7f5cf1ffgw1esrte8exluj20zk0k0di1.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/7f5cf1ffgw1esrt4kpyjuj20zk0k0ac9.jpg",
                            nil];

    
    [self setTestImages];
}

-(void)setTestImages{
    
    self.imageViewArray = [NSMutableArray array];
    @autoreleasepool{
        for (int i = 0; i<6; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            if (i < 3) {
                img.frame = CGRectMake(PADDING + i*(IMAGE_SIZE+PADDING), self.view.center.y-IMAGE_SIZE-10, IMAGE_SIZE, IMAGE_SIZE);
            }else{
                img.frame = CGRectMake(PADDING + (i-3)*(IMAGE_SIZE+PADDING), self.view.center.y+IMAGE_SIZE+10, IMAGE_SIZE, IMAGE_SIZE);
            }
            
            img.clipsToBounds = YES;
            img.userInteractionEnabled = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.tag = i+1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTaped:)];
            [img addGestureRecognizer:tap];
            [self.view addSubview:img];
            
            [img sd_setImageWithURL:self.thumbImagesUrls[i] placeholderImage:nil options:SDWebImageLowPriority];
            
            [self.imageViewArray addObject:img];
        }
    }
}

#pragma mark -- Tapped
- (void)imgTaped:(UITapGestureRecognizer *)sender{
    

    KYPhotoGallery *photoGallery = [KYPhotoGallery sharedKYPhotoGallery];
    
    [photoGallery tappedImageView:(UIImageView *)sender.view andImageUrls:self.bigImagesUrls andInitialIndex:sender.view.tag];
    
    photoGallery.imageViewArray = self.imageViewArray;
    [photoGallery finishAsynDownload:^{
        
        [self presentViewController:photoGallery animated:NO completion:nil];

    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
