//
//  MainTrainningViewController.m
//  BBJD
//
//  Created by 李志明 on 16/9/12.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "MainTrainningViewController.h"
#import "publicResource.h"
#import "TrainingViewController.h"
#import "standardVController.h"
@interface MainTrainningViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView *homeTableView;
@end

@implementation MainTrainningViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
//    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"培训学习";
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self initWithHomeTableView];
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

-(void)initWithHomeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        [self.view addSubview:_homeTableView];
        _homeTableView.rowHeight = 50;
    }
}

#pragma mark ------------tableViewDataSource----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font=MiddleFont;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"接单学习";
    }else{
        cell.textLabel.text = @"配送服务标准流程";
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark ---tableViewDelegate---------
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TrainingViewController *VC = [[TrainingViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        standardVController *standVC = [[standardVController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:standVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
