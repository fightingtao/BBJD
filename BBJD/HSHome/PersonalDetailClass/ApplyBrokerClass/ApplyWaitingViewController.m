//
//  ApplyWaitingViewController.m
//  BBJD
//
//  Created by cbwl on 16/9/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "ApplyWaitingViewController.h"
#import "certifyViewController.h"
@interface ApplyWaitingViewController ()<UIGestureRecognizerDelegate>
@end

@implementation ApplyWaitingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"达人认证";
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self creactRightGesture];
}



#pragma mark 右滑返回上一级_________
///右滑返回上一级
-(void)creactRightGesture{
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
-(void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)pan{
    [self.navigationController popViewControllerAnimated:YES];
}




//返回按钮点击
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
