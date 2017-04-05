//
//  depositVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "depositVController.h"
#import "publicResource.h"
//#import "billVController.h"

@interface depositVController ()
{
    NSInteger _type;//0配送收入提现 1信用金提现 (v2新增非必选 默认为0)
}
 
@end

@implementation depositVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _type = 0;
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"申请提现"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    

    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    _alipy.enabled = NO;
    _alipy.text = userInfoModel.apliy_account;
    
    [self getMaxMoney];
   

}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取最大提现金额信息
-(void)getMaxMoney{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
   UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]getMaxMoneykey:userInfoModel.key degist:hmac resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *data = [dic objectForKey:@"data"];
            
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }
                else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                     _maxMoney.text=[NSString stringWithFormat:@"¥%.2f元",[[data objectForKey:@"max_withdraw_amount"] floatValue]];
                    
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                }
                
            } );
            
        }];
    });
}

- (IBAction)onCommitClick:(id)sender {
 
    [self commitMoney];
}


#pragma mark 提交提现
-(void)commitMoney{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    if ([_alipy.text isEqualToString:@""] || _alipy.text.length==0) {
        
        return;
    }
    if ([_money.text isEqualToString:@""] || _money.text.length==0||!_money) {
        [[iToast makeText:@"请输入提现金额"]show];
        return;
    }

    int money=[_money.text intValue];
   
    if (money < 3) {
        [[iToast makeText:@"提现金额不能小于3"] show];
        return;
    }
    
    if (money > 2000) {
        [[iToast makeText:@"提现金额不能大于2000"]show];

        return;
    }

    NSArray *array=[[NSArray alloc]initWithObjects:_alipy.text,_money.text,[NSString stringWithFormat:@"%ld",_type], nil];
    NSString *hmac=[[communcat sharedInstance ]ArrayCompareAndHMac:array];
    
    In_applyForMoneyModel *inModel=[[In_applyForMoneyModel alloc]init];
    inModel.key=userInfoModel.key;
    inModel.digest=hmac;
    inModel.alipay_account=_alipy.text;
    inModel.withdraw_amount=_money.text;
    inModel.type = [NSString stringWithFormat:@"%ld",_type];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [[communcat sharedInstance]getApplyForMoneyModelInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                NSDictionary *data = [dic objectForKey:@"data"];
                
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                     [[iToast makeText:@"恭喜您,提现成功!我们将在两个工作日内"] show];

                    [self getMaxMoney];
                    [self performSelector:@selector(backRootview) withObject:nil afterDelay:1.0];
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
 
                }
                
            } );
            
        }];
    });
}
-(void)backRootview{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
