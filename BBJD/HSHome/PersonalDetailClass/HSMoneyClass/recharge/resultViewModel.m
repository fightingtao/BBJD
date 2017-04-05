//
//  resultViewModel.m
//  BBJD
//
//  Created by 李志明 on 17/3/28.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "resultViewModel.h"

@implementation resultViewModel
-(instancetype)init{
    self = [super init];
    if (self) {
        [self bingModel];
    }
    return self;
}

-(void)bingModel{
    //创建命令
    self.resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *hmacString = [[communcat sharedInstance] hmac:input withKey:userInfoModel.primary_key];
        NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
        [indic setObject:userInfoModel.key forKey:@"key"];
        [indic setObject:hmacString forKey:@"digest"];
        [indic setObject:input forKey:@"pay_order_id"];
        NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/modify/order",kUrlTest];
        RACSignal *signal = [BBJDRequestManger postWithURL:url withParamater:indic];
        [signal subscribeNext:^(id x) {
            
            

        }];
        return signal;
    }];
}

@end
