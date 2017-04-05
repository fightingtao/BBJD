//
//  HomePageViewController.h
//  CYZhongBao
//
//  Created by xc on 15/11/5.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "communcat.h"
//#import "UIButton+WebCache.h"
typedef NS_ENUM(NSInteger, UserType)//用户类型
{
    UserType_Customer,//用户类型-雇主
    UserType_Broker,//用户类型-经纪人
};


@interface HomePageViewController : UIViewController

@property (nonatomic, assign) UserType type;//当前用户类型
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UIButton *customerBtn;//选择雇主button
@property (nonatomic, strong) UIButton *brokerBtn;//选择经纪人button
@property (nonatomic, strong) UIButton *workBtn;//选择经纪人button
@property (nonatomic, strong) UIView *cContentView;//雇主内容view
@property (nonatomic, strong) UIView *bContentView;//经纪人内容view
@end
