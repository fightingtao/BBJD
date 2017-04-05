//
//  InputPwdViewController.m
//  CYZhongBao
//
//  Created by xc on 15/12/15.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "InputPwdViewController.h"

@interface InputPwdViewController ()
{
    
    NSMutableArray *dataSource;
    
    NSString *_password;
}

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *forgetPwdBtn;

@end

@implementation InputPwdViewController
@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataSource = [[NSMutableArray alloc] init];
    
    _topTX = [[UITextField alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 40)];
    _topTX.hidden = YES;
    _topTX.keyboardType = UIKeyboardTypeNumberPad;
    _topTX.secureTextEntry = YES;
    [_topTX addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    
    //进入界面，topTX成为第一响应
    [_topTX becomeFirstResponder];
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"×" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(10,5,40,40);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:40];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelBtn];
    }
    
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _forgetPwdBtn.frame = CGRectMake(SCREEN_WIDTH - 100,120,80,40);
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPwdBtn addTarget:self action:@selector(forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetPwdBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (id obj in self.view.subviews)  {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField* theTextField = (UITextField*)obj;
            [theTextField removeFromSuperview];
        }
    }
    
    [dataSource removeAllObjects];
    
    for (int i = 0; i < 6; i++)
    {
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width-290)/2+i*50, 60, 40, 40)];
        pwdLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = YES;//设置密码模式
        pwdLabel.layer.borderWidth = 1;
        [self.view addSubview:pwdLabel];
        
        [dataSource addObject:pwdLabel];
    }
    [self.view addSubview:_topTX];
    _password = @"";
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [_topTX becomeFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
///密码错误
- (void)pwdWrong
{
    for (id obj in self.view.subviews)  {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField* theTextField = (UITextField*)obj;
            [theTextField removeFromSuperview];
        }
    }
    
    [dataSource removeAllObjects];
    
    for (int i = 0; i < 6; i++)
    {
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width-290)/2+i*50, 60, 40, 40)];
        pwdLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = YES;//设置密码模式
        pwdLabel.layer.borderWidth = 1;
        [self.view addSubview:pwdLabel];
        
        [dataSource addObject:pwdLabel];
    }
    [self.view addSubview:_topTX];
    _password = @"";
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [_topTX becomeFirstResponder];
    

}

- (void)txchange:(UITextField *)tx
{
    _password = tx.text;
    
    if (_password.length == dataSource.count)
    {
        [tx resignFirstResponder];//隐藏键盘
    }
    
    for (int i = 0; i < dataSource.count; i++)
    {
        UITextField *pwdtx = [dataSource objectAtIndex:i];
        if (i < _password.length)
        {
            NSString *pwd = [_password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
        else
        {
            pwdtx.text = @"";
        }
    }
    
    if (_password.length == 6)
    {
        
        [tx resignFirstResponder];//隐藏键盘
        [self.delegate passwordInputWithPWd:_password];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
//    [[iToast makeText:@"请输入密码支付该订单，或取消支付!"] show];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

- (void)cancelBtnClick
{
    [_topTX resignFirstResponder];
    [self.delegate cancelInputPwd];
}

- (void)forgetPwdClick
{
    [self.delegate forgetPassword];
}
@end
