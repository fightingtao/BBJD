//
//  UnusualReasonListController.h
//  BBJD
//
//  Created by 李志明 on 16/8/30.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"

@protocol problemBackDelegate <NSObject>
-(void)problemBack;
@end

@interface UnusualReasonListController : UIViewController
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,assign)int type;//配送状态  1,成功 2配送异常
@property(nonatomic,assign) int reasonKind;//1.滞留 2.拒收
@property(nonatomic,weak)id <problemBackDelegate> delegate;
@end
