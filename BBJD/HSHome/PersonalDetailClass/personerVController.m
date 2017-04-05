//
//  personerVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/16.
//  Copyright © 2016年 xc. All rights reserved.

#import "personerVController.h"
#import "personerTViewCell.h"
#import "FeedBackViewController.h"//意见反馈
#import "SettingViewController.h"//设置
#import "PersonalInfoViewController.h"//个人信息
#import "historyVController.h"//历史订单
#import "moneyVController.h"//我的钱包
#import "ApplyBrokerViewController.h"//认证邦办达人
#import "LoginViewController.h"
#import "UMSocial.h"//分享
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "MainTrainningViewController.h"//培训学习
#import "roleVController.h"//规则说明
#import "shopVController.h"//邦办商城
#import "certifyViewController.h"//信用金认证

@interface personerVController ()<UITableViewDelegate,UITableViewDataSource,personerCellDelegate>
{
    UserInfoSaveModel * _userInfoModel;
    NSString *_authen_status;//记录邦办达人认证状态
    NSString *_status;//记录经纪人账户状态
    NSString *_is_payed;//记录是否信用金认证
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) OutPersonerBody *outModel;
@end

@implementation personerVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
    [self getPersonermsg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self initpersonTableView]];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MAINCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"我的"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"shezhi.png" target:self action:@selector(settingButtonClick)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infor:) name:@"tuiSong" object:nil];
}

#pragma mark tableView delegate
//初始化下单tableView
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-49;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_tableView registerNib:[UINib nibWithNibName:@"personerTViewCell" bundle:nil] forCellReuseIdentifier:@"personer"];
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 532-10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    personerTViewCell *cell=[personerTViewCell personerTableViewCellWith:tableView indexPath:indexPath msg:_outModel];
    cell.delegate = self;
    //    邦办达人认证状态 0申请中 1审核通过 2审核失败
    cell.brokerInforLabel.font = [UIFont systemFontOfSize:14];
    cell.brokerInforLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    if ([_authen_status isEqualToString:@"0"] ) {
        cell.brokerInforLabel.text = @"(申请中)";
    }else if ([_authen_status isEqualToString:@"1"]){
        if ([_userInfoModel.status isEqualToString:@"2"]) {
            cell.brokerInforLabel.text = @"(已冻结)";
        }else if ([_userInfoModel.status isEqualToString:@"3"]){
            cell.brokerInforLabel.text = @"(已注销)";
        }else{
            cell.brokerInforLabel.text = @"(已认证)";
        }
    }else if ([_authen_status isEqualToString:@"2"]){
        cell.brokerInforLabel.text = @"(审核失败)";
        
    }else {
        cell.brokerInforLabel.text = @"(未认证)";
    }
    
    if ([_is_payed isEqualToString:@"0"] || [_is_payed isEqualToString:@"2"]) {
        cell.payInforLabel.text = @"(未认证)";
    }else if ([_is_payed isEqualToString:@"1"] || [_is_payed isEqualToString:@"3"]){
        cell.payInforLabel.text = @"(已认证)";
    }else{
        cell.payInforLabel.text = @"";
    }
    return cell;
}

#pragma mark 头像点击   登录状态
-(void)headerClickGoLogin
{
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!userInfoModel.key||userInfoModel.key.length == 0 ||[userInfoModel.key isEqualToString:@""]|| _outModel.mobile.length == 0 || [_outModel.mobile isEqualToString:@""])
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:login animated:YES];
    }else{
        PersonalInfoViewController *personer = [[PersonalInfoViewController alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:personer animated:YES];
    }
}

#pragma mark 获取个人信息
-(void)getPersonermsg{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (_userInfoModel.key.length == 0 || [_userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:_userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getPersonerMsgWithkey:_userInfoModel.key degist:hmac resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *data = [dic objectForKey:@"data"];
                
                _outModel = [[OutPersonerBody alloc]initWithDictionary:data error:nil];
                _authen_status = _outModel.authen_status;
            
                _is_payed = _outModel.is_payed;
                
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    [_tableView reloadData];
                    
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"]duration:1 offSetY:0];
                    if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){
                        LoginViewController *login = [[LoginViewController alloc] init];
                        self.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:login animated:YES];
                    }
                }
                
            } );
            
        }];
    });
}

#pragma mark  信用金认证
-(void)goFeedbackVC
{
    if ([_is_payed isEqualToString:@"0"] || [_is_payed isEqualToString:@"2"]) {
        
        if ([_authen_status isEqualToString:@"-1"] ||[_authen_status isEqualToString:@"2"] ) {
            [[KNToast shareToast] initWithText:@"您还未认证达人，快去达人认证吧！" duration:1.5 offSetY:0];
            return;
        }
        
        if ([_userInfoModel.status isEqualToString:@"2"]  ){
            [[KNToast shareToast] initWithText:@"您的账号已冻结，暂不能认证信用金！" duration:1.5 offSetY:0];
            return;
        }
        
        if ([_userInfoModel.status isEqualToString:@"3"]) {
            [[KNToast shareToast] initWithText:@"您的账号已注销，暂不能认证信用金！" duration:1.5 offSetY:0];
            return;
        }
        
        certifyViewController *VC = [[certifyViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([_is_payed isEqualToString:@"1"] || [_is_payed isEqualToString:@"3"]){
        [[KNToast shareToast] initWithText:@"您的信用金已经认证,不能重复认证！" duration:1.5 offSetY:0];
    }
    
}

#pragma mark 去设置
-(void)settingButtonClick{
    SettingViewController*login = [[SettingViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    login.telphone=_outModel.company_contact;
    [self.navigationController pushViewController:login animated:YES];
}
 -(void)goSetViewController;
 {
//    SettingViewController*login = [[SettingViewController alloc] init];
//    self.hidesBottomBarWhenPushed=YES;
//    login.telphone=_outModel.company_contact;
//    [self.navigationController pushViewController:login animated:YES];
 }

#pragma mark 我的钱包
-(void)goMoneyViewController;
{
    moneyVController *login = [[moneyVController alloc] init];
    login.deposit = [_outModel.withdraw_profit floatValue];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark  历史订单
-(void)goHistoryOrder;
{
    historyVController *login = [[historyVController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark   分享好友
-(void)goShareFriend
{
    [UMSocialData defaultData].extConfig.title = @"邦办达人";
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@ "57a7e979e0f55a4799001320"                                           shareText:@"邀您与我一起做邦办达人"shareImage:[UIImage imageNamed:@"icon"]shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline]delegate:nil];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx6faa47b796342795" appSecret:@"03d191316532d13dc22a127f09a7bb16" url:@"https://itunes.apple.com/cn/app/%E9%82%A6%E5%8A%9E%E5%8D%B3%E8%BE%BE/id1150393685?mt=8"];
}

#pragma mark  培训学习
-(void)goLearneViewc
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:nil];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    MainTrainningViewController *VC = [[MainTrainningViewController alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
}

#pragma mark  达人认证
-(void)goRenZhengStatus
{//邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败  authen_status
    if ([_authen_status isEqualToString:@"-1"]) {
        ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
        [self.navigationController pushViewController:broker animated:YES];
    }else if ([_authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"审核正在申请中,请耐心等待!" duration:1.5 offSetY:0];
    }else if ([_authen_status isEqualToString:@"1"]){
        if ([_userInfoModel.status isEqualToString:@"2"]) {
            [[KNToast shareToast] initWithText:@"您的账户已冻结,如有疑问,请联系客服!" duration:1.5 offSetY:0];

        }else if ([_userInfoModel.status isEqualToString:@"3"]){
            [[KNToast shareToast] initWithText:@"您的账户已注销,如有疑问,请联系客服!" duration:1.5 offSetY:0];

         }else{
             [[KNToast shareToast] initWithText:@"已认证,您可以去赚钱了!" duration:1.5 offSetY:0];
        }
    }else if ([_authen_status isEqualToString:@"2"]){
        [[KNToast shareToast] initWithText:@"认证失败,请重新认证!" duration:1.5 offSetY:0];
        ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
        [self.navigationController pushViewController:broker animated:YES];
    }else{
        ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
        [self.navigationController pushViewController:broker animated:YES];
    }
}

#pragma mark  邦办商城
-(void)goYaJinviewController
{
    shopVController  *role= [[shopVController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:role animated:NO];
}

#pragma mark  规则说明
-(void)goRullViewContr
{
    roleVController  *role= [[roleVController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:role animated:NO];
}

#pragma mark  服务热线
-(void)goPhoneClick
{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:_outModel.company_contact message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 设置popover指向的item
        alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",_outModel.company_contact];
            if ([phoneStr hasPrefix:@"sms:"] || [phoneStr hasPrefix:@"tel:"]) {
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:phoneStr]]) {
                    [app openURL:[NSURL URLWithString:phoneStr]];
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
 
}

#pragma mark --------------通知--------------
-(void)infor:(NSNotification*)infor{
    
    [self getPersonermsg];//收到通知重新获取数据
    [self.tableView reloadData];//刷新表格
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
