//
//  HomePageViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/5.
//  Copyright © 2015年 xc. All rights reserved.

#import "HomePageViewController.h"
#import "scrapeOrderDetailVController.h"
#import "scrapeOrderDetailVController.h"//订单详情
#import "BDMapVController.h"
#import "MapRoaldVController.h"
#import "LoginViewController.h"
#import "publicResource.h"
#import "AppDelegate.h"
#import "JKNotifier.h"
#import "UIView+SDAutoLayout.h"
#import "ApplyBrokerViewController.h"
#import "MJRefresh.h"
#import "homeHeaderView.h"
#import "HomeTableViewCell.h"
#import "HomeSecTableViewCell.h"
#import "NotificationViewController.h"
#define TableViewCell @"TableViewCell"
#define secondCell @"secondCell"
#import "CountDown.h"//倒计时
#import "citySelectViewController.h"//选择城市
#import "LScannerViewController.h"//去扫描

#import "IPViewController.h"//修改IP地址
@interface HomePageViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,GrabAsingleDelegate,BMKGeoCodeSearchDelegate,orderReceivingBtnDelegate>
{
    UIAlertView  *_alertGoLogin;
    UIView *_view1;
    NSString *  _pemission;
    int _maxOrders;
    int  _offset;//	int	分页起始值从0开始
    int _pagesize	;//int	每页显示个数
    NSString *  delivery_count;//	string	意向配送单量
    int  requirment_id;//int	需求id
    NSString *statusName;
    NSInteger _record;//记录推送
    NSInteger _cancellRecord;//记录取消
    NSString *_has_grabed;//记录每天是否是第一次抢单
    int _deduct;//保险开关 1扣取  0不扣取
    NSString *_order_original_id;//订单号
    NSTimeInterval  _Interval;
    NSString *_location;
    NSString * _grab_time;
    int _grab_staus;
    BOOL _isFooterRefresh;
}

@property (nonatomic, strong) NSMutableArray *dataAry;
@property(nonatomic,strong)UITableView *homeTableView;
@property(nonatomic,strong)Out_GrapOrderBody *model;
@property (nonatomic, strong) BMKGeoCodeSearch *searchAdress;
@property(nonatomic,strong) noConnetView *viewbg;
@property(nonatomic,copy)NSString *city;//选择城市
@property (strong, nonatomic)  CountDown *countDown;
//navigationBarItem
@property(nonatomic,strong)UIView *leftView;
@property (nonatomic, strong) UIButton *leftItem;
@property(nonatomic,strong)UIButton *leftDown;

@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIButton *rightItem;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)HomeTableViewCell *fistcell;
@property(nonatomic,strong)HomeSecTableViewCell *cell;

@end

@implementation HomePageViewController
//懒加载
-(NSMutableArray*)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    [self setUpNavigationItem];
    
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.primary_key.length == 0 || [userInfoModel.primary_key isEqualToString:@""]|| !userInfoModel.primary_key){
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        _offset = 0;
        _pagesize = 10;
        [self.dataAry removeAllObjects];
        [self.homeTableView reloadData];
        [self allOrderList];//获取抢单列表
        self.countDown = [[CountDown alloc] init];//倒计时
        __weak __typeof(self) weakSelf= self;
        ///每秒回调一次
        [self.countDown countDownWithPER_SECBlock:^{
            [weakSelf updateTimeInVisibleCells];
        }];
        //string 邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
    
        if ([userInfoModel.authen_status isEqualToString:@"-1"] ){
            CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"您还未认证达人\n是否验证成为邦办达人?" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 200) {
                    ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
                    [self .navigationController pushViewController:broker animated:YES];
                }
            }];
            //显示
//            [alert showLXAlertView];
            [alert showLXAlertViewWhitViewController:self.view];
            
        }else if ([userInfoModel.authen_status isEqualToString:@"0"] ){
            
            [[KNToast  shareToast] initWithText:@"您的信息正在审核,请耐心等待" duration:1 offSetY:0];
            
        }else  if ([userInfoModel.authen_status isEqualToString:@"2"] ){
            CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"身份验证失败\n验证失败!是否重新认证?" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 200) {
                    ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
                    [self .navigationController pushViewController:broker animated:YES];
                }
            }];
            //显示
//            [alert showLXAlertView];
            [alert showLXAlertViewWhitViewController:self.view];

        }
    }
}

#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataAry removeAllObjects];
            [self.homeTableView reloadData];
            _offset = 0;
            _pagesize = 10;
            [self allOrderList];
            // 结束刷新
            [self.homeTableView.mj_header endRefreshing];
        });
    }];
    
    //进入后自动刷新
    [self.homeTableView.mj_footer
     beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.homeTableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.homeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pagesize = 10;
            //_offset++;
            _isFooterRefresh=YES;
            [self allOrderList];
            // 结束刷新
            [self.homeTableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.homeTableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邦办即达";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MAINCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = ViewBgColor;
 
    _pemission = @"NO";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (!_viewbg){
        _viewbg = [[noConnetView alloc]initWithName:@"error"];
        _viewbg.frame=CGRectMake(0, 150, SCREEN_WIDTH,SCREEN_HEIGHT-150);
    }
    
    [self inithomeTableView];
    homeHeaderView *headerView= [[homeHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _homeTableView.tableHeaderView = headerView;
  
    _city = userInfoModel.city_name;
    [self setupRefresh];//刷新控件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityWithName:)   name:@"citySelect2" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infor:) name:@"tuiSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"city" object:nil];
    _isFooterRefresh=NO;
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame=CGRectMake(0, 0, 100, 100);
//    [btn setTitle:@"修改IP" forState:UIControlStateNormal];
//    btn.backgroundColor=[UIColor redColor];
//    [btn addTarget:self action:@selector(changeIP) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

//-(void)changeIP{
//    IPViewController *root=[[IPViewController alloc]init];
//    UIWindow  * window=  [[UIApplication sharedApplication].delegate window] ;
//    window.rootViewController=root;
//    
//    [ window makeKeyAndVisible];
//}

-(void)didSelectCityWithName:(NSNotification*) notification
{
    NSString * cityname = [notification object];//通过这个获取到传递的对象
    _city = cityname;
    [_leftItem setTitle:[NSString stringWithFormat:@"%@",_city] forState:UIControlStateNormal];
}

//修改个人信息后获取修改后的城市
-(void)changeCity:(NSNotification*)notify{
     NSString *city = notify.userInfo[@"city"];//通过这个获取到传递的对象
    _city = city ;
    [_leftItem setTitle:[NSString stringWithFormat:@"%@",_city] forState:UIControlStateNormal];
}

-(void)inithomeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _homeTableView.backgroundColor = [UIColor clearColor];
        _homeTableView.dataSource = self;
        _homeTableView.delegate = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_homeTableView];
    }
    //注册1
    [_homeTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell];
    //注册2
     [_homeTableView registerNib:[UINib nibWithNibName:@"HomeSecTableViewCell" bundle:nil] forCellReuseIdentifier:secondCell];
    
}

#pragma mark------------tableViewDateSource----------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataAry.count > 0) {
        NSMutableDictionary* tmpdic = _dataAry[indexPath.section];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:tmpdic error:nil];
    }
    if ([_model.requirment_type isEqualToString:@"0"]){
        return 230;
        
    }else{
    HomeSecTableViewCell *height1 =  [[[NSBundle mainBundle]loadNibNamed:@"HomeSecTableViewCell" owner:nil options:nil] firstObject];
    [height1 setModel:_model];
    return height1.cellHeight;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataAry.count > 0) {
        NSMutableDictionary* tmpdic = _dataAry[indexPath.section];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:tmpdic error:nil];
    }
    if ([_model.requirment_type isEqualToString:@"0"]){//需求订单
        HomeTableViewCell * cell = [HomeTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.section;
        cell.delegate = self;
     
        [cell.cancellBtn setTitle:[self getTimeStr:_model.grab_time] forState:UIControlStateNormal];
        cell.cancellBtn.backgroundColor = MAINCOLOR;
        if([cell.cancellBtn.titleLabel.text isEqualToString:@"取消"]){
            cell.cancellBtn.backgroundColor = [UIColor grayColor];
        }
        return cell;
        
    }else{//网点或网格订单
        HomeSecTableViewCell * cell = [HomeSecTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
        cell.tag = indexPath.section;
        [cell.cancellBtn setTitle:[self getTimeStr:_model.grab_time] forState:UIControlStateNormal];
        cell.cancellBtn.backgroundColor = MAINCOLOR;
        if([cell.cancellBtn.titleLabel.text isEqualToString:@"取消"]){
            cell.cancellBtn.backgroundColor = [UIColor grayColor];
        }
        cell.delegate = self;
        [cell setModel:_model];
        return cell;
    }
    
}

#pragma mark -----------tableViewSelect------------

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataAry.count > 0) {
     NSMutableDictionary * tmpdic = _dataAry[indexPath.section];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:tmpdic error:nil];
    }
    scrapeOrderDetailVController * vc = [[ scrapeOrderDetailVController  alloc] init];
    vc.requment_id = _model.requirment_id;
    vc.seller_type = _model.seller_type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---------------HomeTableViewCellDelegate
#pragma mark -------------原需求接单按钮被点击
-(void)GrabAsingle:(int)num;//抢单
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if ([userInfoModel.key isEqualToString:@""] || !userInfoModel.key ||userInfoModel.key.length == 0) {
        return;
    }
    if ([userInfoModel.authen_status isEqualToString:@"2"] ){
        [[KNToast shareToast] initWithText:@"达人认证失败，暂不能接单，赶快重新认证再来接单吧！" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"-1"]){
        [[KNToast shareToast] initWithText:@"您还未认证达人，暂不能接单!" duration:1 offSetY:0];
        return;
    }else if ([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"您的认证还未通过，暂不能接单!" duration:1 offSetY:0];
        return;
    }
    requirment_id = num;
    
    if ([_has_grabed isEqualToString:@"0"] && _deduct == 1) {// false未抢过单
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"每日完成订单配送后扣取1元保险费，是否确认接单？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
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

#pragma mark -------------原需求取消按钮点击
-(void)cancellBtnDlegate:(UIButton *)btn{
    if (self.dataAry.count > 0) {
        NSMutableDictionary *dic=self.dataAry[btn.tag-1000];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic error:nil];
    }
    requirment_id = [_model.requirment_id intValue];
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@" 取消订单将会扣除200积分！\n是否确认取消？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
            
            [self cancellOrder];
        }
    }];
    //显示
    [alert showLXAlertView];
}

#pragma mark ------------取消订单接口---------
-(void)cancellOrder{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%d",requirment_id] withKey:userInfoModel.primary_key];
    In_cancellModel *inModel = [[In_cancellModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%d",requirment_id];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] cancellOrderWithMsg:inModel resultDic:^(NSDictionary *dic) {
            
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[KNToast shareToast] initWithText:@"网络不给力,请稍后重试!" duration:1 offSetY:0];
            }else if (code ==1000){
                [[KNToast shareToast] initWithText:@"订单已成功取消!" duration:1 offSetY:0];
                [self getStatusWithInfor];//接单状态信息
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
            }
        }];
    });
}

#pragma mark ------------原需求去扫描点击代理
-(void)workBtnDlegate:(UIButton *)btn{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"suckEffect";
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    if (self.dataAry.count > 0) {
        NSMutableDictionary *dic= self.dataAry[btn.tag-10000];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic error:nil];
    }
    
    LScannerViewController *VC = [[LScannerViewController alloc] init];
    
    VC.requirment_id = _model.requirment_id;
    if ([_model.seller_type isEqualToString:@"5"] ||[_model.seller_type isEqualToString:@"1"]) {
        VC.seller_type = @"1";
    }else{
        VC.seller_type = @"-1";
    }
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark   网格或网点去扫描按钮点击
-(void)workBtnClick:(UIButton *)btn{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = @"suckEffect";//立体
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    
    if (self.dataAry.count > 0) {
        NSMutableDictionary *dic=self.dataAry[btn.tag];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic error:nil];
    }
    LScannerViewController *VC = [[LScannerViewController alloc] init];
    
    VC.requirment_id = _model.requirment_id;
    if ([_model.seller_type isEqualToString:@"5"]||[_model.seller_type isEqualToString:@"1"]) {
        VC.seller_type = @"1";
    }else{
        VC.seller_type = @"-1";
    }
    
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark-------- 原需求定位按钮点击代理
-(void)locationDlegate:(UIButton *)btn{
   NSMutableDictionary *  tmpdic = _dataAry[btn.tag-100];
    _model=[[Out_GrapOrderBody alloc]initWithDictionary:tmpdic error:nil];
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc]init];
    _searchAdress.delegate = self;
    
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    if([_model.requirment_type isEqualToString:@"0"]){
        geoCodeOption.address = _model.seller_address;
        _location = _model.seller_address;
    }else{
        geoCodeOption.address = _model.grid_address;
        _location = _model.grid_address;
    }
    BOOL flagAdd = [_searchAdress geoCode:geoCodeOption];
    if(flagAdd)
    {
        NSLog(@"geo检索发送成功");
    }else{
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
       
        MapRoaldVController *map=[[MapRoaldVController alloc]init];
        map.address = _location;
        map. templatitude = item.coordinate.latitude;
        map.templongitude = item.coordinate.longitude;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:map animated:YES];
    }
}

#pragma mark-------------------HomeSecTableViewCellDelegate
#pragma mark --------------网格或网点需求接单按钮代理
-(void)orderReceivingBtn:(int)num{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([userInfoModel.key isEqualToString:@""] || !userInfoModel.key ||userInfoModel.key.length == 0) {
        return;
    }
    if ([userInfoModel.authen_status isEqualToString:@"2"] ){
        [[KNToast shareToast] initWithText:@"达人认证失败，暂不能接单，赶快重新认证再来接单吧！" duration:1 offSetY:0];
        return;
    }else if([userInfoModel.authen_status isEqualToString:@"-1"]){
        [[KNToast shareToast] initWithText:@"您还未认证达人，暂不能接单!" duration:1 offSetY:0];
        return;
    }else if ([userInfoModel.authen_status isEqualToString:@"0"]){
        [[KNToast shareToast] initWithText:@"您的认证还未通过，暂不能接单!" duration:1 offSetY:0];
        return;
    }
    requirment_id = num;
    
    if ([_has_grabed isEqualToString:@"0"] && _deduct == 1) {
        CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"每日完成订单配送后扣取1元保险费，是否确认接单？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
                _cell.cancellBtn.hidden = NO;
                _cell.WorkBtn.hidden = NO;
                _cell.orderReceivingBtn.hidden = YES;
                [self getOrder];
            }
        }];
        [alert showLXAlertView]; //显示
    }else{
        [self getOrder];//直接接单
    }
}

#pragma mark --------网格或网点需求取消按钮代理
-(void)cancellBtn1Click:(int)index{
    
    if (self.dataAry.count > 0) {
        NSMutableDictionary *dic=self.dataAry[index];
        _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic error:nil];
    }
    requirment_id = [_model.requirment_id intValue];
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@" 取消订单将会扣除200积分！\n是否确认取消？" message:@"" cancelBtnTitle: @"取消"  otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
            [self cancellOrder];
        }
    }];
    //显示
    [alert showLXAlertView];
}

#pragma mark   定位按钮点击 网格,网点
-(void)locationBtnClick:(UIButton *)btn{
    
    [self locationDlegate:btn];
}

#pragma mark --------------收到极光后更新信息通知--------------
-(void)infor:(NSNotification*)infor{
    NSString *message = infor.userInfo[@"message"];
    if (![message isEqualToString:@""]) {
        if (![message isEqualToString:@"您有一条新消息:有新需求了，快去抢单吧!"]) {
            _record = 1;
        }
    }
    [self setUpNavigationItem];
    [self.homeTableView.mj_header beginRefreshing];//收到极光刷新表格
}

#pragma  mark  获取抢单需求列表
- (void)allOrderList
{
   // return;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (!_city || [_city isEqualToString:@""]) {
        _city = userInfoModel.city_name;
    }
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        return;
    }
    
    if([userInfoModel.status isEqualToString:@"2"]){
        _viewbg.label.text = @"您的账号已被冻结，如有疑问请联系客服";
        [self.dataAry removeAllObjects];
        _viewbg.imgbg.hidden = NO;
        _viewbg.label.hidden = NO;
        [_homeTableView addSubview:_viewbg];
        [_homeTableView reloadData];
        return;
    }else if([userInfoModel.status isEqualToString:@"3"]){
        _viewbg.label.text = @"您的账号已被注销，如有疑问请联系客服";
        [self.dataAry removeAllObjects];
        _viewbg.imgbg.hidden = NO;
        _viewbg.label.hidden = NO;
        [_homeTableView addSubview:_viewbg];
        [_homeTableView reloadData];
        return;
    }else{
        _viewbg.label.text = @"当前无订单，请稍候再来";
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_pagesize],_city,nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_GrapOrderModel *inModel = [[In_GrapOrderModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    inModel.pagesize = [NSString stringWithFormat:@"%d",_pagesize];
    inModel.city_name = _city;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] getGrapListWithMsg:inModel date:^(NSDate *date) {
            
            NSTimeInterval a = [date timeIntervalSinceDate:[NSDate date]]+60*8*60;
                    _Interval = a;
        } resultDic:^(NSDictionary *dic) {
  
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
            }else if (code == 1000){
                
                 if ( [[dic objectForKey:@"data"] isEqual:[NSNull null]]){
                    [[iToast makeText:@"暂无数据"] show];
                }else{
                    if (_isFooterRefresh==YES) {
                        _isFooterRefresh=NO;
                        _offset++;
                    }
                NSString *grabed  = [dic objectForKey:@"data"][@"has_grabed"];
               
                if ([grabed boolValue] == 1) {
                    _has_grabed = @"1";
                }else{
                    _has_grabed = @"0";
                }
                NSString*  deduct = [dic objectForKey:@"data"][@"deduct"];
                _deduct = [deduct intValue];
                NSArray *requirment_list = [dic objectForKey:@"data"][@"requirment_list"];
                if (requirment_list.count == 0 && _offset>0) {
                    [[KNToast shareToast] initWithText:@"别拉了，已经加载到最后了！" duration:1 offSetY:SCREEN_HEIGHT-49-64];
                    return ;
                }
                for (NSDictionary *tmpdic in requirment_list) {
                    DLog(@"抢单首页  %@ ",tmpdic);
                    if (![self.dataAry containsObject:tmpdic]){
                        [self.dataAry addObject:tmpdic];
                    }
                }
                if (self.dataAry.count == 0) {
                    _viewbg.imgbg.hidden = NO;
                    _viewbg.label.hidden = NO;
                    [_homeTableView addSubview:_viewbg];
                }else{
                    _viewbg.imgbg.hidden = YES;
                    _viewbg.label.hidden = YES;
                    [_viewbg removeFromSuperview];
                }
            
                [_homeTableView reloadData];
                }
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                
                if (code == 1002) {
                    LoginViewController *vc = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController: vc animated:YES];
                }
            }
                
        }];
    });
}

#pragma mark  抢单调用接口（网络请求 更改用户信息，刷新表格）
- (void)getOrder
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%d",requirment_id] withKey:userInfoModel.primary_key];
    In_GraplistModel *inModel = [[In_GraplistModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%d",requirment_id];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] grapListWithMsg:inModel resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
      
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
            }else if (code ==1000){
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                  [self getStatusWithInfor];
                });
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
            }
        }];
    });
}

#pragma mark 更新个人信息(获取最多配单量)
-(void)upDataUserMag{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
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
                
            }else if (code ==1000){
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
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
            }
        }];
    });
}

#pragma  mark 打电话
-(void)onPhoneClick:(UIButton *)phone;
{
    NSString *telPhone=[NSString stringWithFormat:@"%ld",(long)phone.tag ];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:telPhone message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",telPhone];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        ApplyBrokerViewController *broker=[[ApplyBrokerViewController alloc]init];
        [self .navigationController pushViewController:broker animated:YES];
    }
}

//左侧导航按钮点击
-(void)leftNavItemClick{
    citySelectViewController *citySelect=[[citySelectViewController alloc]init];
    citySelect.status = 2;
   
    [self.navigationController pushViewController:citySelect animated:YES];
}


//右侧导航按钮点击
-(void)tongZhiBtnClick{
    _record = 0;
    
    NotificationViewController *VC = [[NotificationViewController alloc]init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"pageCurl";
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
     self.hidesBottomBarWhenPushed = NO;
    
}

-(void)setUpNavigationItem{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([_city isEqualToString:@""]||!_city||_city.length==0) {
        _city = userInfoModel.city_name;
    }
    if (!_leftView) {
        _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    if (!_leftItem) {
        _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftItem.frame = CGRectMake(0, 0, 50, 30);
        [_leftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftItem.titleLabel.font = MiddleFont;
        _leftItem.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_leftItem addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftView addSubview:_leftItem];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftView];
    }
    if (!_leftDown) {
        _leftDown = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftDown.frame = CGRectMake(_leftItem.x+_leftItem.width, 10, 10, 10);
        [_leftDown setBackgroundImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
        [_leftView addSubview:_leftDown];
    }
    if (!_rightView) {
        _rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 0,30 , 30)];
    }
    
    if (!_rightItem) {
        _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightItem.frame = CGRectMake(0, 0, 30, 30);
        [_rightItem setImage:[UIImage imageNamed:@"btn_message"] forState:UIControlStateNormal];
        [_rightItem addTarget:self action:@selector(tongZhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightView addSubview:_rightItem];
      
        _rightItem.badgeFont = [UIFont boldSystemFontOfSize:11];
        _rightItem.badgeCenterOffset = CGPointMake(-10, 8);
        [_rightItem showBadgeWithStyle:WBadgeStyleNumber value:100 animationType:WBadgeAnimTypeScale];
           self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightView];
    }
    
    //有消息时候推送时显示
    if (_record == 1) {
        _rightItem.badgeBgColor = [UIColor redColor];
        _rightItem.badgeTextColor = [UIColor clearColor];
    }else{
        _rightItem.badgeBgColor = [UIColor clearColor];
        _rightItem.badgeTextColor = [UIColor clearColor];
    }
    
    [_leftItem setTitle:[NSString stringWithFormat:@"%@",_city] forState:UIControlStateNormal];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -------------------倒计时--------------
//返回倒计时时间
-(NSString *)getTimeStr:(NSString *)fireStr
{
    if(!fireStr ||fireStr.length==0 || [fireStr isEqualToString:@""]){
        return nil;
    }
    NSString *theDate = fireStr;
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSTimeInterval cha = now - late;
    NSTimeInterval show;
    if(_Interval > 0){
        cha = -cha ;
        if ((180 +(int)(cha - _Interval)) >180) {
            show = 180;
        }else{
            show = 180 +(int)(cha - _Interval);
        }
    }else{
        if ((180 -(int)(cha +_Interval)) >180) {
            show = 180;
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

//每秒更新可见cell的倒计时时间
-(void)updateTimeInVisibleCells{
    NSArray  *cells = self.homeTableView.visibleCells; //取出屏幕可见cell
    if (cells.count == 0) {
        return;
    }else{
        for (HomeTableViewCell *cell in cells) {
            if (self.dataAry.count >0 ) {
                NSMutableDictionary *dic=self.dataAry[cell.tag];
                _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic error:nil];
            }
            [cell.cancellBtn setTitle:[self getTimeStr:_model.grab_time] forState:UIControlStateNormal];
            cell.cancellBtn.backgroundColor = MAINCOLOR;
            if([cell.cancellBtn.titleLabel.text isEqualToString:@"取消"]){
                cell.cancellBtn.backgroundColor = [UIColor grayColor];
            }
        }
        for (HomeSecTableViewCell *cell in cells) {
            if (self.dataAry.count >0 ) {
                NSMutableDictionary *dic2=self.dataAry[cell.tag];
                _model = [[Out_GrapOrderBody alloc] initWithDictionary:dic2 error:nil];
            }
            
            [cell.cancellBtn setTitle:[self getTimeStr:_model.grab_time] forState:UIControlStateNormal];
            cell.cancellBtn.backgroundColor = MAINCOLOR;

            if([cell.cancellBtn.titleLabel.text isEqualToString:@"取消"]){
                cell.cancellBtn.backgroundColor = [UIColor grayColor];
            }
            
        }
    }
}

//接单//抢单  之后更新
-(void)updataDIc{
    for (int k = 0;k < _dataAry.count;k++) {
        NSMutableDictionary *dicTmp = _dataAry[k];
        NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
        [dic2 setValuesForKeysWithDictionary:dicTmp];
        if ([[NSString stringWithFormat:@"%d",requirment_id] isEqualToString:[NSString stringWithFormat:@"%@",dic2[@"requirment_id"]]]) {
            
            [dic2 setValue:[NSString stringWithFormat:@"%d",_grab_staus] forKey:@"grab_status"];
            
            [dic2 setValue:_grab_time forKey:@"grab_time"];
            
            [_dataAry replaceObjectAtIndex:k withObject:dic2];
        
            break;
        }
    }
}

#pragma mark ----------获取每个订单改变后状态--------------
-(void)getStatusWithInfor{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%d",requirment_id] withKey:userInfoModel.primary_key];
    In_GrapDetialListModel *inModel = [[In_GrapDetialListModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.requirment_id = [NSString stringWithFormat:@"%d",requirment_id];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]  grapDetialListWithMsg:inModel  date:^(NSDate *date){
            
        }resultDic:^(NSDictionary *dic) {
      
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code ==1000){
                NSDictionary *tmpdic  = dic[@"data"];
                _deduct = [tmpdic[@"deduct"] intValue];
                
                NSString *grabed  = tmpdic[@"has_grabed"];
                if ([grabed boolValue] == 1) {
                    _has_grabed = @"1";
                }else{
                    _has_grabed = @"0";
                }
                _grab_time = tmpdic[@"grab_time"];
                _grab_staus = [tmpdic[@"grab_status"]
                               intValue];
                [self updataDIc];
             
                    [_homeTableView reloadData];
                
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
            }
        }];
    });
}

@end
