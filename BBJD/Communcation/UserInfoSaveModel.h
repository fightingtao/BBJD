//
//  UserInfoSaveModel.h
//  Shipper
//
//  Created by xc on 15/9/12.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UserKey  @"UserInfo"


/**
 *  登录后，序列化一些身份相关信息
 */
@interface UserInfoSaveModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *primary_key;//string	秘钥（每次调用接口时加密使用）
@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *city_name;//string	工作城市
@property (nonatomic, strong) NSString *tag;//	string	极光推送标签
@property (nonatomic,copy) NSString * driver_license;//	string	机动车驾照
@property (nonatomic,copy) NSString *  vehicle	;//string	交通工具
@property (nonatomic,copy) NSString * dominate_time	;//string	可支配时间
@property (nonatomic,copy) NSString * opposite_idcard;//	string	身份证反面照
@property (nonatomic,copy) NSString * idcardno	;//string	身份证号码
@property (nonatomic,copy) NSString *level	;//int	用户等级
@property (nonatomic,copy) NSString * emergency_contact_mobile	;//string	紧急联系人手机号码
@property (nonatomic,copy) NSString * gender	;//int	性别 0女 1男
@property (nonatomic,copy) NSString *is_payed	;//int	是否交付押金 1已交 0未交
@property (nonatomic,copy) NSString * seller_id	;//int	站点id
@property (nonatomic,copy) NSString * apliy_account	;//string	绑定的支付宝账号
@property (nonatomic,copy) NSString * intention_delivery_area;//	string	意向配送区域
@property (nonatomic,copy) NSString *status	;//int	0启用（未分配到站） 1工作中（分配到站）
@property (nonatomic,copy) NSString *  nickname;//	string	昵称
@property (nonatomic,copy) NSString *user_type	;//int	用户类型 0邦办达人 1站长 2HR 3财务 4管理员
@property (nonatomic,copy) NSString * emergency_contact_name	;//string	紧急联系人姓名
@property (nonatomic,copy) NSString * user_status;//	string	账号状态 1启用 0禁用
@property (nonatomic,copy) NSString * positive_idcard;//	string	身份证正面照
@property (nonatomic,copy) NSString * authen_status	;//string	邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
@property (nonatomic,copy) NSString * header	;//string	用户头像地址
@property (nonatomic,copy) NSString * point	;//int	用户当前积分
@property (nonatomic,copy) NSString * realname;//	string	真实姓名
@property (nonatomic,copy) NSString *  hand_idcard	;//string	身份证手持照
@property (nonatomic,copy) NSString * telephone	;//string	手机号码
@property (nonatomic,copy) NSString *    notify_switch;//	string	on接收通知 off不接收通知
@property (nonatomic,copy) NSString *   frozen_days	;//int	账号冻结天数
@property (nonatomic,copy) NSString *   frozen_type	;//int	惩罚类型 0揽件超时 1配送超时 2服务类/操作类投诉 3态度恶劣投诉


@end
