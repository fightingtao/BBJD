//
//  MsgModelController.m
//  BBJD
//
//  Created by 李志明 on 17/2/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "MsgModelController.h"
#import "MsgTableView.h"
#import "noConnetView.h"//暂无模板
#import "publicResource.h"
@interface MsgModelController ()
@property(nonatomic,strong)MsgTableView *msgView;
@property (nonatomic,strong)noConnetView *noMsgView;


@end

@implementation MsgModelController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"选择模板"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(popLeftBtnClick)];
  
    [self bindViewModel];
    [self CreacteViewNoMsg];
}

-(void)bindViewModel{
    
    self.msgView = [[MsgTableView alloc] initWithFrame:self.view.frame];
   
    [self.msgView.subject subscribeNext:^(id x) {
        [self.selectSubject sendNext:x];
    }];
    
    [self.view addSubview:self.msgView];
//    绑定数据
    RAC(self.msgView,dataList)  = RACObserve(self.viewModel, dataList);
  
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    NSArray *viewAry=@[self.msgView,self.noMsgView];
    //执行命令
    [self.viewModel.loadCommand execute:viewAry];//把TableView传入viewModel

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


-(void)popLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(MsgViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[MsgViewModel alloc] init];
    }
    return _viewModel;
}

-(void)CreacteViewNoMsg{
    self.noMsgView= [[noConnetView alloc]initWithName:@"error"];
    self.noMsgView.frame=CGRectMake(0, SCREEN_HEIGHT/6, SCREEN_WIDTH,SCREEN_HEIGHT-150);
    self.noMsgView.label.text=@"暂无模板";
    self.noMsgView.hidden=YES;
    [self.view addSubview:self.noMsgView];

}
 
@end
