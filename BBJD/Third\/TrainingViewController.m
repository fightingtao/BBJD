//
//  TrainingViewController.m
//  BBJD
//
//  Created by 李志明 on 16/8/30.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "TrainingViewController.h"
#import "publicResource.h"
@interface TrainingViewController()
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation TrainingViewController

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    for (NSInteger i = 1; i <= 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i-1)*SCREEN_WIDTH,0 , SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"stu_%ld.jpg",i]];
        [self.scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        if (i == 1) {
            UIButton *button = [[UIButton alloc]initWithFrame:self.view.frame];
            [imageView addSubview:button];
            button.tag = 100;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if(i == 2){
            UIButton *button = [[UIButton alloc]initWithFrame:self.view.frame];
            [imageView addSubview:button];
            button.tag = 101;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 3){
            UIButton *button = [[UIButton alloc]initWithFrame:self.view.frame];
            [imageView addSubview:button];
            button.tag = 102;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{

            UIButton *button = [[UIButton alloc]initWithFrame:self.view.frame];
            [imageView addSubview:button];
            button.tag = 105;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*6, 0);
    self.scrollView.pagingEnabled = YES;
}

-(void)btnClick:(UIButton*)btn{
    if (btn.tag == 100) {
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }else if (btn.tag == 101){
        self.scrollView.contentOffset = CGPointMake(2*SCREEN_WIDTH, 0);
    }else if (btn.tag == 102){
         self.scrollView.contentOffset = CGPointMake(3*SCREEN_WIDTH, 0);
    }else if (btn.tag == 103){
        self.scrollView.contentOffset = CGPointMake(4*SCREEN_WIDTH, 0);
    }else if (btn.tag == 104){
         self.scrollView.contentOffset = CGPointMake(5*SCREEN_WIDTH, 0);
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}





@end
