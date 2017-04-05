//
//  SettingViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/27.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "SettingViewController.h"
#import "ourVController.h"
#import "JPUSHService.h"

#import "PersonOtherInfoTableViewCell.h"
#import "LoginViewController.h"//登录
#import "FeedBackViewController.h"//意见反馈
#import "coreDataManger.h"//
@interface SettingViewController ()<UIGestureRecognizerDelegate>
{
    NSString *_onOff;//记录开关状态
}
@property (nonatomic, strong) UIView *bgView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) UIButton *pushSwitch;
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.navigationController.navigationBar.hidden=NO;
//    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.title = @"设置";
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
    [self initpersonTableView];
    [self.view addSubview:_setTableView];
    
    if (!_bgView){
        
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor=ViewBgColor;
        _bgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
    
    }
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(30,40, SCREEN_WIDTH-60, 44);
        _logoutBtn.backgroundColor = MAINCOLOR;
        [_logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        _logoutBtn.clipsToBounds = YES;
        _logoutBtn.layer.cornerRadius = 10;
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bgView addSubview:_logoutBtn];
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

//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_setTableView != nil) {
        return _setTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-50;
    
    self.setTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    _setTableView.backgroundColor = ViewBgColor;
    _setTableView.showsVerticalScrollIndicator = NO;
    _setTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    return _setTableView;
}


#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _bgView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"PersonOtherInfoTableViewCell";
    PersonOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[PersonOtherInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.titleLable.font = kTextFont16;

    cell.titleLable.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.titleLable.text = @"抢单通知";
       
        cell.contentLable.hidden = YES;
        cell.arrowImg.hidden = YES;
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];

        if (!_pushSwitch)
        {
            _pushSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
            _pushSwitch.frame=CGRectMake(SCREEN_WIDTH-90, 10, 73, 30);
            [_pushSwitch setBackgroundImage:[UIImage imageNamed:@"bn_on.png"] forState:UIControlStateSelected];
            [_pushSwitch setBackgroundImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
            [_pushSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
           
            [cell.contentView addSubview:_pushSwitch];
            if ([userInfoModel.notify_switch containsString:@"on"]) {
                
                _pushSwitch.selected = NO;

            }
            else{
                _pushSwitch.selected = YES;

            }
            
            [self switchAction:_pushSwitch];
            
        }
        }else if (indexPath.row == 1)
    {
        cell.titleLable.text = @"关于我们";
        cell.contentLable.hidden = YES;
        cell.arrowImg.hidden=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 2){
        cell.contentLable.hidden = YES;
        cell.titleLable.text = @"意见反馈";
        cell.arrowImg.hidden=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.titleLable.text = @"当前版本号";
        cell.contentLable.text =[NSString stringWithFormat:@"V %@",kVersion];
         cell.arrowImg.hidden=YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1)
    {
        ourVController * our = [[ourVController alloc] init];
        our.telphone=self.telphone;
        [self.navigationController pushViewController: our animated:YES];
    }else if (indexPath.row == 2){
        FeedBackViewController *VC = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


//用户是否接收推送
-(void)switchAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ( sender.isSelected == YES) {
        _onOff = @"on";
        [self  isGetJpush];
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSSet *set = [[NSSet alloc] initWithObjects:userInfoModel.tag, nil];
        [JPUSHService setTags:set alias:userInfoModel.key callbackSelector:nil object:nil];
        
    }else{
        _onOff = @"off";
        [self  isGetJpush];
        NSSet *set = [[NSSet alloc] initWithObjects:@"", nil];
        [JPUSHService setTags:set alias:@"" callbackSelector:nil object:nil];
    }
}

#pragma mark 接收通知开关

-(void)isGetJpush{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
  
    
    UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:_onOff withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] getDetialListInfoWithkey:userInfoModel.key degist:hmac onOff:_onOff resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];                
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    [[[LoginViewController alloc]init] upDataUserMag];
               
                }else{
                   
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
                
            } );
            
        }];
        
    });
}

///退出账号
- (void)logoutClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出账号" message:@"退出账号后将不能接收到任何通知" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 ) {

    }else{
        //清除用户信息
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        UserInfoSaveModel *userInfoModel = [[UserInfoSaveModel alloc] init];
        NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
        [userDefault setObject:setData forKey:UserKey];

        //退出推送
        NSSet *set = [[NSSet alloc] initWithObjects:@"", nil];
        [JPUSHService setTags:set alias:@"" callbackSelector:nil object:nil];
        

        [self loginOutMathCLick];

        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChengGong"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self leftItemClick];
        LoginViewController  *login=[[LoginViewController   alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }
}

#pragma mark 退出登录
-(void)loginOutMathCLick{
    NSData *msg=[[NSUserDefaults standardUserDefaults] objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:msg];
    if (userInfoModel.key.length==0) {
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] loginOutClickWithKey:userInfoModel.key digest:hmacString resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (dic){
                    
                    int   code =[[dic objectForKey:@"code"] intValue];
                    if (code==1000) {
                        
                        [[iToast makeText:@"退出登录成功"] show];

                    }
                    
                }
                else{
                    
                    [[iToast makeText:@"网络不给力!请检查数据连接..."] show];
                }
                
            });
            
        }];
        
    });
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
