//
//  PunishViewController.m
//  BBJD
//
//  Created by cbwl on 16/9/22.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "PunishViewController.h"
#import "publicResource.h"
#import "PunishTableViewCell.h"
#import "ResultViewController.h"
#import "runWaterViewController.h"
#import "rechargeModel.h"
#import "creacteOrderModel.h"
#import "resultViewModel.h"
@interface PunishViewController ()<UITableViewDelegate,UITableViewDataSource>
{
        double _trade_amount;//支付宝交易金额
        double _reduced_amount;//平台账号扣取金额
        int   _trade_way;//交易方式  1支付宝
        int   _trade_type;//交易类型  13充值
        long  _requirment_id;
        NSString *_order_id;
        NSString *_notify_url;
        NSString* _pay_order_id;//支付订单号
    Out_payWalletBody *_model;
    creacteOrderModel *_inCrOrderModel;
}
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)resultViewModel *viewModel;
@end

@implementation PunishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"充值"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(payPopLeftBtnClick)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"流水" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //流水按钮点击
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        runWaterViewController *VC = [[runWaterViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [self initTableView];
    [self initFooterView];
    self.tableView.tableFooterView = _footerView;
    _inCrOrderModel=[[creacteOrderModel alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:@"alipay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAlipayBack:) name:@"noAlipay" object:nil];

}

-(void)payPopLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT -64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)initFooterView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    }
    
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,100, SCREEN_WIDTH-40, 40)];
        _payBtn.clipsToBounds = YES;
        _payBtn.layer.cornerRadius = 10;
        [_payBtn setTintColor:[UIColor whiteColor]];
        [_payBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _payBtn.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
       
#pragma mark ------立即充值回调--------
         [[_payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
             
          if(_trade_amount <= 0){
                 [[KNToast shareToast] initWithText:@"充值金额不能小于0" duration:1 offSetY:SCREEN_HEIGHT - 100];
                 return ;
            }else{
                [self getPayInfor];//生成支付订单
            }
             
         }];
        
        [_footerView addSubview:_payBtn];
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"identefier";
    
    PunishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (indexPath.section == 0) {
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PunishTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell.moneyField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PunishTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)valueChanged:(UITextField*)feild{
    
    _trade_amount = [feild.text doubleValue];
}


#pragma mark ------生成支付订单----

-(void)getPayInfor{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        _payBtn.enabled = YES;
        return ;
    }

    _inCrOrderModel.reduced_amount=0.00;
    _inCrOrderModel.userInfoKey=userInfoModel.key;
    _inCrOrderModel.trade_way = 1;
    _inCrOrderModel.trade_type = 3;//13;交易类型 1收入 2提现 3交押金 4交罚金 5平台服务费 6发单缴费 13充值
    _inCrOrderModel.requirment_id = 0;
    _inCrOrderModel.order_id = @"";
    _inCrOrderModel.trade_amount=_trade_amount;
    rechargeModel *recharge=[[rechargeModel alloc]init];
    [recharge creacteOrderIdWithModel:_inCrOrderModel btnCan:^(BOOL isCan) {
        _payBtn.enabled=YES;
    } returnAlipayInModel:^(Out_payWalletBody *backModel) {
 
        backModel.productName=@"充值";
        backModel.productDescription=@"充值";
 
        _pay_order_id = backModel.pay_order_id;
 
        [self AliPayActionWithModel:backModel];
        
    }];
  
}

///第三方支付
- (void)AliPayActionWithModel:(Out_payWalletBody *)model
{
    rechargeModel *recharge=[[rechargeModel alloc]init];
     [recharge AlipayWithInModel:model result:^(BOOL result) {
        if (result==YES){
                         }
        else{
            
        CustomAlertView *alertViewc = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n支付宝充值失败,是否继续支付" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
            
            }
            [alertViewc showLXAlertView];
            
        }];
                         }
        
    }];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark --------收到回调------------
-(void)show:(NSNotification*)infor{
    ResultViewController *reVC = [[ResultViewController alloc] init];
    reVC.success = YES;
    [self.navigationController pushViewController:reVC animated:YES];
}

-(void)noAlipayBack:(NSNotification*)infor{
 
    //回传到服务器,传入订单号
    [self.viewModel.resultCommand execute:_pay_order_id];
     ResultViewController *reVC = [[ResultViewController alloc] init];
    reVC.success = NO;
    reVC.model=_model;
    [self.navigationController pushViewController:reVC animated:YES];
}

-(resultViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[resultViewModel alloc] init];
    }
    return _viewModel;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
