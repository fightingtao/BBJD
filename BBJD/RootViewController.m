//
//  RootViewController.m
//  CYZhongBao

//  Copyright © 2016年 xc. All rights reserved.
//

#import "RootViewController.h"
#import "HomePageViewController.h"
#import "personerVController.h"
#import "JKNotifier.h"
#import "publicResource.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ListDetails.h"//保存短信model
#import "coreDataManger.h"//保存短信coredatamodel

@interface RootViewController ()
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;
@end


@implementation RootViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
   
    HomePageViewController *homekVC = [[HomePageViewController alloc]init];
    [self addChildVc:homekVC  title:@"抢单" image:@"order" selectedImage:@"order_select" ];
    
   self.workVC= [[WorkVController alloc]init];
    [self addChildVc:self.workVC title:@"工作" image:@"work" selectedImage:@"work_select" ];
    
    personerVController *personerVC = [[personerVController alloc]init];
    
    [self addChildVc:personerVC title:@"我的" image:@"personer" selectedImage:@"personer_select" ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushResult:) name:PushNotifyName object:nil];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
//    if ([title isEqualToString:@"工作"]){
//      //  childVc.tabBarItem.badgeFont = [UIFont boldSystemFontOfSize:9];
//       // childVc.tabBarItem.badgeColor=[UIColor redColor];
//
//       // [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:kNoRead];
//        NSString *tmp=[[NSUserDefaults standardUserDefaults]objectForKey:kNoRead];
//        if([tmp intValue]<=0){
//            childVc.tabBarItem.badgeValue =nil;
//           //  childVc.tabBarItem.badgeValue =[[NSUserDefaults standardUserDefaults]objectForKey:kNoRead];
// 
//        }
//        else{
//         childVc.tabBarItem.badgeValue =[[NSUserDefaults standardUserDefaults]objectForKey:kNoRead];
//    }
//    }
  childVc.title = title;
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    //设置选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
    // 为子控制器包装导航控制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    
    UIColor *color = [UIColor colorWithRed:0.9882 green:0.9961 blue:0.9922 alpha:1.0];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    navigationVc.navigationBar.titleTextAttributes = dict;

    UIFont *font = [UIFont systemFontOfSize:18];
    
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    navigationVc.navigationBar.titleTextAttributes = dic;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [navigationVc.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [navigationVc.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

//极光推送消息展示
- (void)pushResult:(NSNotification *)notification{
    NSDictionary *object = notification.object;
    NSDictionary *aps = [object objectForKey:@"aps"];
    NSString *alertString = [aps objectForKey:@"alert"];
    NSString *showMessage= [NSString stringWithFormat:@"您有一条新消息:%@",alertString];
 
    [[[LoginViewController alloc] init] upDataUserMag] ;
   
    if (alertString.length > 9){
        NSString *sub = [alertString substringWithRange:NSMakeRange(0, 8)];
        
        NSString *shifang = [alertString substringWithRange:NSMakeRange(0, 6)];
        if ([sub containsString:@"您的认证已审核通"]) {
            [[[LoginViewController alloc]init] upDataUserMag] ;
            
        }else if ([sub containsString:@"您的认证审核失败"]) {
            [[[LoginViewController alloc]init] upDataUserMag] ;
            
            
        }else if ([sub containsString:@"您的账号1个月内"]) {
            [[[LoginViewController alloc] init] upDataUserMag] ;
         }
        if ([shifang containsString:@"原订单已取消"]) {
            [[[LoginViewController alloc]init] upDataUserMag] ;
        }
        
        if ([sub containsString:@"有新需求了，快去"]) {
            if(![self.avAudioPlayer isPlaying]){
            [self playAudio];
            }
        }
        if ([sub containsString:@"您有一条新短信"]){
  
            
            
            
            //将短信保存到本地
            ListDetails  *list=[[ListDetails  alloc]init];
            list.phone=@"18671536665";
            list.msgText=@"从极光推送[邦办即达]ssss dd关注邦办即达微信公众号;马上有好礼相送*_*";
            list.time=@"14:37";
            list.isRead=@"0";
            list.isSend=@"1";
            [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:list];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:showMessage,@"message", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuiSong" object:nil userInfo:dict];
    [JKNotifier showNotifer:showMessage];
    
    [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
        [notifier dismiss];
    }];
}


//-(void)changeNoReadNub:(NSNotification *)notification{
//    int  read = [[notification object] intValue];
//    if (read>0) {
//        [self.workVC.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",read]];
//
//    }
//}

#pragma mark 语音播放
-(void)playAudio{
    NSString *string = [[NSBundle mainBundle] pathForResource: @"neworder" ofType:@"wav"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    //    self.avAudioPlayer.delegate = self;
    
    //设置初始音量大小
    self.avAudioPlayer.volume = 1;
    
    //设置音乐播放次数  -1为一直循环
    self.avAudioPlayer.numberOfLoops = 0;
    
    //预播放
    [self.avAudioPlayer prepareToPlay];
    
    [self.avAudioPlayer play];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
