//
//  NewModelViewModel.m
//  BBJD
//
//  Created by 李志明 on 17/3/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "NewModelViewModel.h"

@implementation NewModelViewModel

-(instancetype)init{
  self =  [super init];
    if (self) {
        [self initModel];
    }
    return self;
}

-(void)initModel{

    self.checkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:input];
        NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
        [indic setObject:userInfoModel.key forKey:@"key"];
        [indic setObject:hmacString forKey:@"digest"];
        [indic setObject:input[0] forKey:@"type"];
        [indic setObject:input[1] forKey:@"content"];
        NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/addsmstemplate",kUrlTest];
        RACSignal *signal = [BBJDRequestManger postWithURL:url withParamater:indic];
        
        [signal subscribeNext:^(id x) {
             [ZJCustomHud dismiss];
            if ([x isKindOfClass:[NSError class]]) {
              
                [[KNToast shareToast] initWithText:@"网络异常！" duration:2 offSetY:(SCREEN_HEIGHT-200)];
            }else{
                [[KNToast shareToast] initWithText:@"已提交审核，将在3个工作日内反馈审核结果!" duration:3 offSetY:(SCREEN_HEIGHT-200)];
            }
        }];
        return signal;
    }];
  
}
@end
