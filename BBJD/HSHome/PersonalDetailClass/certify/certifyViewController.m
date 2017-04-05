//
//  certifyViewController.m
//  BBJD
//
//  Created by cbwl on 16/9/22.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "certifyViewController.h"
#import "publicResource.h"
#import "certifyTableViewCell.h"
#import "rechargeModel.h"
#import "creacteOrderModel.h"
@interface certifyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    // key digest trade_amount reduced_amount trade_way trade_type
    //requirment_id  order_id
    double _trade_amount;
    double _reduced_amount;
    int   _trade_way;
    int   _trade_type;
    long  _requirment_id;
    NSString *_order_id;
    
    NSString *_notify_url;
    NSString* _pay_order_id;//支付订单号
    Out_payWalletBody *_model;
    creacteOrderModel *_inCrOrderModel;
}

@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)Out_payWalletBody *model;
@end

@implementation certifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信用金认证";
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    [self initTableView];
    [self initFooterView];
    self.tableView.tableFooterView = _footerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:@"alipay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAlipayBack:) name:@"noAlipay" object:nil];

    
    _inCrOrderModel=[[creacteOrderModel alloc]init];

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
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    }

    
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(20, 21, SCREEN_WIDTH -40, 50)];
        _label.textColor = [UIColor grayColor];
        _label.textAlignment = 0;
        _label.numberOfLines = 0;
//        [_label sizeToFit];
        _label.font = [UIFont systemFontOfSize:15];
        _label.text = @"备注：信用金仅做保证金使用，可随时申请退回。";
        [_footerView addSubview:_label];
    }
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, _label.y+_label.height +35, SCREEN_WIDTH-40, 40)];
        _payBtn.clipsToBounds = YES;
        _payBtn.layer.cornerRadius = 10;
        [_payBtn setTintColor:[UIColor whiteColor]];
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _payBtn.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_payBtn];
        
    }
}

#pragma mark --------确认按钮点击----------
-(void)payBtnClick{
    _payBtn.enabled = NO;
    [self getPayInfor];//获取支付信息
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    certifyTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"certifyTableViewCell" owner:self options:nil] lastObject];
    return cell;
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getPayInfor{
   
    
    [ MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    _inCrOrderModel.trade_amount=300;
    rechargeModel *recharge=[[rechargeModel alloc]init];
    [recharge creacteOrderIdWithModel:_inCrOrderModel btnCan:^(BOOL isCan) {
        _payBtn.enabled=YES;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } returnAlipayInModel:^(Out_payWalletBody *backModel) {
        backModel.productName=@"信用金认证";
        backModel.productDescription=@"信用金认证";
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
            
            CustomAlertView *alertViewc = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n支付宝支付失败,是否继续支付" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 200) {
                    
                }
                [alertViewc showLXAlertView];
                
            }];
        }
        
    }];
}


-(void)show:(NSNotification*)infor{
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n支付宝充值成功!" message:nil cancelBtnTitle:nil otherBtnTitle:@"OK" clickIndexBlock:^(NSInteger clickIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView showLXAlertView];
}
-(void)noAlipayBack:(NSNotification *)info{
    NSString *msg=info.object;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付失败" message:[NSString stringWithFormat:@"%@",msg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
