//
//  WorkVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/17.
//  Copyright © 2016年 xc. All rights reserved.
//
#import "summaryTViewCell.h"
#import "WorkVController.h"
#import "publicResource.h"
#import "pickAndSend.h"

#import "LSendGoodsViewController.h"
#import "ApplyBrokerViewController.h"
#import "LoginViewController.h"
#import "getPhoneVController.h"//发送短信之前获取手机号
#import "msgHomeViewController.h"//发送短信首页

@interface WorkVController ()<pickAndSendDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,GotoSendGoodsDelegate>
{
    NSString *_title;
    UIAlertView *alertOne;
    UIAlertView *alertTwo;
}

@property (nonatomic,strong)UITableView *workTableView;
@property (nonatomic,strong) pickAndSend *pickAndSend;
@property(nonatomic,strong)Out_myHomeWorkBody *myHomeWorkBody;

@end

@implementation WorkVController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=NO;
    [self getOrderMsg];


}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MAINCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    [self.view addSubview:[self initpersonTableView]];
    
    self.navigationItem.title = @"工作";
    
    if (!_pickAndSend) {
        _pickAndSend=[[pickAndSend alloc]init];
        _pickAndSend.delegate=self;
        _pickAndSend.frame=CGRectMake(0, 0, SCREEN_WIDTH, 150);
    }
 }

//初始化下单tableView
-(UITableView *)initpersonTableView
{
    if (self.workTableView != nil) {
        return self.workTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64;
    
    self.workTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.workTableView.delegate = self;
    self.workTableView.dataSource = self;
    self.workTableView.backgroundColor = [UIColor whiteColor];
    self.workTableView.showsVerticalScrollIndicator = NO;
    self.workTableView.scrollEnabled = NO;
    _pickAndSend = [[pickAndSend alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 150)];
    _pickAndSend.delegate = self;//遵循代理
    self.workTableView.tableFooterView = _pickAndSend;
    return self.workTableView;
}

#pragma tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return _pickAndSend;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return SCREEN_WIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    summaryTViewCell *cell=[summaryTViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_myHomeWorkBody];
    cell.delegate = self;
    return cell;
}

#pragma mark 分拣
-(void)pickupGoodsClick;
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
//用户状态0启用（认证通过但未分配到商家） 1工作中（认证通过并分配到站）2冻结（惩罚中）3注销（加入黑名单）
 // authen_status  邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
    
    if ([userInfoModel.authen_status isEqualToString:@"-1"]){
        [[KNToast shareToast] initWithText:@"请先进行达人认证!" duration:1 offSetY:0];
    }
    else  if ([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"您的认证信息正在审核,请耐心等待!" duration:1 offSetY:0];
    }
    else  if ([userInfoModel.authen_status isEqualToString:@"2"]){
        [[KNToast shareToast] initWithText:@"您的认证信息认证失败,请重新认证!" duration:1 offSetY:0];
    }
    else  if ([userInfoModel.authen_status isEqualToString:@"1"])
    {
        if ([userInfoModel.status isEqualToString:@"2"]){
            [[KNToast shareToast] initWithText:@"账号被冻结,如有疑问请联系客服!" duration:1 offSetY:0];
            
            return;
        }
        else  if ([userInfoModel.status isEqualToString:@"3"]){
            [[KNToast shareToast] initWithText:@"您的账号已被注销,如有疑问请联系客服!" duration:1 offSetY:0];
            return;
        }
    
    getPhoneVController *getPhone=[[getPhoneVController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:getPhone animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark 送货
-(void)sendGoodsClick;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([userInfoModel.authen_status isEqualToString:@"-1"]) {
        [[KNToast shareToast]initWithText:@"请先认证邦办达人" duration:1.5 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"邦办达人信息正在审核中"duration:1.5 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"2"]){
        [[KNToast shareToast]initWithText:@"邦办达人信息认证失败" duration:1.5 offSetY:0];
        return;
    }else{
        if ([userInfoModel.status isEqualToString:@"2"]){
            [[KNToast shareToast]initWithText:@"账号被冻结,如有疑问请联系客服！" duration:1.5 offSetY:0];
            return;
        }else  if ([userInfoModel.status isEqualToString:@"3"]){
            [[KNToast shareToast]initWithText:@"您的账号已被注销,如有疑问请联系客服!" duration:1.5 offSetY:0];
            return;
        }
        
    LSendGoodsViewController*pickup=[[LSendGoodsViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pickup animated:YES];
       self.hidesBottomBarWhenPushed = NO;
    }
}

-(void)GotoSendGoods{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([userInfoModel.authen_status isEqualToString:@"-1"]) {
        [[KNToast shareToast] initWithText:@"请先认证邦办达人!" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"邦办达人信息正在审核中,请耐心等待!" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"2"]){
        [[KNToast shareToast] initWithText:@"邦办达人信息认证失败,请重新认证！" duration:1 offSetY:0];
        return;
        
    }else{
        if ([userInfoModel.status isEqualToString:@"2"]){
            [[KNToast shareToast] initWithText:@"账号被冻结,如有疑问请联系客服！" duration:1 offSetY:0];
            return;
        }
        else  if ([userInfoModel.status isEqualToString:@"3"]){
            [[KNToast shareToast] initWithText:@"您的账号已被注销,如有疑问请联系客服!" duration:1 offSetY:0];
            return;
        }
        LSendGoodsViewController*pickup=[[LSendGoodsViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pickup animated:YES];
    }
}

#pragma  mark  发送短信
-(void)sendMessageClick;{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([userInfoModel.authen_status isEqualToString:@"-1"]) {
        [[KNToast shareToast] initWithText:@"请先认证邦办达人!" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"邦办达人信息正在审核中,请耐心等待!" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"2"]){
        [[KNToast shareToast] initWithText:@"邦办达人信息认证失败,请重新认证！" duration:1 offSetY:0];
        return;
        
    }else{
        if ([userInfoModel.status isEqualToString:@"2"]){
            [[KNToast shareToast] initWithText:@"账号被冻结,如有疑问请联系客服！" duration:1 offSetY:0];
            return;
        }
        else  if ([userInfoModel.status isEqualToString:@"3"]){
            [[KNToast shareToast] initWithText:@"您的账号已被注销,如有疑问请联系客服!" duration:1 offSetY:0];
            return;
        }

    
    msgHomeViewController *msgHome = [msgHomeViewController new];
    [self.navigationController pushViewController:msgHome animated:YES];
    }
}

#pragma  mark  首页数据展示
-(void)getOrderMsg{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac = [[communcat sharedInstance ] hmac:@"" withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getHomeWorkInfoWithkey:userInfoModel.key degist:hmac resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic){
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code == 1000){
                NSDictionary *result = [dic objectForKey:@"data"];
                _myHomeWorkBody = [[Out_myHomeWorkBody alloc]initWithDictionary:result error:nil];
                _title =[NSString stringWithFormat:@"已抢%d单",[_myHomeWorkBody.today_work_amount intValue]] ;
                self.navigationItem.title = _title;
                [_workTableView reloadData];
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                NSDictionary *result = [dic objectForKey:@"data"];
                _myHomeWorkBody = [[Out_myHomeWorkBody alloc]initWithDictionary:result error:nil];
                _title =[NSString stringWithFormat:@"已抢%d单",[_myHomeWorkBody.today_work_amount intValue]] ;
                self.navigationItem.title = _title;
                [_workTableView reloadData];
                if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){
                    LoginViewController *login = [[LoginViewController alloc] init];
                    self.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:login animated:YES];
                }
                
            }
        }];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertOne) {
        if (buttonIndex==1) {
            self.tabBarController.selectedIndex = 0;
        }
        
    }else if(alertView == alertTwo){
        if (buttonIndex==1) {
            ApplyBrokerViewController *vc = [[ApplyBrokerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 获取未读短信数量
-(void)getNoReadMsgNumble{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] noReadMsgWithKey:userInfoModel.key digest:hmac  resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DLog(@"未读短信%@",dic);
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic){
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code == 1000){
                NSDictionary *result = [dic objectForKey:@"data"];
            //    _myHomeWorkBody = [[Out_myHomeWorkBody alloc]initWithDictionary:result error:nil];
                NSString *noRead=result[@"count"];
                [[NSUserDefaults standardUserDefaults]setObject:noRead forKey:kNoRead];
                
                
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){

                    self.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:login animated:YES];
                }
            }
        }];
    });
}

@end
