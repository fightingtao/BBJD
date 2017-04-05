//
//  ResultViewController.m
//  BBJD
//
//  Created by 李志明 on 17/2/24.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "ResultViewController.h"
#import "publicResource.h"
#import "moneyVController.h"
#import "WXApi.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "PunishViewController.h"
@interface ResultViewController ()
{
    double _trade_amount;//支付宝交易金额
    double _reduced_amount;//平台账号扣取金额
    int   _trade_way;//交易方式  1支付宝
    int   _trade_type;//交易类型  13充值
    long  _requirment_id;
    NSString *_order_id;
    NSString *_notify_url;
    NSString* _pay_order_id;//支付订单号
    
}
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *resultLabel;
@property(nonatomic,strong)UIImageView *resultImg;
@property(nonatomic,strong)UIButton *payAgainBtn;
@end

@implementation ResultViewController

-(UIButton*)payAgainBtn{
    return HT_LAZY(_payAgainBtn, ({
        UIButton *payAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        [payAgain setTitle:@"重新支付" forState:UIControlStateNormal];
        [payAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payAgain.backgroundColor = MAINCOLOR;
        payAgain.titleLabel.font = MiddleFont;
        payAgain.layer.cornerRadius = 10;
        payAgain.clipsToBounds = YES;
        [[payAgain rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PunishViewController class]]) {
                     PunishViewController*A =(PunishViewController *)controller;
                    [A getPayInfor];
                   // [self.navigationController popToViewController:A animated:YES];
                }
            }
          
        }];

        payAgain;
    }));
}

-(UIButton*)backBtn{
    return HT_LAZY(_backBtn, ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        btn.titleLabel.font = MiddleFont;
        btn.layer.cornerRadius = 10;
        btn.clipsToBounds = YES;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[moneyVController class]]) {
                    moneyVController *A =(moneyVController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
        }];
        btn;
    }));
}

-(UIImageView*)resultImg{
    return HT_LAZY(_resultImg, ({
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 65, 30, 30)];
        img;
    }));
    
}
-(UILabel*)resultLabel{
    return HT_LAZY(_resultLabel, ({
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.resultImg.x+30+8, 65, 142, 30)];
        lab.font = [UIFont systemFontOfSize:24];
        lab.textAlignment = 0;
        lab;
    }));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"充值"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(resultPopLeftBtnClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.resultImg];
    [self.view addSubview:self.resultLabel];
    [self returnResult];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:@"alipay" object:nil];
}


-(void)returnResult{
    
    if (self.success) {
        self.resultLabel.textColor = [UIColor colorWithRed:0.2039 green:0.6941 blue:0.2863 alpha:1.0];
         self.resultLabel.text = @"支付成功！";
        self.resultImg.image = [UIImage imageNamed:@"dq_icon_yes.png"];
         self.backBtn.frame = CGRectMake(20, 135,SCREEN_WIDTH-40, 40);
        [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backBtn.backgroundColor = MAINCOLOR;
        [self.view addSubview:self.backBtn];
        
    }else{
        self.resultLabel.textColor = [UIColor redColor];
        self.resultImg.image = [UIImage imageNamed:@"dq_icon_no.png"];
        self.resultLabel.text = @"支付失败！";
        self.backBtn.frame = CGRectMake(20, 135,(SCREEN_WIDTH-60)/2, 40);
         self.payAgainBtn.frame = CGRectMake(self.backBtn.width+40, 135,(SCREEN_WIDTH-60)/2, 40);
        [self.backBtn setTitleColor:MAINCOLOR  forState:UIControlStateNormal];
        self.backBtn.layer.borderColor = MAINCOLOR.CGColor;
        self.backBtn.layer.borderWidth = 1;
        self.backBtn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.backBtn];
        [self.view addSubview:self.payAgainBtn];
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)resultPopLeftBtnClick{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[moneyVController class]]) {
            moneyVController *A =(moneyVController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }}

-(void)getPayInfor{
    //    _trade_amount = 300;
    _reduced_amount = 0.00;
    _trade_way = 1;
    _trade_type = 13;
    _requirment_id = 0;
    _order_id = @"";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {

        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",_trade_amount],[NSString stringWithFormat:@"%f",_reduced_amount],[NSString stringWithFormat:@"%d",_trade_way],[NSString stringWithFormat:@"%d",_trade_type],[NSString stringWithFormat:@"%ld",_requirment_id ],[NSString stringWithFormat:@"%@",_order_id ],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_payWalletModel  *inModel = [[In_payWalletModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.trade_amount = [NSString stringWithFormat:@"%f",_trade_amount];
    inModel.reduced_amount = [NSString stringWithFormat:@"%f",_reduced_amount];
    inModel.trade_way = [NSString stringWithFormat:@"%d",_trade_way];
    inModel.trade_type = [NSString stringWithFormat:@"%d",_trade_type];
    inModel.requirment_id = [NSString stringWithFormat:@"%ld",_requirment_id];
    inModel.order_id  = [NSString stringWithFormat:@"%@",_order_id ];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]producePayInformationWithModel:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }
                else if (code == 1000){
                    //                    NSDictionary *list = dic [@"data"][@"alipay_config"];
                    //                    NSString *notify_url = dic[@"data"][@"notify_url"];
                    //                    _notify_url = notify_url;
                    //
                    //                    NSString *pay_id =  dic[@"data"][@"pay_order_id"];
                    //                    _pay_order_id = pay_id;
                    ////                    _model = [[Out_payWalletBody alloc] initWithDictionary:list error:nil];
                    [self AliPayAction];//调转支付宝
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                }
                
            } );
            
        }];
    });
}

///第三方支付
- (void)AliPayAction
{
    
    //    NSString *partner =  _model.partner;
    //    NSString *seller = _model.seller;
    //    NSString *privateKey = _model.private_key;
    //
    //    if ([partner length] == 0 ||
    //        [seller length] == 0 ||
    //        [privateKey length] == 0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
    //                                                        message:@"缺少partner或者seller或者私钥。"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    
    //    Order *order = [[Order alloc] init];
    //    order.partner = partner;
    //    order.seller = seller;
    //
    //    order.tradeNO = [NSString stringWithFormat:@"%@",_pay_order_id]; //订单ID（由商家自行制定）appid
    //    order.productName = @"信用金认证";//商品标题
    //    order.productDescription = @"信用金认证"; //商品描述
    //    order.amount = [NSString stringWithFormat:@"300"];//test
    //    order.notifyURL = _notify_url; //回调URL
    //    order.service = @"mobile.securitypay.pay";
    //    order.paymentType = @"1";
    //    order.inputCharset = @"utf-8";
    //    order.itBPay = @"30m";
    //    order.showUrl = @"m.alipay.com";
    //
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    //    NSString *appScheme = @"BBZhongBao";
    //将商品信息拼接成字符串
    //    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    //    NSString *orderString = nil;
    //    if (signedString != nil) {
    //        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
    //                       orderSpec, signedString, @"RSA"];
    //
    //        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
    //         {
    //             if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000){
    //             }else{
    //
    //                 CustomAlertView *alertViewc = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n支付宝充值失败,是否继续支付" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
    //                     if (clickIndex == 200) {
    //                         
    //                     }
    //                     [alertViewc showLXAlertView];
    //                 }];
    //             }
    //             
    //         }];
    //    }
}


#pragma mark --------收到回调------------
-(void)show:(NSNotification*)infor{
    ResultViewController *reVC = [[ResultViewController alloc] init];
    
    reVC.success = YES;
    
    [self.navigationController pushViewController:reVC animated:YES];
}

@end
