//
//  publicResource.h
//  Shipper
//
//  Created by xc on 15/9/7.
//  Copyright (c) 2015年 xc. All rights reserved.
//

//#ifndef Shipper_publicResource_h
//#define Shipper_publicResource_h
//
//
//#endif
/*!
 *   @author XC, 15-09-07 18:09:14
 *
 *   @brief  主要存放公共参数及固定参数
 *
 *   @since 1。0
 */

/*  版本上线检查事项
 1.网络开发ip地址的修改;
 2.极光推送的生产环境;
 3.版本号的修改;
 4.
 */
#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif

#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

//屏幕宽度和高度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//worktextcolor
#define kTextWorkCOLOR [UIColor colorWithRed:0.5843 green:0.4824 blue:0.7176 alpha:1.0]

//主色调(紫色）
#define MAINCOLOR [UIColor colorWithRed:0.2471 green:0.1137 blue:0.3922 alpha:1.0]

//textmaincolor(白色)
#define TextMainCOLOR [UIColor colorWithRed:0.9647 green:0.9608 blue:0.9725 alpha:1.0]

#define kTextMainCOLOR  [UIColor grayColor]
//textmaincolor(红色)
#define kTextRedCOLOR [UIColor redColor]
//textmaincolor(黑色）
#define kTextBlackCOLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
//占位文字颜色
#define TextPlaceholderCOLOR [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0]


//textdetailcolor
#define TextDetailCOLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]

//textdetailcolor
#define OrderTextCOLOR [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]

#define ButtonBGCOLOR [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]

//view背景色
#define ViewBgColor   [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]
#define WHITECOLOR  [UIColor whiteColor]
#define LineColor   [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]

#define WhiteBgColor  [UIColor whiteColor]

#define DaiSongColor  [UIColor colorWithRed:255.0/255.0 green:157.0/255.0 blue:44.0/255.0 alpha:1]
#define DaiGouColor  [UIColor colorWithRed:57.0/255.0 green:173.0/255.0 blue:54.0/255.0 alpha:1]
#define DaiBanColor  [UIColor colorWithRed:27.0/255.0 green:107.0/255.0 blue:165.0/255.0 alpha:1]
#define lableFrame CGRectMake(0, 0,200, 20)

#define HT_LAZY(object, assignment) (object = object ?: assignment)
///版本号
#define kVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//邦办即达 地址
//#ifdef RELEASE
// #define kUrlTest @"http://www.bangbanjida.com"   // W 生产
//#endif
//#ifdef DEBUG
//#define kUrlTest @"http://192.168.13.246:8082"// Y 内网 姜晓亮
//#define  kUrlTest @"http://192.168.13.244:8082" // 李月
//#define kUrlTest @"http://121.41.114.230:8082"//阿里云测试
//#define kUrlTest @"http://192.168.13.247:8082"// 韦永华
#define kUrlTest @"http://192.168.13.245:8082"//孙琪珍
//#endif
//#define kUrlTest [NSString stringWithFormat:@"http://%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"]]

#define PLACEHOLDERIMG @"home_def_head-portrait" //占位图
#define PlaceHoldHeadImg(a) [UIImage imageNamed:a]

//未读短信条数
#define kNoRead @"noRead"
//字体
#define LargeFont   [UIFont systemFontOfSize:18.0]
#define kTextFont16   [UIFont systemFontOfSize:16.0]
#define MiddleFont   [UIFont systemFontOfSize:15.0]
#define LittleFont   [UIFont systemFontOfSize:15.0]
#define WideFont [UIFont fontWithName:@"Helvetica-Bold" size:15.0]
//推送
#define PushNotifyName   @"Push"
#import "UIView+SDAutoLayout.h"
#import "iToast.h"
//#import "communcation.h"
#import "MBProgressHUD.h"
//#import "AFNetworking.h"
#import "communcat.h"
#import "CustomAlertView.h"//自定义AlertView
#import "UIBarButtonItem+CBELExtension.h"
#import "UIView+extension.h"
#import "noConnetView.h"//无网络状态
//#import <tingyunApp/NBSAppAgent.h>//听云
#import "MJRefresh.h"

#import "CustomAlertView.h"//自定义弹出框
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "UIView+WZLBadge.h"//显示数量
#import "WZLBadgeProtocol.h"
#import "KNToast.h"
#import "UIImageView+WebCache.h"
#import "navLabel.h"
#import "ZJCustomHud.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BBJDRequestManger.h"

