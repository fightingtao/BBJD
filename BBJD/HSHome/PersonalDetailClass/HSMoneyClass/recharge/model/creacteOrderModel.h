//
//  creacteOrderModel.h
//  BBJD
//
//  Created by cbwl on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface creacteOrderModel : NSObject
//   ,[NSString stringWithFormat:@"%d",_],[NSString stringWithFormat:@"%d",_],[NSString stringWithFormat:@"%ld",_ ],[NSString stringWithFormat:@"%@",_order_id ],nil];
@property(nonatomic,assign)double trade_amount;
@property(nonatomic,assign)double reduced_amount;
@property (nonatomic,assign)int trade_way;
@property (nonatomic,assign)int trade_type;
@property (nonatomic,assign)NSInteger requirment_id;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *userInfoKey;
@end
