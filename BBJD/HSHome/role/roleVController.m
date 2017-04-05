//
//  roleVController.m
//  BBJD
//
//  Created by cbwl on 16/8/31.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "roleVController.h"
#import "publicResource.h"

@interface roleVController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *img;
 
@end

@implementation roleVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
   
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"规则说明"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(0, 900);
        [self.view addSubview:self.scrollView];
        
    }
    if (!self.img   ) {
        _img=[[UIImageView alloc]init];
        _img.frame=CGRectMake(0, 0,SCREEN_WIDTH , 850);
        _img.image=[UIImage imageNamed:@"二期达人规则说明.png"];
        [self.scrollView addSubview:_img];
    }
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
    [self leftItemClick];
}

-(void)leftItemClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
