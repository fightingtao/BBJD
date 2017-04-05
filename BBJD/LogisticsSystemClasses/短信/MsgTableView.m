//
//  MsgTableView.m
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "MsgTableView.h"
#import "MsgModelViewCell.h"
#import "oneMessageVC.h"
#import "MessageVController.h"
static NSString *CELLID = @"reuseIdentifier";
@interface MsgTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MsgTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.subject = [RACSubject subject];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomBtn];

}

#pragma mark---------tableViewDelegate----------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.showLabel;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count>0) {
        DLog(@"输出数组的时间%@",self.dataList);
        MsgModelViewCell *cell = [[MsgModelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
        [cell cellAutoLayoutHeight:self.dataList[indexPath.section][@"content"]];
        return cell.cellHeight;
    }
    return 0.01;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgModelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell  = [[MsgModelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    [cell cellAutoLayoutHeight:self.dataList[indexPath.section][@"content"]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"选择到了模板%@",self.dataList[indexPath.section]);
    [self.subject   sendNext:self.dataList[indexPath.section]];
/*
    oneMessageVC * oneVC;
    MessageVController *msgVC;
    int smstemplateId=[self.dataList[indexPath.section][@"smstemplateId"] intValue];
    for (UIViewController *viewContr in [self currentViewController].navigationController.viewControllers ){
        if ([viewContr isKindOfClass:[oneMessageVC class]]) {
            oneVC=(oneMessageVC *)viewContr;
        }
        else if ([viewContr isKindOfClass:[MessageVController class]]){
            msgVC=(MessageVController *)viewContr;
        }
    }

    oneVC.smstemplateId=[NSString stringWithFormat:@"%d",smstemplateId];
    msgVC.smstemplateId=[NSString stringWithFormat:@"%d",smstemplateId];
*/
    [[self currentViewController].navigationController popViewControllerAnimated:YES];
}


#pragma mark -----懒加载-----
- (UITableView *)tableView
{
    return HT_LAZY(_tableView, ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20) style:UITableViewStylePlain];
        tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
        tableView;
    }));
}

-(UILabel*)showLabel{
    return HT_LAZY(_showLabel, ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        label.text = @"说明：已通过审核的模板可能会根据当前政策变化被禁用";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
        label;
    }));
}

-(UIButton*)bottomBtn{
    return HT_LAZY(_bottomBtn, ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-44-64, SCREEN_WIDTH,44)];
        [btn setTitle:@"新增模板" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.backgroundColor = MAINCOLOR;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    
            [self.model.btnCommoand execute:[self currentViewController]];///按钮绑定方法  并将当前控制器传入到viewModel方法中
        }];
        btn;
    }));
}

//获取当前控制器
-(UIViewController *)currentViewController{
    UIViewController *vc;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[objc_getClass("UIViewController") class]] ) {
            vc = (UIViewController*)nextResponder;
            return vc;
        }
    }
    return vc;
}

-(NSMutableArray*)dataList{
    return HT_LAZY(_dataList, ({
        NSMutableArray *array = [NSMutableArray array];
        array;
    }));
}

-(MsgViewModel*)model{
    if (!_model) {
        _model = [[MsgViewModel alloc] init];
    }
    return _model;
}

@end
