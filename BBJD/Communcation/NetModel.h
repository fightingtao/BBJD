//
//  NetModel.h
//  CYZhongBao
//
//  Created by xc on 15/12/2.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "JSONModel.h"

@interface NetModel : JSONModel

@end

///通用返回model
@interface Out_AllSameModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) NSString <Optional>*data;

@end

//-------------------------------------------------------------




///获取登录验证码Model
@interface In_LoginCodeModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*telephone;

@end

@interface Out_LoginCodeModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) NSString <Optional>*data;

@end
//-------------------------------------------------------------


///用户登录Model
@interface In_LoginModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*telephone;
@property (nonatomic, strong) NSString <Optional>*code;
@property (nonatomic, strong) NSString <Optional>*user_type;
@end

@protocol OutLoginBody <NSObject>
@end

@interface OutLoginBody : JSONModel

@property (nonatomic, strong) NSString <Optional>*  primary_key;//string	秘钥（每次调用接口时加密使用）
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* city_name;//string	工作城市
@property (nonatomic, strong) NSString <Optional>* tag;//	string	极光推送标签
@property (nonatomic, strong) NSString <Optional>* driver_license;//	string	机动车驾照
@property (nonatomic, strong) NSString <Optional>* vehicle	;//string	交通工具
@property (nonatomic, strong) NSString <Optional>* dominate_time	;//string	可支配时间
@property (nonatomic, strong) NSString <Optional>* opposite_idcard;//	string	身份证反面照
@property (nonatomic, strong) NSString <Optional>* idcardno	;//string	身份证号码
@property (nonatomic, strong) NSString <Optional>* level	;//int	用户等级
@property (nonatomic, strong) NSString <Optional>*  emergency_contact_mobile	;//string	紧急联系人手机号码
@property (nonatomic, strong) NSString <Optional>* gender	;//int	性别 0女 1男
@property (nonatomic, strong) NSString <Optional>* is_payed	;//int	是否交付押金 1已交 0未交
@property (nonatomic, strong) NSString <Optional>* seller_id	;//int	站点id
@property (nonatomic, strong) NSString <Optional>* apliy_account	;//string	绑定的支付宝账号
@property (nonatomic, strong) NSString <Optional>* intention_delivery_area;//	string	意向配送区域
@property (nonatomic, strong) NSString <Optional>* status	;//int	0启用（未分配到站） 1工作中（分配到站）
@property (nonatomic, strong) NSString <Optional>* nickname;//	string	昵称
@property (nonatomic, strong) NSString <Optional>*  user_type	;//int	用户类型 0邦办达人 1站长 2HR 3财务 4管理员
@property (nonatomic, strong) NSString <Optional>*  emergency_contact_name	;//string	紧急联系人姓名
@property (nonatomic, strong) NSString <Optional>* user_status;//	string	账号状态 1启用 0禁用
@property (nonatomic, strong) NSString <Optional>* positive_idcard;//	string	身份证正面照
@property (nonatomic, strong) NSString <Optional>* authen_status	;//string	邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
@property (nonatomic, strong) NSString <Optional>* header	;//string	用户头像地址
@property (nonatomic, strong) NSString <Optional>*  point	;//int	用户当前积分
@property (nonatomic, strong) NSString <Optional>* realname;//	string	真实姓名
@property (nonatomic, strong) NSString <Optional>* hand_idcard	;//string	身份证手持照
@property (nonatomic, strong) NSString <Optional>* telephone	;//string	手机号码
@property (nonatomic, strong) NSString <Optional>* notify_switch;//	string	on接收通知 off不接收通知
@property (nonatomic, strong) NSString <Optional>* frozen_days;
@property (nonatomic, strong) NSString <Optional>* frozen_type;
@end

@interface Out_LoginModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) OutLoginBody <Optional>*data;

@end


//-------------------------------------------------------------
#pragma mark 个人中心首页
@interface OutPersonerBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*today_profit;//	double	今日收益（单位：元）
@property (nonatomic, strong) NSString <Optional>*level	;//int	用户等级
@property (nonatomic, strong) NSString <Optional>*total_profit	;//double	平台总首页（单位：元）
@property (nonatomic, strong) NSString <Optional>*withdraw_profit;//	double	可提现收益（单位：元）
@property (nonatomic, strong) NSString <Optional>*is_payed;//	int	是否支付押金（0未支付 1支付成功 2支付失败）
@property (nonatomic, strong) NSString <Optional>*authen_status	;//int	邦办达人认证状态 0申请中 1审核通过 2审核失败
@property (nonatomic, strong) NSString <Optional>*header;//	string	用户头像
@property (nonatomic, strong) NSString <Optional>*mobile	;//string	用户绑定手机号码
@property (nonatomic, strong) NSString <Optional>*company_contact;
@property (nonatomic, strong) NSString <Optional>*title;//		文字描述
@end

@interface Out_personerModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) OutPersonerBody <Optional>*data;

@end
//----------------------------------------------------

@interface approve_InModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* degist;
@property (nonatomic, strong) NSString <Optional>* city_name;//	string	工作城市
@property (nonatomic, strong) NSString <Optional>* positive_idcard	;//string	身份证正面照url
@property (nonatomic, strong) NSString <Optional>* opposite_idcard	;//string	身份证反面照url
@property (nonatomic, strong) NSString <Optional>* username	;//string	用户真实姓名
@property (nonatomic, strong) NSString <Optional>* idcardno;//	string	身份证号
@property (nonatomic, strong) NSString <Optional>* hand_idcard	;//string	手持身份证照url
@property (nonatomic, strong) NSString <Optional>* mobile;//	string	手机号码
@property (nonatomic, strong) NSString <Optional>* apliy_account;//	string	绑定的支付宝账号

@end
#pragma mark  修改认证信息
@interface changeAapprove_InModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* degist;
@property (nonatomic, strong) NSString <Optional>* city_name;//	string	工作城市
@property (nonatomic, strong) NSString <Optional>* alipay_account;//	string	手机号码

@end
//----------------------------------------------------
#pragma mark------------抢单界面－－－－－－－－－－－－－－－－

#pragma mark  抢单需求
@interface In_GrapOrderModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*offset;
@property (nonatomic, strong) NSString <Optional>*pagesize;
@property (nonatomic, strong) NSString <Optional>*city_name;//	string	需求发布城市名
@end

@interface Out_GrapOrderBody: JSONModel
@property (nonatomic, strong) NSString <Optional>* seller_name;//	string	商家名称
@property (nonatomic, strong) NSString <Optional>* requirment_type	;//int	"需求类型 0需求发单 1网点发单 2网格发单"
@property (nonatomic, strong) NSString <Optional>*grab_status	;//int	1已抢单 0未抢单
@property (nonatomic, strong) NSString <Optional>*arrived_time	;//string	达人到达时间
@property (nonatomic, strong) NSString <Optional>*vehicle	;//string	交通工具
@property (nonatomic, strong) NSString <Optional>*countdown;//	int	倒计时
@property (nonatomic, strong) NSString <Optional>*seller_address;//	string	商家文字地址
@property (nonatomic, strong) NSString <Optional>*remainder_order_amount;//	int	需求剩余单量
@property (nonatomic, strong) NSString <Optional>*per_oder_commission;//	int	每单佣金
@property (nonatomic, strong) NSString <Optional>*delivery_distance;//	int	配送范围
@property (nonatomic, strong) NSString <Optional>*publish_time	;//string	需求发布时间
@property (nonatomic, strong) NSString <Optional>*delivery_count	;//int	已抢需求工作量
@property (nonatomic, strong) NSString <Optional>*seller_mobile	;//string	商家联系方式
@property (nonatomic, strong) NSString <Optional>*requirment_id;//	int	需求id
@property (nonatomic, strong) NSString <Optional>*has_grabed;//	boolean	true已抢过单 false未抢过单
@property (nonatomic, strong) NSString <Optional>*grab_time;//达人抢单时间
@property (nonatomic, strong) NSString <Optional>*grid_name;//网格名称
@property (nonatomic, strong) NSString <Optional>*grid_address;//网格地址
@property (nonatomic, strong) NSString <Optional>*seller_type;//商家类型

@end

@interface Out_GrapOrderModel : JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) NSDictionary <Optional>*data;
@end

#pragma mark ----------判断是否有抢单权
@interface Out_limtsBody: JSONModel
@property(nonatomic,strong)NSString <Optional>*pemission;//是否有权限抢单 yes/no
@end

@interface Out_limtsModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_limtsBody <Optional>*data;
@end

#pragma mark -----------获取最多赔单量

@interface Out_maxlistBody: JSONModel
@property(nonatomic,strong)NSString <Optional>*max_delivery_count;//最大意向配送单量
@end

@interface Out_lmaxlistModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_maxlistBody <Optional>*data;
@end

#pragma mark -------------抢单
@interface In_GraplistModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*delivery_count;//赔单量
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id
@end
//通用反回Model

#pragma mark -------------获取抢单详情列表
@interface In_GrapDetialListModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id
@end

@interface Out_GrapDetialListBody:JSONModel
@property (nonatomic, strong) NSString <Optional>* estimate_income;//预计收入
@property (nonatomic, strong) NSString <Optional>* order_amount;//单量
@property (nonatomic, strong) NSString <Optional>* requirment_type;//需求类型
@property (nonatomic, strong) NSString <Optional>* status;//需求状态
@property (nonatomic, strong) NSString <Optional>*grab_time;//抢单时间
@property (nonatomic, strong) NSString <Optional>* grid_name;//网格名称
@property (nonatomic, strong) NSString <Optional>*grid_address;//网格地址
@property (nonatomic, strong) NSString <Optional>*seller_name;//商家名称
@property (nonatomic, strong)NSString<Optional>*seller_address;//商家名称
@property (nonatomic, strong) NSString<Optional>*seller_mobile;//商家电话
@property (nonatomic, strong)NSString<Optional>*grab_status;//抢单状态

@property (nonatomic, strong)NSString<Optional>*arrived_time;//到站时间
@property (nonatomic, strong)NSString<Optional>*delivery_distance;//配送范围
@property (nonatomic, strong)NSString<Optional>*vehicle;//交通工具
@property(nonatomic,strong)NSString *has_grabed;//是否第一次抢单
@property(nonatomic,strong)NSString *deduct;//是否扣取1元 1扣取  0 不扣取
@end



@interface Out_GrapDetialListModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_GrapDetialListBody<Optional>*data;
@end




#pragma mark ----------取消订单
@interface In_cancellModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id
@end

//返回通用Model

#pragma mark ---------通知列表

@interface In_informModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;

@property (nonatomic, strong) NSString <Optional>*offset;//分页起始值（默认0）
@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小（默认10）
@end

@interface Out_informBody: JSONModel
@property(nonatomic,strong)NSString<Optional>*create_time;//推送通知时间
@property(nonatomic,strong)NSString<Optional>*msg;//推送通知内容
@end

@interface Out_informModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_informBody <Optional>*data;
@end

#pragma mark ------------------我的工作首页－－－－－－－－－---
@interface Out_myHomeWorkBody: JSONModel

@property(nonatomic,strong)NSString <Optional>*waiting_delivery_order_count;//今日待配送单数

@property(nonatomic,strong)NSString <Optional>*today_profit;//今日收益
@property(nonatomic,strong)NSString <Optional>*seller_mobile;//站长手机号码
@property(nonatomic,strong)NSString <Optional>*seller_name;//站点名称
@property(nonatomic,strong)NSString <Optional>*today_work_amount;///	int	今日配送工作量
@end

@interface Out_myHomeWorkModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_myHomeWorkBody <Optional>*data;

@end

#pragma mark-----------------订单扫描－－－－－－－－－－－

@interface In_orderScanModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id
@property (nonatomic, strong) NSString <Optional>*order_id;//扫描订单号
@property (nonatomic, strong) NSString <Optional>*type;//商家类型
//通用反回model
@end

#pragma mark ------------ 已扫描订单列表－－－－－－－－－－－－－－－
@interface Out_orderListBody: JSONModel
@property(nonatomic,strong)NSString <Optional>*order_original_id;//订单号
@end

@interface Out_orderListModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_orderListBody <Optional>*data;

@end

#pragma mark --------------取消扫描订单－－－－－－－－－－－－－
//请求参数订单扫描参数

#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
@interface In_sendGoodsModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*status;//1配送中 2已签收 3异常件 4已分配
@property (nonatomic, strong) NSString <Optional>*offset;//分页查询起始值

@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小
@property (nonatomic, strong) NSString <Optional>*word;//模糊查询字符串
@end

@interface Out_sendGoodsBody: JSONModel
//@property(nonatomic,copy)NSString <Optional>*sending_count;//配送中订单量
//@property(nonatomic,copy)NSString <Optional>*expt_count;//异常件数量
//@property(nonatomic,copy)NSString <Optional>*sign_count;//已签收数量
//@property(nonatomic,copy)NSString <Optional>*assign_count;//已分配单量
@property(nonatomic,copy)NSString <Optional>*order_original_id;//订单号
@property(nonatomic,copy)NSString <Optional>*consignee_name;//收件人姓名
@property(nonatomic,copy)NSString <Optional>*linghuo_time;//领货时间
@property(nonatomic,copy)NSString <Optional>*dssnname;//商家名称（如：天猫）
@property(nonatomic,copy)NSString <Optional>*consignee_address;//收件人地址

@property(nonatomic,copy)NSString <Optional>*consignee_mobile;//收件人手机号码
@property(nonatomic,copy)NSString <Optional>*order_status;/*配送中（1） 已签收（2 4 5） 异常件（3）0导入数据 1已领货 2配送成功 3配送异常 4回调成功 5回调异常 6取消扫描 8已分配*/
@property(nonatomic,copy)NSString <Optional>*next_delivery_time;
@property(nonatomic,copy)NSString <Optional>*expt_msg;

@end

@interface Out_sendGoodsModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_sendGoodsBody <Optional>*data;

@end

#pragma mark-----------------订单详情－－－－－－－－－－－－－
@interface Out_detialListBody: JSONModel

@property(nonatomic,copy)NSString <Optional>*order_original_id;//订单号
@property(nonatomic,copy)NSString <Optional>*consignee_name;//收件人姓名

@property(nonatomic,copy)NSString <Optional>*linghuo_time;//领货时间
@property(nonatomic,copy)NSString <Optional>*dssnname;//商家名称（如：天猫）
@property(nonatomic,copy)NSString <Optional>*consignee_address;//收件人地址
@property(nonatomic,copy)NSString <Optional>*consignee_mobile;//收件人手机号码
@property(nonatomic,copy)NSString <Optional>*order_status;/*配送中（1） 已签收（2 4 5） 异常件（3）
                                                        0导入数据 1已领货 2配送成功 3配送异常 4回调成功 5回调异常 6取消扫描*/
@property(nonatomic,copy)NSString <Optional>*next_delivery_time;
@property(nonatomic,copy)NSString <Optional>*expt_msg;
@property(nonatomic,copy)NSString <Optional>*sign_man;//签收人
@property(nonatomic,copy)NSString <Optional>*sign_time;//签收时间

@end

@interface Out_detialListModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_detialListBody <Optional>*data;

@end

#pragma mark----------------配送yi常原因列表－－－－－－－－－distribution
@interface Out_distributionProblemBody: JSONModel
@property(nonatomic,copy)NSString <Optional>*reason_code;//异常原因编码
@property(nonatomic,copy)NSString <Optional>*reason_msg;//异常原因
@end

@interface Out_distributionProblemModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_distributionProblemBody <Optional>*data;

@end

#pragma mark--------------------配送反馈－－－－－－－－－－－－
@interface In_distributionBackModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*order_id;//订单号
@property (nonatomic, strong) NSString <Optional>*type;//1配送成功 2配送异常
@property (nonatomic, strong) NSString <Optional>*sign_type;//1配送成功 2配送异常

@property (nonatomic, strong) NSString <Optional>*sign_man;//签收人
@property (nonatomic, strong) NSString <Optional>*expt_code;//配送异常编码（参考17）
@property (nonatomic, strong) NSString <Optional>*expt_msg;//配送异常原因（参考17）
@property (nonatomic, strong) NSString <Optional>*next_delivery_time;//下次配送时间
@end

//返回通用的Model

#pragma mark-----------------推送通知开关---------------------
//返回通用的Model

#pragma mark ----------------申请提现借口---------------------
@interface In_applyForMoneyModel: JSONModel

@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*alipay_account;
//提现支付宝账号
@property (nonatomic, strong) NSString <Optional>*withdraw_amount;//提现金额
@property (nonatomic, strong) NSString <Optional>*type;//0配送收入提现  1信用金提现 (v2新增非必选 默认为0)
@end

//返回通用Model

#pragma mark--------------历史订单---------------------

@interface In_historyOrderModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;

@property (nonatomic, strong) NSString <Optional>*offset;//分页起始值（默认0）
@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小（默认10）
@property (nonatomic, strong) NSString <Optional>*type;//账单类型 1达人账单 2充值
@end

@interface Out_historyOrderBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*status;//1配送成功 2配送异常
@property (nonatomic, strong) NSString <Optional>*income;//收入

@property (nonatomic, strong) NSString <Optional>*order_id;//订单号
//@property (nonatomic, strong) NSString <Optional>*date;//交易日期

@end

@interface Out_historyOrderModel: JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_historyOrderBody <Optional>*data;

@end


#pragma mark---------------账单流水-----------------
//******输入参数为In_historyOrderModel*******


@interface Out_billStreamBody: JSONModel

@property (nonatomic, strong) NSString <Optional>*trade_amount;//流水金额
@property (nonatomic, strong) NSString <Optional>*trade_desc;//交易描述

@property (nonatomic, strong) NSString <Optional>*trade_time;//交易时间
@property (nonatomic, strong) NSString <Optional>*month;//账单月份
@property (nonatomic, strong) NSString <Optional>*trade_no;//流水号
@property (nonatomic, strong) NSString <Optional>*status;//充值状态 1成功 2失败
@end

@interface Out_billStreamModel: JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_billStreamBody <Optional>*data;

@end

#pragma mark -------------修改绑定手机号
@interface In_changePhoneModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*header;//接收短信的手机号码
@property (nonatomic, strong) NSString <Optional>*mobile;//	string	原绑定手机号码
@property (nonatomic, strong) NSString <Optional>*newmobile	;//string	新绑定手机号码
@property (nonatomic, strong) NSString <Optional>*code	;//string	验证码
@end

#pragma mark ------------用户反馈--------------
@interface In_opinionBackModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;

@property (nonatomic, strong) NSString <Optional>*suggestion_text;//反馈内容
@property (nonatomic, strong) NSString <Optional>*suggestion_version;//当前版本
@property(nonatomic,assign)int suggestion_source;//0 android 1 ios
@end

#pragma mark -----------我的钱包
@interface In_myWalletModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*user_type;//需求id
@property (nonatomic, strong) NSString <Optional>*offset;//分页起始值（默认0）
@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小（默认10）
@end

@interface Out_myWalletBody: JSONModel

@property (nonatomic, strong) NSString <Optional>*deposit;//押金金额
@property (nonatomic, strong) NSString <Optional>*max_withdraw_amount;//最多可提现金额
@end
@interface Out_myWalletModel: JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) Out_myWalletBody <Optional>*data;

@end

#pragma mark -----------生成支付订单
@interface In_payWalletModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*trade_amount;//支付宝交易金额
@property (nonatomic, strong) NSString <Optional>*reduced_amount;//平台账号扣取金额
@property (nonatomic, strong) NSString <Optional>*trade_way;//交易方式 1支付宝 2支付宝+余额
@property (nonatomic, strong) NSString <Optional>*trade_type;//交易类型 1收入 2提现 3交押金 4交罚金 5平台服务费 6发单缴费
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id trade_type 为6时必选
@property (nonatomic, strong) NSString <Optional>*order_id;//订单号，非必选可以为空
@end

@interface Out_payWalletBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*pay_order_id;//支付订单号
@property (nonatomic, strong) NSString <Optional>*notify_url;//支付回调地址
@property (nonatomic, strong) NSString <Optional>*ali_public_key;//支付宝的公钥，无需修改该值
@property (nonatomic, strong) NSString <Optional>*private_key;//商户的私钥
@property (nonatomic, strong) NSString <Optional>*appid;//appid
@property (nonatomic, strong) NSString <Optional>*seller;//收款方
@property (nonatomic, strong) NSString <Optional>*partner;//合作身份者ID，以2088开头由16位纯数字组成的字符串
@property (nonatomic,strong) NSString <Optional> *productName;//支付商品标题
@property (nonatomic,strong) NSString <Optional> *productDescription;//支付商品描述
@end
@interface Out_payWalletModel: JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong)Out_payWalletBody <Optional>*data;
@end

@interface In_payResultModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*pay_order_id;//支付订单号
@end

@interface Out_payResultBody:JSONModel
@property (nonatomic, strong) NSString <Optional>*pay_order_id;//支付订单号
@property (nonatomic, strong) NSString <Optional>*status;//支付状态，0：未支付，1：支付成功 2：支付失败
@end

@interface Out_payResultModel:JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong)Out_payResultBody <Optional>*data;

@end

#pragma mark -----------分拣界面接口-------------
@interface In_sortModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString<Optional>*telephone;//模糊查询手机号码
@end

@interface Out_sortModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*building_no;//楼栋号
@property (nonatomic, strong) NSString <Optional>*recipient_mobile;//手机号

@end


#pragma mark -----------短信列表-------详情------
@interface In_msgListModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString<Optional>*keyWords;//模糊查询关键字
@property (nonatomic, strong) NSString <Optional>*message_id;//短信id(用于详情接口)
@property (nonatomic, strong) NSString <Optional>*issend;//查询发送失败传值为2，默认不传显示全部
@property (nonatomic, strong) NSString <Optional>*offset;
@property (nonatomic, strong) NSString <Optional>*page_size;
@property (nonatomic, strong) NSString <Optional>*mobile;

@end

@interface out_msgModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*mobile;//收件人手机号
@property (nonatomic, strong) NSString <Optional>*createtime;//短信发送时间
@property (nonatomic, strong) NSString<Optional>*messagetext;//duanx短信内容
@property (nonatomic, strong) NSString<Optional>*isRead;//是否已读  0未读 1已读
@property (nonatomic, strong) NSString<Optional>*isSend;//是否发送成功与否 1=成功，0=失败
@property (nonatomic, strong) NSString<Optional>*recipient_mobile;//短信接受者
@end

#pragma mark ---------发送短信

@interface in_sendMsgModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString<Optional>*recipientMobile;//收信人手机号
@property (nonatomic, strong) NSString<Optional>*messagetext;//短信内容
@property (nonatomic, strong) NSString<Optional>*countNum;//发送短信的条数
@property (nonatomic, strong) NSString<Optional>*smstemplateId;//false 使用模板的id，没有则为0
@end



#pragma mark ---------短信模板

@interface msgViewModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*smstemplateId;//模板id
@property (nonatomic, strong) NSString <Optional>*content;//模板内容
@end



