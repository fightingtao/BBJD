//
//  LoginViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/30.
//  Copyright © 2015年 xc. All rights reserved.
//
#import "RegistDelegateViewController.h"
#import "JPUSHService.h"
#import "LoginViewController.h"
#import "publicResource.h"
#import "ApplyBrokerViewController.h"

@interface LoginViewController ()<UIAlertViewDelegate>
{
    int user_type;
}


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UITextField *phoneTxtField;
@property (nonatomic, strong) UIImageView *codeImg;
@property (nonatomic, strong) UITextField *codeTxtField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *delegateBtn;
@property (nonatomic, strong) UILabel *list;//shuom说明


@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    //    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=YES;
    
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MAINCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"登录"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
         
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = WhiteBgColor;
        [self.view addSubview:_contentView];
    }
    
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.image = [UIImage imageNamed:@"登录.png"];
        [self.view addSubview:_logo];
    }
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 15, 25)];
        _phoneImg.image = [UIImage imageNamed:@"login_phone"];
        [_contentView addSubview:_phoneImg];
    }
    
    if (!_phoneTxtField) {
        _phoneTxtField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-80, 50)];
        _phoneTxtField.borderStyle = UITextBorderStyleNone;
        _phoneTxtField.placeholder = @"请输入手机号";
        _phoneTxtField.backgroundColor = [UIColor clearColor];
        _phoneTxtField.textColor = [UIColor blackColor];
        _phoneTxtField.font = LittleFont;
        _phoneTxtField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTxtField.delegate = self;
        _phoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTxtField.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
        [_contentView addSubview:_phoneTxtField];
    }
    
    if (!_codeImg) {
        _codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 15, 25)];
        _codeImg.image = [UIImage imageNamed:@"组-14"];
        [_contentView  addSubview:_codeImg];
    }
    
    if (!_codeTxtField) {
        _codeTxtField = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, SCREEN_WIDTH-150, 50)];
        _codeTxtField.borderStyle = UITextBorderStyleNone;
        _codeTxtField.placeholder = @"请输入验证码";
        _codeTxtField.backgroundColor = [UIColor clearColor];
        _codeTxtField.textColor = [UIColor blackColor];
        _codeTxtField.font = LittleFont;
        _codeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTxtField.delegate=self;
        _codeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_contentView  addSubview:_codeTxtField];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = LineColor;
    [_contentView  addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 119, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = LineColor;
    [_contentView  addSubview:line2];
    
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.backgroundColor = MAINCOLOR;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.frame = CGRectMake(SCREEN_WIDTH-140, 68.5, 110, 35);
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _codeBtn.clipsToBounds = YES;
        _codeBtn.layer.borderWidth = 1;
        _codeBtn.layer.cornerRadius = 10;
     
        [_contentView  addSubview:_codeBtn];
    }
    
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor = MAINCOLOR;
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _loginBtn.clipsToBounds = YES;
        _loginBtn.layer.borderWidth = 1;
        _loginBtn.layer.cornerRadius = 10;
        
        [self.view addSubview:_loginBtn];
    }
    
    if (!_list) {
        _list = [[UILabel alloc] init];
        _list.backgroundColor = [UIColor clearColor];
        _list.font = [UIFont systemFontOfSize:12];
        _list.textColor = TextDetailCOLOR;
        _list.text = @"登录代表您已同意";
        _list.lineBreakMode = NSLineBreakByTruncatingTail;
        _list.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_list];
    }
    
    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delegateBtn setTitle:@"《邦办即达协议》" forState:UIControlStateNormal];
        
        [_delegateBtn setTitleColor:[UIColor colorWithRed:0.3137 green:0.1765 blue:0.4706 alpha:1] forState:UIControlStateNormal];
        
        [_delegateBtn addTarget:self action:@selector(goDelegateViewC) forControlEvents:UIControlEventTouchUpInside];
        _delegateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.view  addSubview:_delegateBtn];
    }
    _logo.sd_layout.centerXEqualToView(self.view)
    .topSpaceToView(self.view,40)
    .widthIs(90)
    .heightIs(90);
    
    //    line2.sd_layout.leftSpaceToView(self.view,10)
    //    .topSpaceToView (line,60)
    //    .rightSpaceToView(self.view,10)
    //    .heightIs(1);
    
    _contentView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView (_logo,30)
    .rightSpaceToView(self.view,0)
    .heightIs(120);
    
    _loginBtn.sd_layout.leftSpaceToView(self.view,30)
    .topSpaceToView (_contentView,30)
    .rightSpaceToView(self.view,30)
    .heightIs(44);
    
    _list.sd_layout.leftSpaceToView(self.view,(SCREEN_WIDTH-200)/2)
    .bottomSpaceToView (self.view,15)
    .widthIs(100)
    .heightIs(20);
    
    _delegateBtn.sd_layout.leftSpaceToView(_list,0)
    .bottomSpaceToView (self.view,15)
    .widthIs(100)
    .heightIs(20);
}

//查看协议
-(void)goDelegateViewC{
    RegistDelegateViewController *delegate=[[RegistDelegateViewController alloc]init];
//    self.hidesBottomBarWhenPushed=NO;
//    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController pushViewController:delegate animated:YES];
}

//获取验证码事件处理
- (void)getCodeClick
{
    [_phoneTxtField resignFirstResponder];
    [_codeTxtField resignFirstResponder];
    
    if (_phoneTxtField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"] show];
        return;
    }
    if (![[communcat sharedInstance] checkTel:_phoneTxtField.text]) {
        return;
    }
    [self startCodeTime];
    In_LoginCodeModel *inModel = [[In_LoginCodeModel alloc] init];
    inModel.telephone = _phoneTxtField.text;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] sendCodeWithPhone:_phoneTxtField.text resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (dic){
                    int   code =[[dic objectForKey:@"code"] intValue];
                    if (code == 1000) {
                        [[iToast makeText:@"验证码发送成功!" ] show];
                   
                    }else {
                        [[iToast makeText:[dic objectForKey:@"message"] ] show];
                        
                    }
                }else{
                    [[iToast makeText:@"网络不给力!请检查数据连接..."] show];
                    NSLog(@"@@@@@@@@@@@@@@%@",dic[@"message"]);
                    
                }
                
            });
            
        } ];
    });
    
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
                [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}



#pragma mark 登录
- (void)loginClick
{
    user_type = 0;
    
    if (_phoneTxtField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"] show];
        return;
    }
    if ([[communcat sharedInstance]checkTel:_phoneTxtField.text]==NO){
        [[iToast makeText:@"请输入手机号"]show];
        return;
    }
    
    if (_codeTxtField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"] show];
        return;
    }
    
    In_LoginModel *inModel = [[In_LoginModel alloc] init];
    inModel.telephone = _phoneTxtField.text;
    inModel.code = _codeTxtField.text;
    inModel.user_type = [NSString stringWithFormat:@"%d",user_type];
    [ZJCustomHud showWithStatus:@"登录中..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] LoginbtnClickWithMsg:inModel resultDic:^(NSDictionary *dic) {
            [ZJCustomHud dismiss];

            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic)
            {
                [[KNToast shareToast] initWithText:@"网络不给力,请稍后重试!" duration:3 offSetY:0];
          
            }
            else if (code ==1000)
            {
                NSDictionary *data=[dic objectForKey:@"data"];
                OutLoginBody *outModel=[[OutLoginBody alloc]initWithDictionary:data error:nil];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
                saveModel.city_name = outModel.city_name;
                saveModel.driver_license = outModel.driver_license;
                saveModel.tag = outModel.tag;
                saveModel.vehicle = outModel.vehicle;
                saveModel.dominate_time = outModel.dominate_time;
                saveModel.status = outModel.status;
                saveModel.opposite_idcard = outModel.opposite_idcard;
                saveModel.idcardno = outModel.idcardno;
                saveModel.level = outModel.level;
                saveModel.emergency_contact_mobile = outModel.emergency_contact_mobile;
                saveModel.gender = outModel.gender;
                saveModel.is_payed = outModel.is_payed;
                saveModel.point = outModel.point;
                saveModel.seller_id = outModel.seller_id;
                saveModel.key = outModel.key;
                saveModel.apliy_account = outModel.apliy_account;
                saveModel.tag = outModel.tag;
                saveModel.intention_delivery_area = outModel.intention_delivery_area;
                saveModel.status = outModel.status;
                saveModel.nickname =outModel.nickname;
                saveModel.user_type =outModel.user_type;
                saveModel.emergency_contact_name = outModel.emergency_contact_name;
                saveModel.user_status = outModel.user_status;
                saveModel.positive_idcard = outModel.positive_idcard;
                saveModel.authen_status = outModel.authen_status;
                saveModel.header = outModel.header;
                saveModel.primary_key = outModel.primary_key;
                saveModel.realname = outModel.realname;
                saveModel.hand_idcard = outModel.hand_idcard;
                saveModel.telephone = outModel.telephone;
                saveModel.notify_switch = outModel.notify_switch;
                NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:saveModel];
                [userDefault setObject:setData forKey:UserKey];
                NSSet *set = [[NSSet alloc] initWithObjects:outModel.tag, nil];
                
                [JPUSHService setTags:set alias:outModel.key callbackSelector:nil object:nil];
                
                [userDefault setObject:_phoneTxtField.text forKey:@"phoneNumble"];
                
                [self.navigationController popViewControllerAnimated:YES];
                self.tabBarController.selectedIndex=0;

                    [super.navigationController setNavigationBarHidden:NO animated:TRUE];


                
            }else{
                [[KNToast shareToast] initWithText: [dic objectForKey:@"message"] duration:1 offSetY:0];
            }
            
        } fail:^(NSError *error) {
            [ZJCustomHud dismiss];
            if (error) {
                [[KNToast shareToast] initWithText:@"网络异常！" duration:1 offSetY:0];
            }
        }];
    });
}

//导航栏左右侧按钮点击

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_phoneTxtField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:10];
        }
    }
    if (_codeTxtField==textField) {
        
        if ([toBeString length] > 4) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:3];
        }
    }
    return YES;
}
#pragma mark 抢单成功后更新个人信息
-(void)upDataUserMag{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length==0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] upDataUserMsgWithkey:userInfoModel.key degist:hmac resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code ==1000)
            {
                NSDictionary *data=[dic objectForKey:@"data"];
                OutLoginBody *outModel=[[OutLoginBody alloc]initWithDictionary:data error:nil];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
                saveModel.city_name = outModel.city_name;
                saveModel.driver_license = outModel.driver_license;
                saveModel.tag = outModel.tag;
                saveModel.vehicle = outModel.vehicle;
                saveModel.dominate_time = outModel.dominate_time;
                saveModel.status = outModel.status;
                saveModel.opposite_idcard = outModel.opposite_idcard;
                saveModel.idcardno = outModel.idcardno;
                saveModel.level = outModel.level;
                saveModel.emergency_contact_mobile = outModel.emergency_contact_mobile;
                saveModel.gender = outModel.gender;
                saveModel.is_payed = outModel.is_payed;
                saveModel.point = outModel.point;
                saveModel.seller_id = outModel.seller_id;
                saveModel.key = outModel.key;
                saveModel.apliy_account = outModel.apliy_account;
                saveModel.tag = outModel.tag;
                saveModel.intention_delivery_area = outModel.intention_delivery_area;
                saveModel.status = outModel.status;
                saveModel.nickname =outModel.nickname;
                saveModel.user_type =outModel.user_type;
                saveModel.emergency_contact_name = outModel.emergency_contact_name;
                saveModel.user_status = outModel.user_status;
                saveModel.positive_idcard = outModel.positive_idcard;
                saveModel.authen_status = outModel.authen_status;
                saveModel.header = outModel.header;
                saveModel.primary_key = outModel.primary_key;
                saveModel.realname = outModel.realname;
                saveModel.hand_idcard = outModel.hand_idcard;
                saveModel.telephone = outModel.telephone;
                saveModel.notify_switch = outModel.notify_switch;
                saveModel.frozen_days = outModel.frozen_days;
                saveModel.frozen_type = outModel.frozen_type;
                NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:saveModel];
                [userDefault setObject:setData forKey:UserKey];
            }else{
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
}
@end
