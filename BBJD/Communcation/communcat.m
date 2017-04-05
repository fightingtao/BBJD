//
//  communcat.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/24.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "communcat.h"
#import "publicResource.h"

@implementation communcat
#pragma mark  快捷登录验证码发送
-(void)sendCodeWithPhone:(NSString *)phone resultDic:(void(^)(NSDictionary *dic))dic
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:phone forKey:@"telephone"];
   
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login/code",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}
#pragma mark   登录
-(void)LoginbtnClickWithMsg:(In_LoginModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:loginInModel.telephone forKey:@"telephone"];
    [indic setObject:loginInModel.code forKey:@"code"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    } fail:^(NSError *fail) {
        error(fail);
    }];

}

#pragma mark   我的工作首页
-(void)getWorkMsgWithModel:(In_LoginModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:loginInModel.telephone forKey:@"telephone"];
    [indic setObject:loginInModel.code forKey:@"code"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {

        dic(resultDic);
    }];
    
}

#pragma mark  个人信息首页
-(void)getPersonerMsgWithkey:(NSString *)key degist:(NSString *)degist  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/person/info/index",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];

}
#pragma mark  修改绑定手机号
-(void)changePersonerPhoneMsgWithkey:(NSString *)key degist:(NSString *)degist phone:(NSString *)phone resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:phone forKey:@"telephone"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/update/mobile/code",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark 退出登录
-(void)loginOutClickWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/logout",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark 开放城市
-(void)getCityWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/requirement/open/city/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark   达人认证
-(void)getApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.degist forKey:@"digest"];
    [in_dic setObject:loginInModel.positive_idcard  forKey:@"positive_idcard"];
    [in_dic setObject:loginInModel.opposite_idcard forKey:@"opposite_idcard"];
    [in_dic setObject:loginInModel.hand_idcard  forKey:@"hand_idcard"];
    [in_dic setObject:loginInModel.apliy_account forKey:@"apliy_account"];
    [in_dic setObject:loginInModel.username  forKey:@"username"];
    [in_dic setObject:loginInModel.idcardno forKey:@"idcardno"];
    [in_dic setObject:loginInModel.mobile  forKey:@"mobile"];
    [in_dic setObject:loginInModel.city_name forKey:@"city_name"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/authenticate",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
         dic(resultDic);
    } fail:^(NSError *fail) {
        error(fail);
    } ];
}

#pragma mark   修改达人认证
-(void)changeApproveMsgWithModel:(changeAapprove_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
 
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.degist forKey:@"digest"];
       [in_dic setObject:loginInModel.alipay_account forKey:@"alipay_account"];
    [in_dic setObject:loginInModel.city_name forKey:@"city_name"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/authen/info/update",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark -------------抢单界面－－－－－－－－－－－---------
#pragma mark ----------------是否有抢单权
-(void)getlimtsMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/requirement/permission/grab/order",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark---------------- 获取最多赔单量
-(void)getMaxlistWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/requirement/max/delivery/count",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}
#pragma mark ---------------抢单

-(void)grapListWithMsg:(In_GraplistModel *)GrapListModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:GrapListModel.key forKey:@"key"];
    [indic setObject:GrapListModel.digest forKey:@"digest"];
    [indic setObject:[NSString stringWithFormat:@"%@",GrapListModel.requirment_id] forKey:@"requirment_id"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/requirement/grab/order",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark ---------------获取接单界面需求列表--------
-(void)getGrapListWithMsg:( In_GrapOrderModel *)GrapOrderModel
                     date:(void(^)(NSDate *date))date1    resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:GrapOrderModel.key forKey:@"key"];
    [indic setObject:GrapOrderModel.digest forKey:@"digest"];
    [indic setObject:GrapOrderModel.offset forKey:@"offset"];
    [indic setObject:GrapOrderModel.pagesize forKey:@"pagesize"];
    [indic setObject:GrapOrderModel.city_name forKey:@"city_name"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/requirement/list",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url date:^(NSDate *date){
        date1(date);
    } result:^(NSDictionary *resultDic) {
        
        dic(resultDic);
    }];
}

#pragma mark ------获取接单详情信息--------
-(void)grapDetialListWithMsg:(In_GrapDetialListModel *)model
date:(void(^)(NSDate *date))date1
                   resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:model.key forKey:@"key"];
    [indic setObject:model.digest forKey:@"digest"];
    [indic setObject:model.requirment_id forKey:@"requirment_id"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/requirement/get/requirment/detail",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url date:^(NSDate *date){
        date1(date);
        
    }
                            result:^(NSDictionary *resultDic) {
                                dic(resultDic);
                            }];
}

#pragma mark ----------取消订单
-(void)cancellOrderWithMsg:(In_cancellModel *)cancellModel   resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:cancellModel .key forKey:@"key"];
    [indic setObject:cancellModel .digest forKey:@"digest"];
    [indic setObject:[NSString stringWithFormat:@"%@",cancellModel .requirment_id] forKey:@"requirment_id"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/requirement/grab/order/cancle",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark ---------通知列表
-(void)getInformListWithMsg:(In_informModel*)model degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
   
    NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
    [indic setObject:model.key forKey:@"key"];
    [indic setObject:model.digest forKey:@"digest"];
    [indic setObject:model.offset forKey:@"offset"];
    [indic setObject:model.page_size forKey:@"page_size"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/requirement/get/message/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark ------------------我的工作首页－－－－－－－－－---
-(void)getHomeWorkInfoWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/my/work/index",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark-----------------订单扫描－－－－－－－－－－－
-(void)orderScanWithMsg:(In_orderScanModel *)orderScanModel  resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:orderScanModel.key forKey:@"key"];
    [indic setObject:orderScanModel.digest forKey:@"digest"];
    [indic setObject:orderScanModel.order_id forKey:@"order_id"];
    [indic setObject:orderScanModel.requirment_id forKey:@"requirment_id"];
    [indic setObject:orderScanModel.type forKey:@"type"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/scan/order",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark ------------ 已扫描订单列表－－－－－－－－－－－－－－－
-(void)getOrderScanListInfoWithkey:(NSString *)key degist:(NSString *)degist  requirment_id:(NSString *)requirment_id  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:requirment_id forKey:@"requirment_id"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/scan/order/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark-------------取消订单列表－－－－－－－－－
-(void)cancelOrderWithMsg:(In_orderScanModel *)orderScanModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:orderScanModel.key forKey:@"key"];
    [indic setObject:orderScanModel.digest forKey:@"digest"];
    
    [indic setObject:orderScanModel.order_id forKey:@"order_id"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/scan/order/cancle",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}
#pragma mark----------------更新登录信息
-(void)upDataUserMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login/info",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}
#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
-(void)sendGoodsListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error {
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:sendGoodsModel.key forKey:@"key"];
    [indic setObject:sendGoodsModel.digest forKey:@"digest"];
    [indic setObject:sendGoodsModel.status forKey:@"status"];
    [indic setObject:sendGoodsModel.offset forKey:@"offset"];
    [indic setObject:sendGoodsModel.page_size forKey:@"page_size"];
    [indic setObject:sendGoodsModel.word forKey:@"word"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/dispatch/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    } fail:^(NSError *fail) {
       
        error(fail);
    }];
    
}

#pragma mark-----------------订单详情－－－－－－－－－－－－－
-(void)getDetialListInfoWithkey:(NSString *)key degist:(NSString *)degist order_id:(NSString*)order_id  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:order_id forKey:@"order_id"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/order/detail",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark----------------配送yi常原因列表－－－－－－－－－
-(void)getDistributionProblemInfoWithkey:(NSString *)key degist:(NSString *)degist type:(NSString *)type resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:type forKey:@"type"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/expt/reason/list",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}

#pragma mark--------------------配送反馈－－－－－－－－－－－－
-(void)getDistributionBackInforWithMsg:(In_distributionBackModel *)BackModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:BackModel.key forKey:@"key"];
    [indic setObject:BackModel.digest forKey:@"digest"];
    [indic setObject:BackModel.order_id forKey:@"order_id"];
    [indic setObject:BackModel.type forKey:@"type"];
    [indic setObject:BackModel.sign_type forKey:@"sign_type"];
    [indic setObject:BackModel.sign_man forKey:@"sign_man"];
    [indic setObject:BackModel.expt_code forKey:@"expt_code"];
    [indic setObject:BackModel.expt_msg forKey:@"expt_msg"];
    [indic setObject:BackModel.next_delivery_time forKey:@"next_delivery_time"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/order/feedback",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
    
}

#pragma mark---------------推送通知开关---------------------
-(void)getDetialListInfoWithkey:(NSString *)key degist:(NSString *)degist onOff:(NSString*)onOff  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:onOff forKey:@"onOff"];//on 打开 off关闭
    
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/notify/switch",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark---------------意见反馈---------------------
-(void)feedBackClickWithModel:(In_opinionBackModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
   
    [indic setObject:InModel.key forKey:@"key"];
    [indic setObject:InModel.digest forKey:@"digest"];
    [indic setObject:InModel.suggestion_text  forKey:@"suggestion_text"];
     [indic setObject:InModel.suggestion_version  forKey:@"suggestion_version"];
    [indic setObject:[NSString stringWithFormat:@"%d",InModel.suggestion_source] forKey:@"suggestion_source"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/suggest",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark---------------- 最多可提现金额
-(void)getMaxMoneykey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/max/withdraw/amount",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}
#pragma mark ----------------申请提现借口---------------------
-(void)getApplyForMoneyModelInforWithMsg:(In_applyForMoneyModel *)applyForMoneyModel  resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:applyForMoneyModel.key forKey:@"key"];
    [indic setObject:applyForMoneyModel.digest forKey:@"digest"];
    [indic setObject:applyForMoneyModel.alipay_account forKey:@"alipay_account"];
    [indic setObject:applyForMoneyModel.withdraw_amount forKey:@"withdraw_amount"];
    [indic setObject:applyForMoneyModel.type forKey:@"type"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/apply/withdraw",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark--------------历史订单---------------------
-(void)getHistoryOrderlInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:historyOrderModel.key forKey:@"key"];
    [indic setObject:historyOrderModel.digest forKey:@"digest"];
    [indic setObject:historyOrderModel.offset forKey:@"offset"];
    [indic setObject:historyOrderModel.page_size forKey:@"page_size"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/history/order",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark---------------修改绑定手机号----------------------------

-(void)changePersonerPhoneWith:(In_changePhoneModel *)Model  resultDic:(void (^)(NSDictionary *dic))dic
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:Model.key forKey:@"key"];
    [indic setObject:Model.digest forKey:@"digest"];
    [indic setObject:Model.header forKey:@"header"];
    [indic setObject:Model.mobile forKey:@"mobile"];
    [indic setObject:Model.newmobile forKey:@"newmobile"];
    [indic setObject:Model.code forKey:@"code"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/update/user/info",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
    
}
#pragma mark---------------账单流水----------------------------

-(void)getBillStreamInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:historyOrderModel.key forKey:@"key"];
    [indic setObject:historyOrderModel.digest forKey:@"digest"];
    [indic setObject:historyOrderModel.offset forKey:@"offset"];
    [indic setObject:historyOrderModel.page_size forKey:@"page_size"];
    [indic setObject:historyOrderModel.type forKey:@"type"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/wallet/log",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
    
}
#pragma mark   获取更新信息
-(void)getVerisonFromAppStoreWithResultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSString *url=[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup"];
    
    [self getMessageUsePostWithDic:nil url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
    
}

#pragma mark -----------我的钱包
-(void)getMyWalletInfoWithkey:(NSString *)key degist:(NSString *)degist  type:(NSString*)user_type resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:user_type forKey:@"user_type"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/user/my/wallet",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark -----------生成订单
-(void)producePayInformationWithModel:(In_payWalletModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:payWalletModel.key forKey:@"key"];
    [indic setObject:payWalletModel.digest forKey:@"digest"];
    [indic setObject:payWalletModel.trade_amount forKey:@"trade_amount"];
    [indic setObject:payWalletModel.reduced_amount forKey:@"reduced_amount"];
    [indic setObject:payWalletModel.trade_way forKey:@"trade_way"];
    [indic setObject:payWalletModel.trade_type forKey:@"trade_type"];
    [indic setObject:payWalletModel.requirment_id forKey:@"requirment_id"];
    [indic setObject:payWalletModel.order_id forKey:@"order_id"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/build/pay/order",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark -----------分拣界面接口-------------
-(void)getSortInfoWithkey:(NSString *)key degist:(NSString *)degist telephone:(NSString*)telephone  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:telephone forKey:@"telephone"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/delivery/pick",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
         
        dic(resultDic);
    }];
}

#pragma mark -----------查看支付结果-------------
-(void)checkPayInformationWithModel:(In_payResultModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:payWalletModel.key forKey:@"key"];
    [indic setObject:payWalletModel.digest forKey:@"digest"];
 
    [indic setObject:payWalletModel.pay_order_id forKey:@"pay_order_id"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/query/pay/order",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark -----------短信模块----------------
#pragma mark -----------未读短信
-(void)noReadMsgWithKey:(NSString *)key digest:(NSString *)digest  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/unreadSMS",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark -----------短信列表
-(void)getMsgListWithModel:(In_msgListModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:payWalletModel.key forKey:@"key"];
    [indic setObject:payWalletModel.digest forKey:@"digest"];
    
   // [indic setObject:payWalletModel.message_id forKey:@"message_id"];
   // [indic setObject:payWalletModel.offset forKey:@"offset"];
    //[indic setObject:payWalletModel.page_size forKey:@"page_size"];

   // [indic setObject:payWalletModel.issend forKey:@"issend"];
     [indic setObject:payWalletModel.keyWords forKey:@"keyWords"];

    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/sendRecord/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}
#pragma mark -----------短信详情
-(void)getMsgDetailWithModel:(In_msgListModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:payWalletModel.key forKey:@"key"];
    [indic setObject:payWalletModel.digest forKey:@"digest"];
    
    // [indic setObject:payWalletModel.message_id forKey:@"message_id"];
    // [indic setObject:payWalletModel.offset forKey:@"offset"];
    //[indic setObject:payWalletModel.page_size forKey:@"page_size"];
    
    // [indic setObject:payWalletModel.issend forKey:@"issend"];
    [indic setObject:payWalletModel.mobile forKey:@"mobile"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/sendRecord/detail",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark----------发送短信
-(void)sendMsgWithModel:(in_sendMsgModel*)model  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:model.key forKey:@"key"];
    [indic setObject:model.digest forKey:@"digest"];
    [indic setObject:model.recipientMobile forKey:@"recipientMobile"];
    [indic setObject:model.messagetext forKey:@"messagetext"];
    [indic setObject:model.countNum forKey:@"count"];
    [indic setObject:model.smstemplateId forKey:@"smstemplateId"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/sendMS",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}

#pragma mark -----------钱包短信余额查询
-(void)getMsgMoneyWithKey:(NSString *)key digest:(NSString *)digest  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/get/wallet/balance",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
        
    }];
    
}

#pragma mark 网络请求时对AFnetWork的封装
-(void)getMessageUsePostWithDic:(NSDictionary *)dic url:(NSString *)url result:(void(^)(NSDictionary * resultDic))resultDic{
    if ([[dic objectForKey:@"digest"] isEqualToString:@""]) {
        return;
    }
    _manager =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [_manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        resultDic(dicJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"失败%@",error);
    }];
}

#pragma mark 网络请求时对AFnetWork的封装，无网络或失败是
-(void)getMessageUsePostWithDic:(NSDictionary *)dic url:(NSString *)url result:(void(^)(NSDictionary * resultDic))resultDic fail:(void(^)(NSError * fail))fail{
    if ([[dic objectForKey:@"digest"] isEqualToString:@""]) {
        return;
    }
    _manager =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 15.0f;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [_manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        resultDic(dicJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

#pragma mark 网络请求时对AFnetWork的封装  返回时间
-(void)getMessageUsePostWithDic:(NSDictionary *)dic url:(NSString *)url date:(void(^)(NSDate * date))date result:(void(^)(NSDictionary * resultDic))resultDic{
    if ([[dic objectForKey:@"digest"] isEqualToString:@""]) {
        return;
    }
    _manager =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [_manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
      ;
    
        date([self getSysDateFromString:allHeaders[@"Date"]]);
        resultDic(dicJson);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"失败%@",error);
        
    }];
    
}

#pragma mark -------获取服务器时间-----------
-(NSDate*)getSysDateFromString:(NSString*)str{
    
    NSString* string = [str substringToIndex:25];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc]
                               initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    return inputDate;
    
}

//****************************************************
//创建图片
- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}


//加密
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}



//数组排序 和加密
- (NSString*)ArrayCompareAndHMac:(NSArray*)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    // 返回一个排好序的数组，原来数组的元素顺序不会改变
    // 指定元素的比较方法：compare:
    NSString *tempContent = @"";
    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i<[array2 count]; i++) {
        NSString *temp = [array2 objectAtIndex:i];
        tempContent = [NSString stringWithFormat:@"%@%@",tempContent,temp];
    }
    if (userInfoModel&&userInfoModel.key && ![userInfoModel.key isEqualToString:@""]&& userInfoModel.key.length != 0)
    {
        
        const char *cKey  = [userInfoModel.primary_key cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cData = [tempContent cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
        const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
        NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
        for (int i = 0; i < HMACData.length; ++i){
            [HMAC appendFormat:@"%02x", buffer[i]];
        }
        return HMAC;
        
    }else{
        return tempContent;
    }
}
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark 验证手机号码
- (BOOL)checkTel:(NSString *)str{
    if ([str length] == 0) {
        return NO;
    }
    NSString *regex =  @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
//       [[KNToast shareToast] initWithText:@"请输入正确的手机号" offSetY:0 ];
        return NO;
    }
    return YES;
}

//md5加密
- (NSString *) getmd5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString
            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1],
            
            result[2], result[3],
            
            result[4], result[5],
            
            result[6], result[7],
            
            result[8], result[9],
            
            result[10], result[11],
            
            result[12], result[13],
            
            result[14], result[15]
            
            ];
}

+ (id)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}
@end
