//
//  binDingVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/18.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "binDingVController.h"
#import "publicResource.h"
#import "LoginViewController.h"

@interface binDingVController ()<UIGestureRecognizerDelegate>
 @property(nonatomic,strong)LoginViewController *loginView;

@end

@implementation binDingVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色

 
     self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"绑定手机号"];

    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self creactRightGesture];
}
#pragma mark 右滑返回上一级_________
///右滑返回上一级
-(void)creactRightGesture{
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
-(void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)pan{
    [self leftItemClick];
}

- (IBAction)onSendCodeClick:(id)sender {
    [_textPhone resignFirstResponder];
    [_textCode resignFirstResponder];
    
    if (_textPhone.text.length == 0) {
    
        [[iToast makeText:@"请输入手机号"] show];
        return;
    }
    if (![[communcat sharedInstance]checkTel:_textPhone.text]) {
        return;
    }
    [self startCodeTime];
    [self sendCodeWithPhone:_textPhone.text];
    
}

//发送验证码倒计时
- (void)startCodeTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                _btnCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnCode setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                _btnCode.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)onButtonSureClick:(id)sender {
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array=[[NSArray alloc]initWithObjects:@"",_textPhone.text,_textCode.text,userInfoModel.telephone, nil];
    NSString *hmac=[[communcat sharedInstance ]ArrayCompareAndHMac:array];
    
    In_changePhoneModel *inModel=[[In_changePhoneModel alloc]init];
    inModel.key=userInfoModel.key;
    inModel.digest=hmac;
    inModel.header=@"";
    inModel.mobile=userInfoModel.telephone;
    inModel.newmobile=_textPhone.text;
    inModel.code=_textCode.text;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]changePersonerPhoneWith:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }
                else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                 
                    [[iToast makeText:@"手机号更换成功!"]show];

                    [self leftItemClick];
                    
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
                
            } );
            
        }];
    });
}

-(void)sendCodeWithPhone:(NSString *)phone{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    if ([userInfoModel.telephone isEqualToString:_textPhone.text]) {
        [[iToast makeText:@"该手机号与当前手机号相同,请更换!"]show];
        return;
    }
    NSString *hmac=[[communcat sharedInstance ]hmac:phone withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] changePersonerPhoneMsgWithkey:userInfoModel.key   degist:hmac  phone:phone resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    
                    
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
                
            } );
            
        }];
    });
    
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}

@end
