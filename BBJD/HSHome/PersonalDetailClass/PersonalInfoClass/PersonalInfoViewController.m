//
//  PersonalInfoViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//
#import "ApplyBrokerViewController.h"

#import "PersonalInfoViewController.h"
#import "PersonHeadTableViewCell.h"
#import "PersonOtherInfoTableViewCell.h"
#import "binDingVController.h"
#import <Accelerate/Accelerate.h>

@interface PersonalInfoViewController ()<UIGestureRecognizerDelegate>
{
    ///用户头像
    UIImage *_headImg;
    ///头像上传后地址
    NSString *_headImgString;
    ///用户名
    NSString *_userNameString;
    ///性别
    int _sex;
    ///年龄
    NSString *_birthday;
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *personTableView;

@property(nonatomic, strong) id<ALBBMediaServiceProtocol> albbMediaService;
@property(nonatomic, strong) TFEUploadNotification *notificationupload1;
@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    //    //添加头部菜单栏
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"个人信息"];
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    [self initpersonTableView];
    [self.view addSubview:_personTableView];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSData *userData = [userDefault objectForKey:UserKey];
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
//    if (userInfoModel&&userInfoModel.userId&&![userInfoModel.userId isEqualToString:@""])
//    {
//        _userNameString = userInfoModel.username;
//        _sex = userInfoModel.gender;
//        _birthday = [NSString stringWithFormat:@"%ld",userInfoModel.birthday];
//        
//    }else
//    {
//        
//    }
    
    ///上传功能初始化
    _albbMediaService =[[TaeSDK sharedInstance] getService:@protocol(ALBBMediaServiceProtocol)];
    _notificationupload1 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _headImgString = url;
        
        [self updateUserInfoHeader];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        [[iToast makeText:@"图片上传失败!"] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
//    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
//    
//    [self.personTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//    [_personTableView reloadData];
    [self upDataUserMag];
}

//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_personTableView != nil) {
        return _personTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    
    self.personTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _personTableView.delegate = self;
    _personTableView.dataSource = self;
    _personTableView.backgroundColor = ViewBgColor;
    _personTableView.showsVerticalScrollIndicator = NO;
    _personTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    return _personTableView;
}

-(AppDelegate*)delegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (indexPath.row == 0) {
        static NSString *cellName = @"PersonHeadTableViewCell";
        PersonHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[PersonHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        
        if (_headImg) {
            cell.contentImg.image = _headImg;
        }else
        {
            [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:userInfoModel.header] placeholderImage:nil];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellName = @"PersonOtherInfoTableViewCell";
        PersonOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[PersonOtherInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        if (indexPath.row == 1) {
            
            cell.titleLable.text = @"绑定手机号";
            cell.contentLable.text = userInfoModel.telephone;
            
        }else if (indexPath.row == 2)
        {
            cell.titleLable.text = @"修改认证信息";
            cell.contentLable.text = @"";
        
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        _headSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从手机相册选择", nil];
        [_headSheet showInView:self.view];
    }else if (indexPath.row == 1)
    {
        
        binDingVController *binding=[[binDingVController alloc]init];
        
        [self.navigationController pushViewController:binding animated:YES];

    }
    else if (indexPath.row == 2)
    {
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel *userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data ];
//        邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
        if ([userInfo.status isEqualToString:@"3"]){
            
            [[iToast makeText:@"您的认证信息被注销,不能进行修改"]show];
        }
        else if ([userInfo.authen_status isEqualToString:@"-1"]){
            [[iToast makeText:@"先去认证经济人,再来修改信息吧!"]show];
        }
        else if ([userInfo.authen_status isEqualToString:@"0"]){
            [[iToast makeText:@"您的认证信息正在审核中,暂时还不能修改"]show];
        }
        else if ([userInfo.authen_status isEqualToString:@"2"]){
            [[iToast makeText:@"您的认证信息认证失败,请重新前往认证"]show];
        }
        else if ([userInfo.authen_status isEqualToString:@"1"]){
            DLog(@"@@@@@@@@@@@@");
            ApplyBrokerViewController *binding=[[ApplyBrokerViewController alloc]init];
            binding.status=2;
            [self.navigationController pushViewController:binding animated:YES];
            
        }
        
    }
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _headSheet) {
        if (buttonIndex == 1) {
            //  相册
            [self toPhotoPickingController];
        }
        if (buttonIndex == 0) {
            //  拍照
            [self toCameraPickingController];
        }
    }
}


///修改用户信息
- (void)updateUserInfoHeader
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array=[[NSArray alloc]initWithObjects:@"",_headImgString,@"",@"", nil];
    NSString *hmac=[[communcat sharedInstance ]ArrayCompareAndHMac:array];
    
    In_changePhoneModel *inModel=[[In_changePhoneModel alloc]init];
    inModel.key=userInfoModel.key;
    inModel.digest=hmac;
    inModel.header=_headImgString;
    inModel.mobile=@"";
    inModel.newmobile=@"";
    inModel.code=@"";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] changePersonerPhoneWith:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }
                else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    [self upDataUserMag];
                    [[iToast makeText:@"上传头像成功!"]show];
                    [self leftItemClick];
                    
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                    DLog(@"%@",[dic objectForKey:@"message"]);
                }
                
            } );
            
        }];
    });
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
            DLog(@"最大胆量%@",dic);
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
                
                //
                [_personTableView reloadData];
            }else{
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
}
///拍照上传头像
- (void)toCameraPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[iToast makeText:@"该设备不支持拍照!"] show];
        return;
    }
    else {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.view.backgroundColor = [UIColor blackColor];
        cameraPicker.delegate = self;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            
            [self.navigationController presentViewController:cameraPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
        else {
            [self.navigationController presentViewController:cameraPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}

- (void)toPhotoPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [[iToast makeText:@"该设备不支持拍照!"] show];
        return;
    }
    else {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.view.backgroundColor = [UIColor whiteColor];
        photoPicker.delegate = self;
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.allowsEditing = YES;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.navigationController presentViewController:photoPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
        else {
            [self.navigationController presentViewController:photoPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}
//#pragma mark 头像保存到本地
//-(void)saveheaderImageToDocument{
//    NSUserDefaults *userDefault1 = [NSUserDefaults standardUserDefaults];
//    NSData *userData1 = [userDefault1 objectForKey:UserKey];
////    UserInfoSaveModel *outModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData1];
//    
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
////    UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
//
//    
//}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

//图片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    _headImg = img;
    [_personTableView reloadData];
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"头像上传中";
    NSData *imageData1;
    if (UIImagePNGRepresentation(_headImg) == nil) {
        
        imageData1 = UIImageJPEGRepresentation(_headImg, 1);
        
    } else {
        
        imageData1 = UIImagePNGRepresentation(_headImg);
    }
    
    TFEUploadParameters *params1 = [TFEUploadParameters paramsWithData:imageData1 space:@"static2016jiujiu" fileName:[self uniqueString] dir:@"broker/authen"];
    
    [_albbMediaService upload:params1 options:nil notification:_notificationupload1];
    
}

//日期选择代理
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    _birthday = date;
    [_personTableView reloadData];
}

///获取随机不重复字符串
- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}


@end
