//
//  InputPwdViewController.h
//  CYZhongBao
//
//  Created by xc on 15/12/15.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iToast.h"
#import "IQKeyboardManager.h"
#import "publicResource.h"

@protocol InputPwdDelegate <NSObject>

- (void)cancelInputPwd;
- (void)passwordInputWithPWd:(NSString*)pwd;
- (void)forgetPassword;

@end

@interface InputPwdViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) id<InputPwdDelegate>delegate;
@property (nonatomic, strong) UITextField *topTX;

///密码错误
- (void)pwdWrong;
@end
