//
//  rechargeModel.m
//  BBJD
//
//  Created by cbwl on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "rechargeModel.h"

@implementation rechargeModel
-(void)AlipayWithInModel:(Out_payWalletBody *)model result:(void (^)(BOOL result))result;
{
    
    
    NSString *partner =  model.partner;
    NSString *seller =model.seller;
    NSString *privateKey = model.private_key;
    
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.tradeNO = [NSString stringWithFormat:@"%@",model.pay_order_id]; //订单ID（由商家自行制定）appid
    order.productName =model.productName;//商品标题
    order.productDescription =model.productDescription; //商品描述
    //    order.amount = [NSString stringWithFormat:@"%.2f",_trade_amount];//test
    order.amount = [NSString stringWithFormat:@"0.01"];//test
    
    order.notifyURL =model.notify_url; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"BBZhongBao";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000){
                 result(YES);

             }else{
                 result(NO);
                }
             
         }];
    }
}
-(void)creacteOrderIdWithModel:(creacteOrderModel *)model btnCan:(void (^)(BOOL isCan))can returnAlipayInModel:(void (^)(Out_payWalletBody *backModel))backModel ;//生成支付订单
{
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",model.trade_amount],[NSString stringWithFormat:@"%f",model.reduced_amount],[NSString stringWithFormat:@"%d",model.trade_way],[NSString stringWithFormat:@"%d",model.trade_type],[NSString stringWithFormat:@"%ld",model.requirment_id ],[NSString stringWithFormat:@"%@",model.order_id ],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_payWalletModel  *inModel = [[In_payWalletModel alloc] init];
    inModel.key = model.userInfoKey;
    inModel.digest = hmacString;
    inModel.trade_amount = [NSString stringWithFormat:@"%f",model.trade_amount];
    inModel.reduced_amount = [NSString stringWithFormat:@"%f",model.reduced_amount];
    inModel.trade_way = [NSString stringWithFormat:@"%d",model.trade_way];
    inModel.trade_type = [NSString stringWithFormat:@"%d",model.trade_type];
    inModel.requirment_id = [NSString stringWithFormat:@"%ld",model.requirment_id];
    inModel.order_id  = [NSString stringWithFormat:@"%@",model.order_id ];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]producePayInformationWithModel:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                can(YES);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }
                else if (code == 1000){
                    DLog(@"充值 %@",dic);
                    NSDictionary *list = dic [@"data"][@"alipay_config"];
                    NSString *notify_url = dic[@"data"][@"notify_url"];
                    
                    NSString *pay_id =  dic[@"data"][@"pay_order_id"];
                  Out_payWalletBody  *resultModel = [[Out_payWalletBody alloc] initWithDictionary:list error:nil];
                    
                    resultModel.notify_url=notify_url;
                    resultModel.pay_order_id=pay_id;
                    backModel(resultModel);
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                }
                
            } );
            
        }];
    });
}
@end
