//
//  approveComplVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "approveComplVController.h"
#import "publicResource.h"
@interface approveComplVController ()
 
@end

@implementation approveComplVController
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
    
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
  
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"达人认证"];

}

- (IBAction)commpeletClick:(id)sender {
    

    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)goAlipay:(id)sender {
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
