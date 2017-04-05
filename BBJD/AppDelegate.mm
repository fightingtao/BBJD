//
//  AppDelegate.m
//  BBJD
//
//  Created by cbwl on 16/12/25.
//  Copyright © 2016年 CYT. All rights reserved.
//


#import "AppDelegate.h"
#import "UMSocial.h"
#import <AlipaySDK/AlipaySDK.h>

#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMMobClick/MobClick.h"//友盟统计

#import "FirstUseViewController.h"
#import "LoginViewController.h"
#import "JKNotifier.h"
#import <AVFoundation/AVFoundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<btnActionDelegate>
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;
@property (nonatomic,strong)UIAlertView *alertV;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor clearColor];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        FirstUseViewController *vc = [[FirstUseViewController alloc] init];
        vc.delegate = self;
        self.window.rootViewController = vc;
    }else {
        
        RootViewController *vc = [[RootViewController alloc] init];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [NSThread sleepForTimeInterval:1.5];
    
    //调用键盘方法start
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:0];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //网络检测
    //        [[NSNotificationCenter defaultCenter] addObserver:self
    //                                                 selector:@selector(netChanged:)
    //                                                     name: kReachabilityChangedNotification
    //                                                   object: nil];
    //        hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //        [hostReach startNotifier];
    
    
    //阿里百川
    [[TaeSDK sharedInstance] setDebugLogOpen:NO];
    //sdk初始化
    [[TaeSDK sharedInstance] asyncInit:^{
        NSLog(@"初始化成功");
    } failedCallback:^(NSError *error) {
        NSLog(@"初始化失败:%@",error);
    }];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
//#ifdef RELEASE
//    [JPUSHService setupWithOption:launchOptions
//     appKey:@"d93487bb49d666add2e70489" channel:@"Test"
//     apsForProduction:NO advertisingIdentifier:nil];//生产
    
//#endif
//    
//#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions
            appKey:@"851ad27297f2586c3ed8fb22" channel:@"Test"
                 apsForProduction:NO advertisingIdentifier:nil];//本地测试开发
//#endif
    
#pragma mark ------------------分享集成-----------------
    //集成友盟SDK
    [UMSocialData setAppKey:@"57a7e979e0f55a4799001320"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx6faa47b796342795" appSecret:@"03d191316532d13dc22a127f09a7bb16" url:@"https://itunes.apple.com/cn/app/%E9%82%A6%E5%8A%9E%E5%8D%B3%E8%BE%BE/id1150393685?mt=8"];
    //  db426a9829e4b49a0dcac7b4162da6b6
    //    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    //    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3238823136"  secret:@"8e40afe628ee43c5dd8d9e08635fd4c2"  RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    	//584f8ddd82b63548e4000e36
    UMConfigInstance.appKey = @"57a7e979e0f55a4799001320";
     UMConfigInstance.channelId = @"App Store";
     //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
     [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
     [MobClick setAppVersion:version];
     
     [MobClick setLogEnabled:YES];
    
    
    //集成百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"vTnxu5uU9RmAqoRyUtkvAfyAiSzHazTB"  generalDelegate:self];
    if (!ret) {
        DLog(@"baidu manager start failed!");
    }
    
    //执行定位功能
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            [self locationClick];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前定位不可用，请检查设置中是否打开定位服务?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"设置", nil];
        [alert show];
    }

    return YES;
}

-(void)goToMainView{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"cube";//吸入
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    RootViewController *vc = [[RootViewController alloc] init];
    self.window.rootViewController = vc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//程序进入后台模式
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushResult:) name:PushNotifyName object:nil];//接收通知
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self locationClick];
    [JPUSHService setBadge:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

//获取DeviceToken成功
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //这里进行的操作，是将Device Token发送到服务端
    [JPUSHService registerDeviceToken:deviceToken];
    
}

//网络发生变化时处理
- (void)netChanged:(NSNotification *)note
{
    //    Reachability *currReach = [note object];
    //    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //    NetworkStatus status = [currReach currentReachabilityStatus];
    //    if(status == NotReachable)
    //    {
    //        [[iToast makeText:@"当前没有网络连接!请检查网络!"] show];
    //        return;
    //
    //    }
    //    if(status == kReachableViaWiFi)
    //    {
    ////        [[iToast makeText:@"当前为WIFI网络!"] show];
    //        return;
    //
    //    }
    //    if(status == kReachableViaWWAN)
    //    {
    //        [[iToast makeText:@"当前为2G/3G/4G网络!"] show];
    //        return;
    //
    //    }
}


/*!
 *   @author XC, 15-08-06 10:08:23
 *
 *   @brief  百度地图代理
 *
 *   @param iError 代理处理
 *
 *   @since 1.0
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
#pragma mark -------------定位---------------------
//定位
- (void)locationClick
{
    //初始化BMKLocationService
    if (!_locService){
        _locService = [[BMKLocationService alloc]init];
    }
    _locService.delegate = self;
    //    _locService.distanceFilter =10.0;
    _locService.desiredAccuracy =kCLLocationAccuracyBest;
    
    //启动LocationService
    [_locService startUserLocationService];
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    
    _staticlat = userLocation.location.coordinate.latitude;
    _staticlng = userLocation.location.coordinate.longitude;
    if (!_bmGeoCodeSearch) {
        _bmGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        
    }
    _bmGeoCodeSearch.delegate = self;
    
    BMKReverseGeoCodeOption *bmOp = [[BMKReverseGeoCodeOption alloc] init];
    bmOp.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL geoCodeOk = [_bmGeoCodeSearch reverseGeoCode:bmOp];
    if (geoCodeOk) {
        NSLog(@"ok");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKAddressComponent *city = result.addressDetail;
    _staticCity = city.city;
    if ([result.poiList count] > 0) {
        BMKPoiInfo *tempAddress = [result.poiList objectAtIndex:0];
        
        _staticAddress = tempAddress.address;
    }else
    {
        _staticAddress = result.address;
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [[iToast makeText:@"定位失败，请检查是否打开定位服务!"] show];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}


- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSNotification *notification = [NSNotification notificationWithName:PushNotifyName object:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSNotification *notification = [NSNotification notificationWithName:PushNotifyName object:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

// NOTE: 9.0以后使用新API接口 支付宝
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000){
//
//                certifyViewController *vc = [[certifyViewController alloc] init];
//                [vc afterAlipayCreateOrderWithOrderId];
//
//            }else{
//
//                CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"用户提示:\n支付宝充值失败,是否继续支付" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
//                    if (clickIndex == 200) {
//
//                    }
//                    [alertView showLXAlertView];
//                }];
//            }
//
//        }];
//    }
//    return YES;
//}

#pragma mark   支付宝配置信息
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 微信
    [WXApi handleOpenURL:url delegate:self];
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            ;
            DLog(@"支付宝--结果---%@ ",resultDic);
            if (![resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
               
                [[NSNotificationCenter defaultCenter] postNotificationName:@"noAlipay" object:[NSString stringWithFormat:@"%@",resultDic[@"memo"]]];
            
            }
            else if ( [resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSArray *result=[resultDic[@"result"] componentsSeparatedByString:@"&"] ;
                NSArray *out_trade_no=[result[2] componentsSeparatedByString:@"="] ;
                _orderId =[[out_trade_no lastObject] substringWithRange:NSMakeRange(1, [[out_trade_no lastObject] length]-2)];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alipay" object:_orderId];
            }
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
            
            if (![resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",resultDic[@"memo"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alert show];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noAlipay" object:[NSString stringWithFormat:@"%@",resultDic[@"memo"]]];
            }
            else{
                
                NSArray *result=[resultDic[@"result"] componentsSeparatedByString:@"&"] ;
                
                NSArray *out_trade_no=[result[2] componentsSeparatedByString:@"="] ;
                
                _orderId = [[out_trade_no lastObject] substringWithRange:NSMakeRange(1, [[out_trade_no lastObject] length]-2)];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alipay" object:_orderId];
            }
        }];
    }
    return YES;
}


- (void)onResp:(BaseResp *)resp
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    if ([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode){
            case WXSuccess:{
                
                AlertViewOne = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [AlertViewOne show];
            }
                break;
            case WXErrCodeCommon:{
                //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                //strMsg = [NSString stringWithFormat:@"错误码ErrCode>>>>>>>%d,错误字符串ErrStr>>>>>>>>%@",resp.errCode,resp.errStr];
                AlertViewTwo = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信支付失败,是否重新支付" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [AlertViewTwo show];
                
            }
                break;
            case WXErrCodeUserCancel:{
                AlertViewThree = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信支付取消,是否重新支付" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [AlertViewThree show];
                
            }
                break;
            case WXErrCodeSentFail:{
                
            }
                break;
            case WXErrCodeUnsupport:{
                //微信不支持
                NSLog(@"微信不支持");
                
            }
                break;
            case WXErrCodeAuthDeny:{
                //授权失败
            }
                break;
            default:
                break;
                
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == AlertViewOne){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackVC" object:nil userInfo:@{@"code":@"1000"}];
    }
    else if (alertView == AlertViewTwo){
        if (buttonIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackVC" object:nil userInfo:@{@"code":@"1001"}];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChongZhiVC" object:nil userInfo:nil];
        }
        else{
            
        }
    }
    else if (alertView == AlertViewThree){
        if (buttonIndex ==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackVC" object:nil userInfo:@{@"code":@"1001"}];
        }else
        {
            
        }
    }
    else
    {
        if (buttonIndex == 0) {
            
        }
        
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
#pragma mark ----------
-(void)getAppStore{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getVerisonFromAppStoreWithResultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *data=[[dic objectForKey:@"results"] firstObject];
                
                ///AppStore最新的版本号
                NSString *version=[data objectForKey:@"version"];
                
                NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
                NSString * localVersion =[localDic objectForKey:@"CFBundleShortVersionString"] ;
                
                if (![localVersion isEqualToString: version])//如果本地版本比较低 证明要更新版本
                {
                    _alertV=[[UIAlertView alloc]initWithTitle:@"有更新了" message:@"感谢认真工作的你" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新喽", nil];
                    [_alertV show];
                }
            });
        }];
    });
}

//极光推送在后台时收到信息，更新数据
- (void)pushResult:(NSNotification *)notification{
    NSDictionary *object = notification.object;
    NSDictionary *aps = [object objectForKey:@"aps"];
    NSString *alertString = [aps objectForKey:@"alert"];
    NSString *showMessage= [NSString stringWithFormat:@"您有一条新消息:%@",alertString];
    [[[LoginViewController alloc] init] upDataUserMag];//更新用户信息
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:showMessage,@"message", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuiSong" object:nil userInfo:dict];
    [JKNotifier showNotifer:showMessage];
    [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
        [notifier dismiss];
    }];
}

@end
