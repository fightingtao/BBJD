//
//  ResultViewController.h
//  BBJD
//
//  Created by 李志明 on 17/2/24.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@interface ResultViewController : UIViewController
@property(nonatomic,assign)BOOL success;
@property(nonatomic,assign)double trade_amont;
@property (nonatomic,strong)Out_payWalletBody *model;
-(void)returnResult;

@end
