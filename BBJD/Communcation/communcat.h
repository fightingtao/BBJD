//
//  communcat.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/24.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "UserInfoSaveModel.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NetModel.h"
//#import "AFHTTPResponseSerializer.h"
//#import "DataModels.h"
@interface communcat : NSObject
@property (nonatomic,strong)   AFHTTPSessionManager *manager;

+ (id)sharedInstance;
//////////////////////////////////////////////////////////
///颜色创建图片
- (UIImage *) createImageWithColor: (UIColor *) color;
///加密
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
///检查手机号
- (BOOL)checkTel:(NSString *)str;
///排序和加密
- (NSString*)ArrayCompareAndHMac:(NSArray*)array;
///md5加密
- (NSString *) getmd5:(NSString *)str;
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard;

#pragma mark  快捷登录验证码发送
-(void)sendCodeWithPhone:(NSString *)phone resultDic:(void(^)(NSDictionary *dic))dic;

#pragma mark   登录
-(void)LoginbtnClickWithMsg:(In_LoginModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error;

#pragma mark  个人信息首页
-(void)getPersonerMsgWithkey:(NSString *)key degist:(NSString *)degist  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark 退出登录
-(void)loginOutClickWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
#pragma mark 开放城市
-(void)getCityWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
#pragma mark   达人认证
-(void)getApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error;

#pragma mark ---------抢单界面－－－－－－－－－－－

#pragma mark 抢单需求列表
-(void)getGrapListWithMsg:( In_GrapOrderModel *)GrapOrderModel
                     date:(void(^)(NSDate *date))date1    resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark 是否有抢单权
-(void)getlimtsMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark 获取最多赔单量
-(void)getMaxlistWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark 抢单
-(void)grapListWithMsg:(In_GraplistModel *)GrapListModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ------获取接单详情详情信息--------
-(void)grapDetialListWithMsg:(In_GrapDetialListModel *)model
                        date:(void(^)(NSDate *date))date1
                   resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ----------取消订单
-(void)cancellOrderWithMsg:(In_cancellModel *)cancellModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ---------通知列表
-(void)getInformListWithMsg:(In_informModel*)model degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ------------------我的工作首页－－－－－－－－－---
-(void)getHomeWorkInfoWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark-----------------订单扫描－－－－－－－－－－－
-(void)orderScanWithMsg:(In_orderScanModel *)orderScanModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ------------ 已扫描订单列表－－－－－－－－－－－－－－－
-(void)getOrderScanListInfoWithkey:(NSString *)key degist:(NSString *)degist  requirment_id:(NSString *)requirment_id  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark-------------取消订单列表－－－－－－－－－
-(void)cancelOrderWithMsg:(In_orderScanModel *)orderScanModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark----------------更新登录信息
-(void)upDataUserMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;


#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
-(void)sendGoodsListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic fail:(void (^)(NSError*error))error;

#pragma mark-----------------订单详情－－－－－－－－－－－－－
-(void)getDetialListInfoWithkey:(NSString *)key degist:(NSString *)degist order_id:(NSString*)order_id  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark----------------配送yi常原因列表－－－－－－－－－
-(void)getDistributionProblemInfoWithkey:(NSString *)key degist:(NSString *)degist type:(NSString *)type resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark--------------------配送反馈－－－－－－－－－－－－
-(void)getDistributionBackInforWithMsg:(In_distributionBackModel *)BackModel  resultDic:(void (^)(NSDictionary *dic))dic;


#pragma mark---------------推送通知开关---------------------
-(void)getDetialListInfoWithkey:(NSString *)key degist:(NSString *)degist onOff:(NSString*)onOff  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ----------------申请提现借口---------------------
-(void)getApplyForMoneyModelInforWithMsg:(In_applyForMoneyModel *)applyForMoneyModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark--------------历史订单----------------------------
-(void)getHistoryOrderlInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark---------------账单流水----------------------------
-(void)getBillStreamInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  修改绑定手机号 验证码
-(void)changePersonerPhoneMsgWithkey:(NSString *)key degist:(NSString *)degist phone:(NSString *)phone resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  修改绑定手机号

-(void)changePersonerPhoneWith:(In_changePhoneModel *)Model  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark---------------- 最多可提现金额
-(void)getMaxMoneykey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark---------------意见反馈---------------------
//-(void)feedBackClickWithkey:(NSString *)key degist:(NSString *)degist onOff:(NSString*)onOff  resultDic:(void (^)(NSDictionary *dic))dic;

-(void)feedBackClickWithModel:(In_opinionBackModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark   修改达人认证
-(void)changeApproveMsgWithModel:(changeAapprove_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark   获取更新信息
-(void)getVerisonFromAppStoreWithResultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------我的钱包
//-(void)getMyWalletInfoWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;

-(void)getMyWalletInfoWithkey:(NSString *)key degist:(NSString *)degist type:(NSString*)user_type resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------生成订单
-(void)producePayInformationWithModel:(In_payWalletModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------分拣界面接口-------------
-(void)getSortInfoWithkey:(NSString *)key degist:(NSString *)degist telephone:(NSString*)telephone  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------查看支付结果
-(void)checkPayInformationWithModel:(In_payResultModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark -----------短信模块----------------
#pragma mark -----------未读短信 
-(void)noReadMsgWithKey:(NSString *)key digest:(NSString *)digest  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------短信列表
-(void)getMsgListWithModel:(In_msgListModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------钱包短信余额查询
-(void)getMsgMoneyWithKey:(NSString *)key digest:(NSString *)digest   resultDic:(void (^)(NSDictionary *dic))dic;


#pragma mark----------发送短信
-(void)sendMsgWithModel:(in_sendMsgModel*)model  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark -----------短信详情
-(void)getMsgDetailWithModel:(In_msgListModel *)payWalletModel  resultDic:(void (^)(NSDictionary *dic))dic;









@end
