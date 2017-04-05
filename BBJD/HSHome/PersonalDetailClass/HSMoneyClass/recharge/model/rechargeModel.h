//
//  rechargeModel.h
//  BBJD
//
//  Created by cbwl on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "publicResource.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "creacteOrderModel.h"
@interface rechargeModel : NSObject
//
//@property (nonatomic,copy)NSString *notify_url;
//@property (nonatomic,copy)NSString *pay_order_id;

-(void)AlipayWithInModel:(Out_payWalletBody *)model result:(void (^)(BOOL result))result;//支付宝支付
-(void)creacteOrderIdWithModel:(creacteOrderModel *)model btnCan:(void (^)(BOOL isCan))can returnAlipayInModel:(void (^)(Out_payWalletBody *backModel))backModel ;//生成支付订单
@end
