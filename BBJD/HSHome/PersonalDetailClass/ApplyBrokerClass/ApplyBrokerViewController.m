//
//  ApplyBrokerViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "ApplyBrokerViewController.h"
#import "ApplyBrokerInfoTableViewCell.h"
#import "ApplyBrokerImgTableViewCell.h"
#import "ApplyBrokerTestTableViewCell.h"
#import "approveComplVController.h"//认证提交
#import "LoginViewController.h"
#import "citySelectViewController.h"//选择城市
#import "ApplyWaitingViewController.h"//认证引导
#import "certifyViewController.h"//信用金认证

@interface ApplyBrokerViewController ()<ApplyInfoDelegate,IdImgDelegate,UIGestureRecognizerDelegate>
{
    ///当前选择图片的类型 1是正面照 2是反面照 3是手持照
    int _currentImgType;
    ///上传的身份证图片
    UIImage *_positiveImg;
    UIImage *_negativeImg;
    UIImage *_handIdImg;
    ///上传图片后图片地址
    NSString *_positiveImgString;
    NSString *_negativeImgString;
    NSString *_handIdImgString;
    ///身份信息
    NSString *_realNameString;
    NSString *_realPhoneString;//支付宝账户
    NSString *_realIdString;
    NSString *_city;
    ///上传图片索引
    int _uploadIndex;
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *applyTableView;
@property (nonatomic, strong) UIView *dealView;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIButton *delegateBtn;
@property (nonatomic, strong) NSMutableArray  *cityAry;
@property(nonatomic,strong)ApplyWaitingViewController *guideVC;

@property(nonatomic, strong) id<ALBBMediaServiceProtocol> albbMediaService;
@property(nonatomic, strong) TFEUploadNotification *notificationupload1;
@property(nonatomic, strong) TFEUploadNotification *notificationupload2;
@property(nonatomic, strong) TFEUploadNotification *notificationupload3;

@end

@implementation ApplyBrokerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    _status=2;
    
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    _cityAry=[[NSMutableArray alloc]initWithCapacity:0];
   self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"达人认证"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self initpersonTableView];
    [self.view addSubview:_applyTableView];
    
    if (!_dealView) {
        _dealView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50, SCREEN_WIDTH, 120)];
        _dealView.backgroundColor = ViewBgColor;
        
        //        [self.view addSubview:_dealView];
    }
    
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.frame = CGRectMake(20,5, SCREEN_WIDTH-40, 40);
        [_applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_applyBtn addTarget:self action:@selector(applyBrokerClick) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.layer.borderColor = TextMainCOLOR.CGColor;
        _applyBtn.layer.borderWidth = 0.5;
        _applyBtn.layer.cornerRadius = 5;
        [_applyBtn setBackgroundImage:[[communcat sharedInstance] createImageWithColor:WhiteBgColor] forState:UIControlStateNormal];
        [_applyBtn setBackgroundImage:[[communcat sharedInstance] createImageWithColor:ButtonBGCOLOR] forState:UIControlStateHighlighted];
        [_applyBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = LittleFont;
        [_dealView addSubview:_applyBtn];
    }
    
    if (!_checkView) {
        _checkView = [[UIView alloc] initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, 50)];
        _checkView.backgroundColor = ViewBgColor;
    }
    
    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delegateBtn.backgroundColor = MAINCOLOR;
        [_delegateBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_delegateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _delegateBtn.clipsToBounds = YES;
        _delegateBtn.layer.cornerRadius = 10;
        [_delegateBtn addTarget:self action:@selector(delegateClick) forControlEvents:UIControlEventTouchUpInside];
        [_checkView addSubview:_delegateBtn];
    }
    
    _delegateBtn.sd_layout.centerXEqualToView(_checkView)
    .heightIs(45)
    .topSpaceToView(_checkView,10)
    .widthIs(280);
    
    ///上传功能初始化
    _albbMediaService =[[TaeSDK sharedInstance] getService:@protocol(ALBBMediaServiceProtocol)];
    _uploadIndex = 0;
    
    //正面照上传回调
    _notificationupload1 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        _uploadIndex = 0;
        
        _uploadIndex++;
        _positiveImgString = url;
        _delegateBtn.userInteractionEnabled = YES;
        [self allContentSubmit];
        
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        _delegateBtn.userInteractionEnabled = YES;
        [[iToast makeText:@"图片上传失败!"] show];
    }];
    
    //反面照上传回调
    _notificationupload2 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        _uploadIndex++;
        _negativeImgString = url;
        _delegateBtn.userInteractionEnabled = YES;
        [self allContentSubmit];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        _delegateBtn.userInteractionEnabled = YES;
        [[iToast makeText:@"图片上传失败!"] show];
        
    }];
    
    //手持照上传回调
    _notificationupload3 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        _uploadIndex++;
        _handIdImgString = url;
        _delegateBtn.userInteractionEnabled = YES;
        [self allContentSubmit];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        _delegateBtn.userInteractionEnabled = YES;
        [[iToast makeText:@"图片上传失败!"] show];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityWithName:)   name:@"city" object:nil];
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

-(void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"city" object:nil];
    
}

#pragma mark 初始化下单table
-(UITableView *)initpersonTableView
{
    if (_applyTableView != nil) {
        return _applyTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    
    self.applyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _applyTableView.delegate = self;
    _applyTableView.dataSource = self;
    _applyTableView.backgroundColor = ViewBgColor;
    _applyTableView.showsVerticalScrollIndicator = NO;

    return _applyTableView;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 120;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return _tipLabel;
//    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return _checkView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  [ApplyBrokerInfoTableViewCell cellHeight];
    }else if (indexPath.section == 1)
    {
        return [ApplyBrokerImgTableViewCell cellHeight];
    }
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (indexPath.section == 0) {
        static NSString *cellName = @"ApplyBrokerInfoTableViewCell";
        ApplyBrokerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[ApplyBrokerInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        if(![_city isEqualToString:@""]){
            [cell.address  setTitle:_city forState:UIControlStateNormal];
            [cell.address setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
        }else{
            [cell.address  setTitle:@"请选择城市" forState:UIControlStateNormal];
        }
        cell.delegate = self;
        if (_status==2) {
            cell.idTextField.enabled=NO;
            cell.nameTextField.enabled=NO;
            cell.nameTextField.text=userInfoModel.realname;
            cell.idTextField.text=userInfoModel.idcardno;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellName = @"ApplyBrokerImgTableViewCell";
        ApplyBrokerImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[ApplyBrokerImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        if (_status==2) {
            [cell.idImg sd_setImageWithURL:[NSURL URLWithString:userInfoModel.positive_idcard] placeholderImage:[UIImage imageNamed:@"BackIdImg"]];
            [cell.idImg2 sd_setImageWithURL:[NSURL URLWithString:userInfoModel.opposite_idcard] placeholderImage:[UIImage imageNamed:@"AddIdImg"]];
             [cell.idImg3 sd_setImageWithURL:[NSURL URLWithString:userInfoModel.hand_idcard] placeholderImage:[UIImage imageNamed:@"HandIdImg"]];
        }
        else{
            if (_positiveImg) {
                cell.idImg.image = _positiveImg;
            }
            
            if (_negativeImg) {
                cell.idImg2.image = _negativeImg;
            }
            
            if (_handIdImg) {
                cell.idImg3.image = _handIdImg;
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
//            BrokerTrainViewController *trainVC = [[BrokerTrainViewController alloc] init];
//            trainVC.delegate = self;
//            [self.navigationController pushViewController:trainVC animated:YES];
        }else
        {
//            BrokerTestViewController *testVC = [[BrokerTestViewController alloc] init];
//            testVC.delegate = self;
//            [self.navigationController pushViewController:testVC animated:YES];
        }
    }
}

///提交申请，上传图片
- (void)applyBrokerClick
{
    if (_status == 2) {
        [self allContentSubmit];
        
    }else{
    if (!_realNameString || [_realNameString isEqualToString:@""]) {
        [[KNToast shareToast] initWithText:@"请输入真实姓名!" duration:1 offSetY:0];
           _delegateBtn.userInteractionEnabled = YES;
        return;
    }
    
        if (!_realPhoneString || [_realPhoneString isEqualToString:@""]) {
            [[KNToast shareToast] initWithText:@"请输入支付宝账号!" duration:1 offSetY:0];
               _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        
        if (!_realIdString || [_realIdString isEqualToString:@""]) {
            [[KNToast shareToast] initWithText:@"请输入身份证号!" duration:1 offSetY:0];
        _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        
        if (!_positiveImg) {
            [[KNToast shareToast] initWithText:@"请上传身份证正面照!" duration:1 offSetY:0];
        _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        if (!_negativeImg) {
            [[KNToast shareToast] initWithText:@"请上传身份证反面照!" duration:1 offSetY:0];
             _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        if (!_handIdImg) {
            [[KNToast shareToast] initWithText:@"请上传身份证手持照!" duration:1 offSetY:0];
               _delegateBtn.userInteractionEnabled = YES;;
            return;
        }
    
    NSData *imageData1;
    if (UIImagePNGRepresentation(_positiveImg) == nil) {
        
        imageData1 = UIImageJPEGRepresentation(_positiveImg, 1);
        
    } else {
  
        imageData1 = UIImageJPEGRepresentation(_positiveImg, 0.3f);
        
    }
    NSData *imageData2;
    if (UIImagePNGRepresentation(_negativeImg) == nil) {
        
        imageData2 = UIImageJPEGRepresentation(_negativeImg, 1);
        
    } else {

        imageData2 = UIImageJPEGRepresentation(_negativeImg, 0.3f);
    }
    
    NSData *imageData3;
    if (UIImagePNGRepresentation(_handIdImg) == nil) {
        
        imageData3 = UIImageJPEGRepresentation(_handIdImg, 1);
        
    } else {
        imageData3 = UIImageJPEGRepresentation(_handIdImg, 0.3f);
    }
    
    TFEUploadParameters *params1 = [TFEUploadParameters paramsWithData:imageData1 space:@"static2016jiujiu" fileName:[self uniqueString] dir:@"broker/authen"];
    TFEUploadParameters *params2 = [TFEUploadParameters paramsWithData:imageData2 space:@"static2016jiujiu" fileName:[self uniqueString] dir:@"broker/authen"];
    TFEUploadParameters *params3 = [TFEUploadParameters paramsWithData:imageData3 space:@"static2016jiujiu" fileName:[self uniqueString] dir:@"broker/authen"];
    [_albbMediaService upload:params1 options:nil notification:_notificationupload1];
    [_albbMediaService upload:params2 options:nil notification:_notificationupload2];
    [_albbMediaService upload:params3 options:nil notification:_notificationupload3];
    }
    
}


//确认按钮点击
- (void)finshBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//支付信用金按钮点击
- (void)payBtnClick{
  
    certifyViewController *VC = [[certifyViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 提交认证信息
- (void)allContentSubmit
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (_status == 2) {
       
        if (_city.length==0||!_city||[_city isEqualToString:@""]){
            [[KNToast shareToast] initWithText:@"意向城市不能为空!" duration:1 offSetY:0];
            _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        
        if (_realPhoneString.length==0||!_realPhoneString||[_realPhoneString isEqualToString:@""] ){
            [[KNToast shareToast] initWithText:@"支付宝账户不能为空!" duration:1 offSetY:0];
               _delegateBtn.userInteractionEnabled = YES;;
            return;
        }
        [ZJCustomHud dismiss];
        [ZJCustomHud showWithStatus:@"正在努力加载..."];
        NSArray *dataArray = [[NSArray alloc] initWithObjects:_realPhoneString,_city,nil];
        NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
        changeAapprove_InModel *inModel = [[changeAapprove_InModel alloc] init];
        inModel.key = userInfoModel.key;
        inModel.degist = hmacString;
        inModel.alipay_account = _realPhoneString;
        inModel.city_name = _city;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[communcat sharedInstance]changeApproveMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
                [ZJCustomHud dismiss];
                _delegateBtn.userInteractionEnabled = YES;
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                  
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code ==1000)
                {
                   
                    [[KNToast shareToast] initWithText:@"信息修改成功!" duration:1 offSetY:0];
                    [[[LoginViewController alloc]init] upDataUserMag];
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_city,@"city", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil userInfo:dict];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                }
            }];
        });
        
    }else{
        
        if (_positiveImgString.length == 0||!_positiveImgString){
             _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        if (_negativeImgString.length==0||!_negativeImgString){
             _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        if (_handIdImgString.length==0||!_handIdImgString){
             _delegateBtn.userInteractionEnabled = YES;
            return;
        }
//
        if (_city.length==0 ||!_city||[_city isEqualToString:@""]){
             _delegateBtn.userInteractionEnabled = YES;
            [[iToast makeText:@"无法上传城市信息"]show];
            return;
        }
        
        if ([[communcat sharedInstance] checkUserIdCard:_realIdString] == NO){
             _delegateBtn.userInteractionEnabled = YES;
            [[KNToast shareToast] initWithText:@"身份证号信息不正确!" duration:1 offSetY:0];
            return;
        }
        
        if (_realPhoneString.length==0||!_realPhoneString||[_realPhoneString isEqualToString:@""] ){
            [[KNToast shareToast] initWithText:@"支付宝账户不能为空!" duration:1 offSetY:0];
             _delegateBtn.userInteractionEnabled = YES;
            return;
        }
        [ZJCustomHud dismiss];
        [ZJCustomHud showWithStatus:@"信息正在提交中..."];
        NSArray *dataArray = [[NSArray alloc] initWithObjects:userInfoModel.telephone,_positiveImgString,_negativeImgString,_handIdImgString,_realNameString,_realPhoneString,_realIdString,_city,nil];
        NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
        approve_InModel *inModel = [[approve_InModel alloc] init];
        inModel.key = userInfoModel.key;
        inModel.degist = hmacString;
        inModel.positive_idcard = _positiveImgString;
        inModel.opposite_idcard = _negativeImgString;
        inModel.hand_idcard = _handIdImgString;
        inModel.apliy_account = _realPhoneString;
        inModel.username = _realNameString;
        inModel.idcardno = _realIdString;
        inModel.mobile = userInfoModel.telephone;
        inModel.city_name =_city;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[communcat sharedInstance] getApproveMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
                [ZJCustomHud dismiss];
                _delegateBtn.userInteractionEnabled = YES;
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code ==1000){
                    
                    [self.applyTableView removeFromSuperview];
                    _guideVC = [[ApplyWaitingViewController alloc] init];
                    [self addChildViewController:_guideVC];
                    _guideVC.view.frame = CGRectMake(0, SCREEN_HEIGHT-64,SCREEN_WIDTH , SCREEN_HEIGHT-64);
                    [_guideVC.finishBtnClick addTarget:self action:@selector(finshBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [_guideVC.payBtnClick addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        _guideVC.view.frame = CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT-64);
                        [self.view addSubview:_guideVC.view];
                    }];
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_city,@"city", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil userInfo:dict];
                    [[[LoginViewController alloc]init] upDataUserMag];
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                }
               
            } fail:^(NSError *error) {
                [ZJCustomHud dismiss];
                [ZJCustomHud showWithError:@"网络不给力！"];
                _delegateBtn.userInteractionEnabled = YES;
                
            }];
            
        });
    }
}

#pragma mark 选择协议
- (void)selectClick:(id)sender
{

}

#pragma mark 填写信息
- (void)delegateClick{
    
    _delegateBtn.userInteractionEnabled = NO;
    [self applyBrokerClick ];
 }

#pragma CompleteTrainDelegate 完成培训代理
- (void)completeTrainWithStatus:(int)status
{
    
}

#pragma CompleteTestDelegate 完成测试代理
- (void)completeTestWithStatus:(int)status
{
    
}

#pragma ApplyInfoDelegate 申请信息代理
- (void)setAgentInfo:(NSString *)string andType:(int)type;
{
    if (type == 1) {
        _realNameString = string;
    }else if (type == 2)
    {
        _realPhoneString = string;
    }else
    {
        _realIdString = string;

        if ([[communcat sharedInstance]checkUserIdCard:string] == NO){
            [[iToast makeText:@"身份证号信息不正确"]show];
           
        }
    }
}


#pragma IdImgDelegate  选择图片代理
- (void) idImgChoose:(int)type
{
    if (_status==2) {
        
    
    }
    else{
        _currentImgType = type;
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从手机相册选择", nil];
        [as showInView:self.view];
        
    }
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //  相册
        [self toPhotoPickingController];
    }
    if (buttonIndex == 0) {
        //  拍照
        [self toCameraPickingController];
    }
}

//拍照
- (void)toCameraPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    else {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.view.backgroundColor = [UIColor blackColor];
        cameraPicker.delegate = self;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
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

//相册
- (void)toPhotoPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }
    else {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.view.backgroundColor = [UIColor whiteColor];
        photoPicker.delegate = self;
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

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
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *img2 = [self scaleImage:img toKb:1];
    
    if (_currentImgType ==1) {
        _positiveImg = img2;
    }else if (_currentImgType == 2)
    {
        _negativeImg = img2;
    }else
    {
        _handIdImg = img2;
    }
    [_applyTableView reloadData];
    
}


-(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    DLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}


///获取随机不重复字符串
- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0,1300,900)];
    UIImage* newImage =
    UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 选择城市
-(void)choceAddressBtnClick;
{
    
    citySelectViewController *city = [[citySelectViewController alloc]init];
    
    [self.navigationController pushViewController:city animated:YES];
}

-(void)didSelectCityWithName:(NSNotification*) notification
{
    NSString *  cityname = [notification object];//通过这个获取到传递的对象
    _city = cityname;
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    ApplyBrokerInfoTableViewCell *cell=[_applyTableView cellForRowAtIndexPath:index];
    [cell.address  setTitle:cityname forState:UIControlStateNormal];
    [cell.address setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
