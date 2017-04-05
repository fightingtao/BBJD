//
//  scrapeOrderDetailVController.m
//  BBJD
//
//  Created by cbwl on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
#import "scrapeOrderDetailVController.h"
#import "scrapeDetailTViewCell.h"
#import "BDMapVController.h"
#import "HomeTableViewCell.h"
#import "scrapeFooterView.h"//区尾
#import "MapRoaldVController.h"//dignwei导航
#define scrapeCell @"scrapeCell"
#import "LoginViewController.h"
#import "CountDown.h"//倒计时
#import "LScannerViewController.h"//去扫描
#import "ApplyBrokerViewController.h"
#import "publicResource.h"
@interface scrapeOrderDetailVController ()<UITableViewDelegate,UITableViewDataSource,orderDetialDelegate,footerDelegate,BMKGeoCodeSearchDelegate>
{
    NSString *time;//
    NSString *_record;//1.送货地址   2.商家地址
    NSTimeInterval _Interval;//记录服务器和系统时间的差
}

 
@property(nonatomic,strong)NSMutableArray *dataList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMKGeoCodeSearch *searchAdress;
@property (nonatomic, strong) scrapeFooterView *footerView;
@property(nonatomic,strong)UIView *footer;
@property(nonatomic,strong)UILabel *orderReceiving;
@property(nonatomic,strong)UILabel *orderReceivingTime;

@property(nonatomic,strong)Out_GrapDetialListBody * model;
@property (strong, nonatomic)  CountDown *countDown;
@end

@implementation scrapeOrderDetailVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
    [self getOrderDetialInfor];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //string 邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
    if ([userInfoModel.authen_status isEqualToString:@"-1"] ){
        CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"您还未认证达人\n是否验证成为邦办达人?" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
                ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
                [self .navigationController pushViewController:broker animated:YES];
            }
        }];
        //显示
        [alert showLXAlertView];
        
    }else if ([userInfoModel.authen_status isEqualToString:@"0"] ){
        [[iToast makeText:@"您的信息正在审核,请耐心等待"]show];
        
    }else  if ([userInfoModel.authen_status isEqualToString:@"2"] ){
        CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"身份验证失败\n验证失败!是否重新认证?" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
                ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
                [self .navigationController pushViewController:broker animated:YES];
            }
        }];
        //显示
        [alert showLXAlertView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewBgColor;
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"订单详情"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    [self initSubViews];
    [self initpersonTableView];
    self.tableView.tableFooterView = _footerView;
    
  }

-(void)initSubViews{
    if (!_footer) {
        _footer.backgroundColor = [UIColor whiteColor];
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 40)];
    }
    if (!_orderReceiving) {
        _orderReceiving = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 70, 20)];
        _orderReceiving.text = @"接单时间:";
        _orderReceiving.textColor = [UIColor grayColor];
        _orderReceiving.alpha = 0.7;
        _orderReceiving.font = [UIFont systemFontOfSize:15];
        
        [_footer addSubview:_orderReceiving];
    }
    
    if (!_orderReceivingTime) {
        _orderReceivingTime = [[UILabel alloc] initWithFrame:CGRectMake(_orderReceiving.x +_orderReceiving.width, 10, 200, 20)];
        _orderReceivingTime.textColor = [UIColor grayColor];
        _orderReceivingTime.alpha = 0.7;
        [_footer addSubview:_orderReceivingTime];
        _orderReceivingTime.font = [UIFont systemFontOfSize:15];
    }
    
    if (!_footerView){
        _footerView=[[scrapeFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor=ViewBgColor;
        _footerView.delegate = self;
    }
}

#pragma mark tableView 初始化下单tableView
-(void)initpersonTableView
{
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-50;
    _dataList = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = ViewBgColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
   
    // 告诉tableView所有cell的真实高度是自动计算（根据设置的约束来计算）
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估算高度
    self.tableView.estimatedRowHeight = 80;
    //注册
    [self.tableView registerClass:[scrapeDetailTViewCell class] forCellReuseIdentifier:scrapeCell];
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_model.grab_status isEqualToString:@"1"]) {
        return 40;
    }
    return 0.01;
}

//w尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([_model.grab_status isEqualToString:@"1"]) {
        return _footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor redColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.model = self.dataList[indexPath.section];
    if ( [_model.requirment_type isEqualToString:@"0"]) {         
        HomeTableViewCell *cell = [HomeTableViewCell tableViewCellWith:self.tableView indexPath:indexPath msg:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.OrderDelegate = self;

        return cell;
        
    }
    scrapeDetailTViewCell *cell = [scrapeDetailTViewCell detialTableViewCellWith:tableView indexPath:indexPath msg:self.model];
    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark ---------网格或网点-------------
-(void)phoneButton1Click:(NSString *)tel{
  
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tel message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",tel];
        if ([phoneStr hasPrefix:@"sms:"] || [phoneStr hasPrefix:@"tel:"]) {
            UIApplication * app = [UIApplication sharedApplication];
            if ([app canOpenURL:[NSURL URLWithString:phoneStr]]) {
                [app openURL:[NSURL URLWithString:phoneStr]];
            }
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)locationButton1Click:(UIButton*)btn{
    
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc]init];
    _searchAdress.delegate = self;
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeOption.address = _model.grid_address;
    BOOL flagAdd = [_searchAdress geoCode:geoCodeOption];
    if(flagAdd)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}


#pragma mark 定位
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        MapRoaldVController*map =[[MapRoaldVController alloc]init];
        if ([_model.requirment_type isEqualToString:@"0"]) {
            map.address = _model.seller_address;
            
        }else if([_model.requirment_type isEqualToString:@"2"]){
            map.address = _model.grid_address;
            
        }else{
            if ([_record isEqualToString:@"1"]) {
                map.address=_model.grid_address;
            }else{
                map.address=_model.seller_address;
            }
        }
        map. templatitude = item.coordinate.latitude;
        map.templongitude = item.coordinate.longitude;
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:map animated:YES];
    }
}

#pragma mark 取消按钮
-(void)onCancelClick:(UIButton *)btn;
{
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@" 取消订单将会扣除200积分！\n是否确认取消？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
            
            [self cancellOrder];
        }
    }];
    //显示
    [alert showLXAlertView];
}

#pragma mark 去扫描按钮
-(void)onGoWorkClick:(UIButton *)btn;
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"suckEffect";//立体
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    LScannerViewController *VC = [[LScannerViewController alloc] init];
    VC.requirment_id = self.requment_id;
    if ([self.seller_type isEqualToString:@"5"]) {
        VC.seller_type = @"1";
    }else{
        VC.seller_type = @"-1";
    }
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 接单按钮
-(void)onGetOrderClick:(UIButton *)btn;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([userInfoModel.authen_status isEqualToString:@"2"] ){
        [[iToast makeText:@"达人认证失败，暂不能接单，赶快重新认证再来接单吧！"] show];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"-1"]){
        [[iToast makeText:@"您还未认证达人，暂不能接单!"] show];
        return;
    }else if ([userInfoModel.authen_status isEqualToString:@"0"]){
        [[iToast makeText:@"您的认证还未通过，暂不能接单!"] show];
        return;
    }

    if ([_has_grabed isEqualToString:@"0"] && [_model.deduct  isEqualToString:@"1"]) {// false未抢过单
        CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"每日完成订单配送后扣取1元保险费，是否确认接单？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
                [self getOrder];//点击确认后抢单
            }
        }];
        //显示
        [alert showLXAlertView];
    }else{
        [self getOrder];//直接抢单
    }
}

#pragma mark -------------接单按钮点击
-(void)getOrder{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        return;
    }
    
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",self.requment_id] withKey:userInfoModel.primary_key];
    
    In_GraplistModel *inModel = [[In_GraplistModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%@",self.requment_id];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] grapListWithMsg:inModel resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
            }else if (code ==1000){
                dispatch_time_t time1 = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time1, dispatch_get_main_queue(), ^{
                    [self getOrderDetialInfor];//重新获取网络数据
                    [self initSubViews];
                    [self.tableView reloadData];
                });
            }else{
                
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ------------取消订单接口
-(void)cancellOrder{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",self.requment_id] withKey:userInfoModel.primary_key];
    
    In_cancellModel *inModel = [[In_cancellModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%@",_requment_id];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] cancellOrderWithMsg:inModel resultDic:^(NSDictionary *dic) {
            
             int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code ==1000){
                [self.dataList removeAllObjects];
                [self getOrderDetialInfor];
                [self.tableView reloadData];
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
            }
         }];
    });
}

#pragma mark ---------------原有需求代理------------
-(void)locationButtonDlegate{
    
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc]init];
    _searchAdress.delegate = self;
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
   
    if ([_model.requirment_type isEqualToString:@"0"]) {
       geoCodeOption.address = _model.seller_address;
    }
    
    BOOL flagAdd = [_searchAdress geoCode:geoCodeOption];
    if(flagAdd)
    {
        NSLog(@"geo检索发送成功");
    }else{
        NSLog(@"geo检索发送失败");
    }
}

-(void)telephoneButtonDlegate:(NSString *)tel{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}


#pragma mark ----------获取详情列表信息----------
-(void)getOrderDetialInfor{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",self.requment_id] withKey:userInfoModel.primary_key];
    In_GrapDetialListModel *inModel = [[In_GrapDetialListModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%@",self.requment_id];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]  grapDetialListWithMsg:inModel  date:^(NSDate *date){
            NSTimeInterval a = [date timeIntervalSinceDate:[NSDate date]]+60*8*60;
                _Interval = a;
         
        }
                                                 resultDic:^(NSDictionary *dic) {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     DLog(@"列表数据%@",dic);
                                                     int code=[[dic objectForKey:@"code"] intValue];
                                                     if (!dic)
                                                     {
                                                         [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                                                         
                                                     }else if (code ==1000){
                                                         [self.dataList removeAllObjects];//移除所有数据
                                                         NSDictionary *tmpdic  = dic[@"data"];
                                                         _model = [[Out_GrapDetialListBody alloc] initWithDictionary:tmpdic error:nil];
                                                         [self.dataList addObject:_model];
                                                         self.has_grabed = _model.has_grabed;
                                                         if ([_model.grab_status isEqualToString:@"1"]) {
                                                             _orderReceivingTime.text = self.model.grab_time;
                                                             _footerView.getOrder.hidden = YES;
                                                             _footerView.goWork.hidden = NO;
                                                             _footerView.cancel.hidden = NO;
                                                             self.countDown = [[CountDown alloc] init];//倒计时
                                                             __weak __typeof(self) weakSelf= self;
                                                           ///每秒回调一次
                                                             [self.countDown countDownWithPER_SECBlock:^{
                                          [weakSelf.footerView.cancel setTitle:[self getTimeStr:_model.grab_time] forState:UIControlStateNormal];
                                            weakSelf.footerView.cancel.backgroundColor = MAINCOLOR;
                                                    if([[self getTimeStr:_model.grab_time] isEqualToString:@"取消"]){
                                                        [weakSelf.footerView.cancel setTitle:@"取消" forState:UIControlStateNormal];
                                                        weakSelf.footerView.cancel.backgroundColor = [UIColor grayColor];
                                                    }
                                                             }];
                                                             
                                                         }else{
                                                             _footerView.getOrder.hidden = NO;
                                                             _footerView.goWork.hidden = YES;
                                                             _footerView.cancel.hidden = YES;
                                                         }
                                                         [self.tableView reloadData];
                                                     }else{
                                                          [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                                                     }
                                                 }];
    });
}

#pragma mark ---------返回倒计时时间--------------
-(NSString *)getTimeStr:(NSString *)fireStr
{

    NSString *theDate = fireStr;
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSTimeInterval cha = now-late;
    NSTimeInterval show ;
    if(_Interval > 0){
        cha = -cha ;
        if ((180 +(int)(cha - _Interval)) >180) {
            if ((180 -(int)(cha +_Interval)) >200) {
                show = 0;
            }else{
                show = 180;
            }
        }else{
            show = 180 +(int)(cha - _Interval);
        }
    }else{
        if ((180 -(int)(cha +_Interval)) >180) {
            if ((180 -(int)(cha +_Interval)) >200) {
                show = 0;
            }else{
            show = 180;
            }
        }else{
            show = 180 -(int)(cha + _Interval);
        }
    }
   
    if(show < 1){
        return @"取消";//如果小于0，说明时间已过去180s
    }else{
        return [NSString stringWithFormat:@"取消（%.fs）",show];
    }
}

#pragma mark -------------网点发单代理-----------
-(void)songBtnClick:(UIButton*)btn{//送货
    _record = @"1";
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc]init];
    _searchAdress.delegate = self;
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeOption.address = _model.grid_address;
   
    BOOL flagAdd = [_searchAdress geoCode:geoCodeOption];
    if(flagAdd)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

-(void)shangjiaBtnClick:(UIButton*)btn{//商家
    _record = @"2";
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc]init];
    _searchAdress.delegate = self;
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeOption.address = _model.seller_address;
  
    BOOL flagAdd = [_searchAdress geoCode:geoCodeOption];
    if(flagAdd)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

-(void)phoneButton2Click:(NSString *)tel{
    
    [self phoneButton1Click:tel];
}

@end
