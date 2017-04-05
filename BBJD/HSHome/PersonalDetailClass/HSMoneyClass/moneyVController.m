//
//  moneyVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "moneyVController.h"
#import "publicResource.h"
#import "depositVController.h"//申请提现
#import "billVController.h"//账单详情
#import "PunishViewController.h"//缴纳罚金
#import "billVController.h"

@interface moneyVController ()<UITableViewDelegate,UITableViewDataSource>
{
    double _deposit;//押金金额
    double _max_withdraw_amount;//最多可提现金额
    int uesr_type;//0达人
    int _type;//0配送收入提现 1信用金提现 (v2新增非必选 默认为0)
    double _prepayment;//信用金
    int  _withdraw_status;// -1未申请 0申请中 1审核通过 2审核失败 3转账成功 4转账失败
    NSString *_alipay_account;//支付宝账号
}
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *cashLabel;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation moneyVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    uesr_type = 0;
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
    [self initTableHeaderView];
    [self getMyWalletInfor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ self.view addSubview:[self initpersonTableView]];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    

    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"我的钱包"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(SCREEN_WIDTH-50, 0, 50, 30);
    [right setTintColor:[UIColor whiteColor]];
    [right setTitle:@"账单" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:16];
    [right addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infor:) name:@"tuiSong" object:nil];

}

#pragma mark tableView delegate
//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets = false;
    _tableView.showsVerticalScrollIndicator = NO;

    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
    static NSString *indetf = @"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetf];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetf];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = MiddleFont;
    cell.detailTextLabel.font = MiddleFont;
    if (indexPath.row == 0) {
        cell.textLabel.text=@"申请提现";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",_max_withdraw_amount];
        cell.detailTextLabel.textColor = [UIColor redColor];
        
    }else if (indexPath.row == 1){
        cell.textLabel.text=@"信用金提现";
        if (_deposit > 0) {
            if(_withdraw_status ==  -1 || _withdraw_status == 3  || _withdraw_status == 2){//未申请
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",_deposit];
            }else if(_withdraw_status == 0 || _withdraw_status == 1 || _withdraw_status == 4){//申请中
                cell.detailTextLabel.text = @"审核中";
            }
        }else{
            cell.detailTextLabel.text = @"0.00";
        }
        cell.detailTextLabel.textColor = [UIColor redColor];
        
    }else{
        cell.textLabel.text = @"充值";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0){
        depositVController *deposit=[[depositVController alloc]init];
        [self.navigationController pushViewController:deposit animated:YES];
        
    }else if (indexPath.row == 1){
        if (_deposit >0) {
            if ( _withdraw_status == -1 || _withdraw_status == 2) {
                CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n信用金取出后，可接单额度会下降，确认提出信用金？" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                    if (clickIndex == 200) {
                        [self commitMoney];
                    }
                }];
                [alertView showLXAlertView];
                
            }else if (_withdraw_status == 0 ){
                
                [[iToast makeText:@"信用金提现申请中，请耐心等待"] show];
            }
        }else{
            [[iToast makeText:@"您还未认证信用金！！！"] show];
        }
//        }else{
//            
//            [[iToast makeText:@"您还没有信用金认证不可提现"] show];
//        }
  }
  else{//充值
      PunishViewController *VC = [[PunishViewController alloc]init];
      self.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:VC animated:YES];
      self.hidesBottomBarWhenPushed = NO;
      
  }
}

-(void)getMyWalletInfor{

    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length==0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    _alipay_account = userInfoModel.apliy_account;
    NSString *hmacy = [[communcat sharedInstance ]hmac:[NSString stringWithFormat:@"%d",uesr_type] withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getMyWalletInfoWithkey:userInfoModel.key degist:hmacy  type:[NSString stringWithFormat:@"%d", uesr_type] resultDic:^(NSDictionary *dic) {
            
            int code = [[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
            }else if (code ==1000){
                NSString *deposit = dic[@"data"][@"deposit"];
                _deposit = [deposit doubleValue];
                NSString *amount = dic[@"data"][@"max_withdraw_amount"];
                NSString *depositStatus = dic[@"data"][@"withdraw_status"];
                _max_withdraw_amount = [amount doubleValue];
                _withdraw_status = [depositStatus intValue];
                _moneyLabel.text = [NSString stringWithFormat:@"%.2f",_max_withdraw_amount];
                [self.tableView reloadData];
            }else{
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
}

#pragma mark-------------------- 信用金提现---------
-(void)commitMoney{
    _type = 1;
    _prepayment = 300;
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",userInfoModel.apliy_account],[NSString stringWithFormat:@"%f",_prepayment],[NSString stringWithFormat:@"%d",_type], nil];
    NSString *hmac = [[communcat sharedInstance ]ArrayCompareAndHMac:array];
    In_applyForMoneyModel *inModel = [[In_applyForMoneyModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmac;
    inModel.alipay_account = [NSString stringWithFormat:@"%@",userInfoModel.apliy_account];
  
    inModel.withdraw_amount = [NSString stringWithFormat:@"%f",_prepayment];
    
    inModel.type = [NSString stringWithFormat:@"%d",_type];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getApplyForMoneyModelInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    [[KNToast shareToast] initWithText: @"我们将在两个工作日内给予回复" duration:1 offSetY:0];
                    
                    [self getMyWalletInfor];
                }else{
                    
                    [[KNToast shareToast] initWithText: [dic objectForKey:@"message"] duration:1 offSetY:0];
                }
                
            } );
            
        }];
    });
}


//左侧导航按钮点击
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//右侧导航按钮点击
-(void)rightItemClick{
    
    billVController *VC = [[billVController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)initTableHeaderView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.textAlignment = 1;
        _moneyLabel.font = [UIFont systemFontOfSize:24];
        _moneyLabel.text = @"0.00";
        [_headerView addSubview:_moneyLabel];
    }
    
    if (!_cashLabel) {
        _cashLabel = [[UILabel alloc]init];
        _cashLabel.textColor = [UIColor grayColor];
        _cashLabel.textAlignment = 1;
        _cashLabel.font = [UIFont systemFontOfSize:15];
        _cashLabel.text = @"¥可提现收益";
        [_headerView addSubview:_cashLabel];
        
    }
    _moneyLabel.sd_layout
    .topSpaceToView(_headerView,25)
    .leftSpaceToView(_headerView,10)
    .rightSpaceToView(_headerView,10)
    .heightIs(30);
    _cashLabel.sd_layout
    .topSpaceToView(_moneyLabel,15)
    .leftSpaceToView(_headerView,10)
    .rightSpaceToView(_headerView,10)
    .heightIs(20);
    [self.tableView setTableHeaderView:_headerView];
}

#pragma mark --------------时时更新数据通知--------------
-(void)infor:(NSNotification*)infor{
    NSString *message = infor.userInfo[@"message"];
    if ([message isEqualToString:@"您有一条新消息:您的提现申请已被驳回,请重新申请,详情可联系客服!"] || [message isEqualToString:@"您有一条新消息:你的提现申请已到账,请查收!"] ) {
        [self getMyWalletInfor];//收到通知重新获取数据
        [self.tableView reloadData];//刷新表格
    }
}

//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
