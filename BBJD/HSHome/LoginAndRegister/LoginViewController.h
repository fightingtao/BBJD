//
//  LoginViewController.h
//  CYZhongBao
//
//  Created by xc on 15/11/30.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
//#import "communcation.h"
#import "UserInfoSaveModel.h"
#import "AppDelegate.h"

#import "iToast.h"
#import "MBProgressHUD.h"
#import "coreDataManger.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>

-(void)upDataUserMag;
@end
