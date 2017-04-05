//
//  LOtherSignViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/26.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LOtherSignViewController.h"
#import "MBProgressHUD.h"
#import "iToast.h"
#import "publicResource.h"
#import "UserInfoSaveModel.h"
#import "LSendGoodsViewController.h"
#import "LOrderDetailViewController.h"

@interface LOtherSignViewController ()
 
@property (nonatomic, strong) UITextField *nameTxtField;
@end

@implementation LOtherSignViewController
@synthesize delegate;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;

    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
   
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"他人签收"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];

    if (!_nameTxtField) {
        _nameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,50)];
        _nameTxtField.borderStyle = UITextBorderStyleNone;
        _nameTxtField.placeholder = @"     输入代签收人姓名";
        _nameTxtField.backgroundColor = [UIColor clearColor];
        _nameTxtField.textColor = [UIColor blackColor];
        _nameTxtField.font = MiddleFont;
        _nameTxtField.returnKeyType = UIReturnKeyDone;
        _nameTxtField.backgroundColor = WhiteBgColor;
        [self.view addSubview:_nameTxtField];
    }
    
    //生成顶部右侧按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 50, 25)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = MiddleFont;
    [rightBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
}

- (void)buttonClick{

    if (_nameTxtField.text.length == 0) {
        [[iToast makeText:@"请输入签收人姓名！"] show];
        return;
    }
    
    if (_nameTxtField.text.length >5) {
        [[iToast makeText:@"长度不能超过五"] show];
        return;
    }
    
    if ([_nameTxtField.text isEqualToString:@" "]) {
        [[iToast makeText:@"不能输入空格"] show];
        return;
    }
    else if ([_nameTxtField.text isEqualToString:@"  "]) {
         [[iToast makeText:@"不能输入空格"] show];
        return;
    }
    else if ([_nameTxtField.text isEqualToString:@"   "]) {
        [[iToast makeText:@"不能输入空格"] show];
        return;
    }
    else if ([_nameTxtField.text isEqualToString:@"    "]) {
        [[iToast makeText:@"不能输入空格"] show];
        return;
    }
    else if ([_nameTxtField.text isEqualToString:@"     "]) {
        [[iToast makeText:@"不能输入空格"] show];
        return;
    }
    //如果相应代理
    if([self.delegate respondsToSelector:@selector(LOtherSignWithName:)])
    
    [self.delegate LOtherSignWithName:_nameTxtField.text];
 
    
    [self.navigationController popViewControllerAnimated:YES];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];

    self.tabBarController.tabBar.hidden = NO;
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
