//
//  PunishViewController.h
//  BBJD
//
//  Created by cbwl on 16/9/22.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface PunishViewController : UIViewController
-(void)getPayInfor;//生成支付订单

@end
