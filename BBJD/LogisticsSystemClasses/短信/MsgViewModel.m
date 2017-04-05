//
//  MsgViewModel.m
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "MsgViewModel.h"
#import "MsgTableView.h"
#import "NewModelViewController.h"
#import "oneMessageVC.h"

@implementation MsgViewModel
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initViewModel];
    }
    return self;
}

-(void)initViewModel{
    //加载数据
    self.loadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
        NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
        [indic setObject:userInfoModel.key forKey:@"key"];
        [indic setObject:hmacString forKey:@"digest"];
        NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/message/getSmstemplatelist",kUrlTest];
        RACSignal *signal = [BBJDRequestManger postWithURL:url withParamater:indic];
        
        [signal subscribeNext:^(id x) {
            if ([x isKindOfClass:[NSError class]]) {
                [[KNToast shareToast] initWithText:@"网络异常！" duration:2 offSetY:(SCREEN_HEIGHT-360)];
                
            }else{
             DLog(@"data %@",x);
                NSDictionary *dic=x;
                int code=[dic[@"code"] intValue];
                if (code==1000){
                    MsgTableView   *msgView = input[0];
                    noConnetView *noDataView=input[1];
                     NSArray *result = dic[@"data"];
                    if (result.count>0&&result) {
                       
                        for (NSDictionary *dict in result) {
                            if ([[dict allKeys] count]>0){
                                
                                if (![self.dataList containsObject:dict]){
                                    [self.dataList addObject:dict];

                                }
                            }
                        }
                        if (self.dataList.count==0) {
                            noDataView.hidden=NO;
                            msgView.tableView.hidden=YES;
                            
                        }
                        else{
                            noDataView.hidden=YES;
                            msgView.tableView.hidden=NO;
                            [msgView.tableView reloadData];

                        }
                    }
                   
                }
                else{
                    [[KNToast shareToast] initWithText:x[@"message"] duration:2 offSetY:(SCREEN_HEIGHT-360)];

                }

                }
                   }];
        return signal;
    }];
    
    self.btnCommoand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIViewController *vc = (UIViewController*)input;
        NewModelViewController *newVC = [[NewModelViewController alloc] init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionReveal;
        [vc.navigationController.view.layer addAnimation:transition forKey:nil];
        [vc.navigationController pushViewController:newVC animated:YES];
        return [RACSignal empty];
    }];
    
}


-(NSMutableArray*)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
