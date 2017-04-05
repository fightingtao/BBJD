//
//  AppDelegate.h
//  BBJD
//
//  Created by cbwl on 16/12/25.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Reachability.h"
#import "iToast.h"
#import "publicResource.h"
#import "XQNewFeatureVC.h"
#import "IQKeyboardManager.h"

#import "UserInfoSaveModel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import <TAESDK/TaeSDK.h>
#import "JPUSHService.h"

#import "HomePageViewController.h"

#import "WorkVController.h"
#import "personerVController.h"
#import "RootViewController.h"
#import "certifyViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate,WXApiDelegate>
{
    //    Reachability  *hostReach;
    BMKMapManager* _mapManager;
    BMKLocationService* _locService;
    UIAlertView *AlertViewOne;
    UIAlertView *AlertViewTwo;
    UIAlertView *AlertViewThree;
    NSString *_orderId;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) HomePageViewController *homePageVC;
@property (nonatomic, strong) WorkVController *workVC;
@property (nonatomic, strong) personerVController *personVC;
@property (nonatomic, strong) UITabBarController *tabBarController ;
@property (nonatomic, strong) NSString *staticCity;
@property (nonatomic, strong) NSString *staticAddress;
@property (nonatomic,strong) BMKGeoCodeSearch *bmGeoCodeSearch ;
@property CGFloat staticlng;
@property CGFloat staticlat;

@end

