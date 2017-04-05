//
//  LOrderDetailViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/26.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LOrderDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "LoginViewController.h"
#import "LSendGoodsViewController.h"

#import "orderDetailTViewCell.h"//订单详情
#import "websiteTableViewCell.h"//网格或网点订单详情

#import "LOtherSignViewController.h"

#import "MapRoaldVController.h"

#import "UnusualReasonListController.h"
#import "distributionTableViewCell.h"
#import "navLabel.h"
#import "MessageVController.h"
#define btnColor [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0]
#define lableFrame CGRectMake(0, 0, 200, 20)
@interface LOrderDetailViewController ()<LOtherSignDelegate,orderLocationDelegate,BMKGeoCodeSearchDelegate,websiteTabelDelegate,problemBackDelegate,UIGestureRecognizerDelegate>
{
    UIAlertView *AlertViewOne;
    int _type;//1配送成功 2配送异常
    int _sign_type;//1本人签收 2他人签收
    NSString *_sign_man;//签收人
    NSString *_expt_code;//配送异常编码（参考17）
    NSString *_expt_msg;//配送异常原因（参考17）
}

@property (nonatomic, strong) BMKGeoCodeSearch *searchAdress;

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,copy)NSMutableArray *dataList;
@property(nonatomic,copy)Out_detialListBody *model;

@property (nonatomic, strong) UIView *orderDealView;
@property (nonatomic, strong) UIView *signDealView;
@property(nonatomic,strong)UILabel *signLable;
@property(nonatomic,strong)UILabel *signTimeLable;
@property(nonatomic,strong)UILabel *menLabel;
@property(nonatomic,strong)UILabel *timeLbael;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *lineView;

@property (nonatomic, strong) UIButton *callPhoneBtn;
@property (nonatomic, strong) UIButton *sendMsgBtn;
@property (nonatomic, strong) UIButton *problemBtn;
@property (nonatomic, strong) UIButton *signOrderBtn;
@end

@implementation LOrderDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = ViewBgColor;
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.automaticallyAdjustsScrollViewInsets=false;
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色

    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"订单详情"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(leftItemClick)];

    if (!_orderDealView) {
        _orderDealView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,180)];
        _orderDealView.backgroundColor = ViewBgColor;
        _orderDealView.userInteractionEnabled = YES;
    }
    if(!_signDealView){
        _signDealView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 100)];
        _signDealView.backgroundColor = [UIColor whiteColor];
    }
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, 1)];
        _topView.backgroundColor = [UIColor grayColor];
        _topView.alpha = 0.1;
        [_signDealView addSubview:_topView];
    }
    if (!_menLabel) {
        _menLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 76, 35)];
        _menLabel.textAlignment = NSTextAlignmentLeft ;
        _menLabel.font = [UIFont systemFontOfSize:15];
        _menLabel.textColor = [UIColor grayColor];
        _menLabel.text = @"签收人:";
        [_signDealView addSubview:_menLabel];
    }
    
    if (!_signLable) {
        _signLable = [[UILabel alloc]initWithFrame:CGRectMake(_menLabel.x+_menLabel.width+6, 10, SCREEN_WIDTH-_menLabel.x-_menLabel.width-6-20, 35)];
        _signLable.textAlignment = NSTextAlignmentLeft ;
        _signLable.font = [UIFont systemFontOfSize:15];

        [_signDealView addSubview:_signLable];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0,_signLable.y +_signLable.height +5 , SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.1;
        [_signDealView addSubview:_lineView];
    }
    if (!_timeLbael) {
        _timeLbael = [[UILabel alloc]initWithFrame:CGRectMake(20, _signLable.y +_signLable.height +10, 76, 35)];
        _timeLbael.textAlignment = NSTextAlignmentLeft ;
        _timeLbael.font = [UIFont systemFontOfSize:15];
        _timeLbael.text = @"签收时间:";
        _timeLbael.textColor = [UIColor grayColor];
        [_signDealView addSubview:_timeLbael];
    }
    
    if (!_signTimeLable) {
         _signTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(_timeLbael.x +_timeLbael.width+6, _signLable.y +_signLable.height +10,SCREEN_WIDTH-_timeLbael.x - _timeLbael.width -26, 35)];
        _signTimeLable.textAlignment = NSTextAlignmentLeft ;
        _signTimeLable.font = [UIFont systemFontOfSize:15];
       
        [_signDealView addSubview:_signTimeLable];
    }
    
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _callPhoneBtn.backgroundColor = btnColor;
        _callPhoneBtn.frame = CGRectMake(15, 25,(SCREEN_WIDTH-60)/3,35);
        _callPhoneBtn.clipsToBounds = YES;
        _callPhoneBtn.layer.cornerRadius = 10;
        [_callPhoneBtn setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateNormal];
        [_callPhoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_callPhoneBtn addTarget:self action:@selector(callPhoneClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (!_sendMsgBtn) {
        _sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _sendMsgBtn.backgroundColor = btnColor;
        _sendMsgBtn.frame = CGRectMake(_callPhoneBtn.x+_callPhoneBtn.width+15, 25,(SCREEN_WIDTH-60)/3, 35);
        _sendMsgBtn.clipsToBounds = YES;
        _sendMsgBtn.layer.cornerRadius = 10;
        [_sendMsgBtn setImage:[UIImage imageNamed:@"icon_sms"] forState:UIControlStateNormal];
        [_sendMsgBtn setTitle:@"发送短信" forState:UIControlStateNormal];
        [_sendMsgBtn addTarget:self action:@selector(sendMsgClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (!_problemBtn) {
        _problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          _problemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _problemBtn.backgroundColor = [UIColor colorWithRed:0.8902 green:0.0588 blue:0.3255 alpha:1.0];
        _problemBtn.frame = CGRectMake(_sendMsgBtn.x+_sendMsgBtn.width+15, 25, (SCREEN_WIDTH-60)/3, 35);
        _problemBtn.clipsToBounds = YES;
        _problemBtn.layer.cornerRadius = 10;
        [_problemBtn setImage:[UIImage imageNamed:@"icon_abnormal"] forState:UIControlStateNormal];
        [_problemBtn setTitle:@"异常件" forState:UIControlStateNormal];
        [_problemBtn addTarget:self action:@selector(problemClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (!_signOrderBtn) {
        _signOrderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _signOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
        _signOrderBtn.backgroundColor = btnColor;
        [_signOrderBtn setTitle:@"签收" forState:UIControlStateNormal];
        [_signOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signOrderBtn.frame = CGRectMake(20, _problemBtn.y+_problemBtn.height+25, SCREEN_WIDTH-40, 35);
        _signOrderBtn.clipsToBounds = YES;
        _signOrderBtn.layer.cornerRadius = 10;
     
        [_signOrderBtn addTarget:self action:@selector(signOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [_orderDealView addSubview:_callPhoneBtn];
    [_orderDealView addSubview:_sendMsgBtn];
    [_orderDealView addSubview:_problemBtn];
    [_orderDealView addSubview:_signOrderBtn];
    
    [self inithomeTableView];
    [self.view addSubview:self.goodsTableview];
    
    if (self.kindType == 1) {
        self.goodsTableview.tableFooterView = _orderDealView;
    }
    [self getOrderDetail];//获取订单详情列表
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

//初始化table
-(UITableView *)inithomeTableView
{
    if (_goodsTableview != nil) {
        return _goodsTableview;
    }
    _dataList = [NSMutableArray array];
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height;
    
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _goodsTableview.delegate = self;
    _goodsTableview.dataSource = self;
    _goodsTableview.backgroundColor = ViewBgColor;
    _goodsTableview.showsVerticalScrollIndicator = NO;

    return _goodsTableview;
}

#pragma  mark  ------------订单详情---------------
-(void)getOrderDetail{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    [ZJCustomHud dismiss];
    [ZJCustomHud showWithStatus:@"努力加载中..."];
    NSString *hmac=[[communcat sharedInstance ]hmac:self.order_id withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getDetialListInfoWithkey:userInfoModel.key degist:hmac order_id:self.order_id resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int code=[[dic objectForKey:@"code"] intValue];
            [ZJCustomHud dismiss];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code == 1000)
            {
                NSDictionary *data = [dic objectForKey:@"data"];
               _model = [[Out_detialListBody alloc]initWithDictionary:data error:nil];
                [_dataList addObject:_model];
            
                if ([_model.sign_man isEqualToString:@"(null)"]  || _model.sign_man.length == 0) {
                _signLable.text = @"本人签收";
                }else{
                    _signLable.text = [NSString stringWithFormat: @"%@",_model.sign_man];
                }
                _signTimeLable.text = [NSString stringWithFormat:@"%@",_model.sign_time];
                [self.goodsTableview reloadData];
            }else{
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_status intValue] == 1) {
        if (_kindType == 2) {
            return 160;
        }else{
            orderDetailTViewCell *cell = [orderDetailTViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            return cell.cellHeight1;
        }
    }else if ([_status intValue] == 2){
        if (_kindType == 2) {
            return 130;
        }else{
            orderDetailTViewCell *cell = [orderDetailTViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            return cell.cellHeight1;
        }
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if ([_status integerValue] == 2) {
        return 100;
    }
    
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  
    if ([_status integerValue] == 2) {
        return _signDealView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if ([_status intValue] == 1) {
        if (_kindType == 2) {
            websiteTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"websiteTableViewCell" owner:self options:nil] firstObject];
            cell.timeLabel.text = _model.linghuo_time;
            if (_model.consignee_address.length >0) {
                cell.adressLabel.text = _model.consignee_address;
            }else{
               cell.adressLabel.text = @"哎呀，未找到商家!";
            }
            
            
            cell.OrderNumLabel.text = _model.order_original_id;
            self.goodsTableview.tableFooterView.hidden = YES;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            orderDetailTViewCell *cell = [orderDetailTViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            cell.delegate = self;
            self.goodsTableview.tableFooterView.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if ([_status intValue] == 2){
        if (_kindType == 2) {
            distributionTableViewCell  *cell = [distributionTableViewCell alreadyTableViewDetialCellWith:tableView indexPath:indexPath msg:_model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.goodsTableview.tableFooterView.hidden = YES;
            return cell;
        }else{
            orderDetailTViewCell *cell = [orderDetailTViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            cell.delegate = self;
            self.goodsTableview.tableFooterView.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

#pragma mark -------------CallTelePhone-------------------

- (void)callPhoneClick
{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_model.consignee_mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",_model.consignee_mobile];
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

#pragma mark --------SendMessage--------------------
- (void)sendMsgClick
{
    MessageVController *msgVC = [[MessageVController alloc] init];
    msgVC.phoneList = _model.consignee_mobile;
    msgVC.status = 1;
    
    [self.navigationController pushViewController:msgVC animated:YES];
}


#pragma mark ---------------异常原因---------------
- (void)problemClick
{
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle:@"释放" otherBtnTitle:@"拒收" otherBtn1Title:@"滞留" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 100) {//释放
            CustomAlertView *showView = [[CustomAlertView alloc] initWithTitle:@"您是否确认释放此订单?" message:@"" cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                if(clickIndex == 200){
                    _type = 3;
                    _sign_man = @"";
                    _sign_type = 0;
                    _expt_code = @"";
                    _expt_msg = @"";
                    [self distributionCoupleBack];
                }
            }];
            
            [showView showLXAlertView];
            
        }else if(clickIndex == 200){//拒收
            UnusualReasonListController *VC = [[ UnusualReasonListController alloc]init];
            VC.order_id = _model.order_original_id;
            VC.reasonKind = 2;
            VC.delegate = self;
            [self.navigationController pushViewController:VC animated:YES];
        }else{//滞留
            UnusualReasonListController *VC = [[ UnusualReasonListController alloc]init];
            VC.order_id = _model.order_original_id;
            VC.reasonKind = 1;
            VC.delegate = self;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
    //显示
    [alert showLXAlertView];
}

#pragma mark 网格或网点
-(void)problemBtnDelegate{
   
    [self problemClick];
}

#pragma mark------------配送反馈---------------------
- (void)signOrderBtnClick{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle: @"他人签收"  otherBtnTitle:@"本人签收" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 100) {
            LOtherSignViewController *otherSignVC = [[LOtherSignViewController alloc] init];
            otherSignVC.delegate = self;
          
            [self.navigationController pushViewController:otherSignVC animated:YES];
            
        }else{ //本人签收
            _sign_type = 1;
            _sign_man = _model.consignee_name;
            _type = 1;
            _expt_code = @"";
            _expt_msg = @"";
            [self distributionCoupleBack];
        }
    }];
    //显示
    [alert showLXAlertView];
}

#pragma mark 网格或网点
-(void)signBtnDelegate{
    
    [self signOrderBtnClick];
}

//代理方法实现
-(void)LOtherSignWithName:(NSString *)name{
    
    _sign_man = name;
    _sign_type = 2;
    _type = 1;
    _expt_code = @"";
    _expt_msg = @"";
    [self distributionCoupleBack];
}

#pragma mark -----------订单反馈------
-(void)distributionCoupleBack{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",_model.order_original_id],[NSString stringWithFormat:@"%d",_type],[NSString stringWithFormat:@"%d",_sign_type],[NSString stringWithFormat:@"%@",_sign_man],[NSString stringWithFormat:@"%@",_expt_code],[NSString stringWithFormat:@"%@",_expt_msg],@"",nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_distributionBackModel *inModel = [[In_distributionBackModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.order_id = [NSString stringWithFormat:@"%@",_model.order_original_id];
    inModel.type = [NSString stringWithFormat:@"%d",_type];
    inModel.sign_type = [NSString stringWithFormat:@"%d",_sign_type];
    inModel.sign_man = [NSString stringWithFormat:@"%@",_sign_man];
    inModel.expt_code = [NSString stringWithFormat:@"%@",_expt_code];
    inModel.expt_msg = [NSString stringWithFormat:@"%@",_expt_msg];
    inModel.next_delivery_time = @"";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getDistributionBackInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if (code == 1000){
                    if (_type == 3) {
                        [[KNToast shareToast] initWithText:@"释放成功" duration:1 offSetY:0];
                    }else if (_type == 2){
                        [[KNToast shareToast] initWithText:@"反馈成功" duration:1 offSetY:0];
                    }else{
                        [[KNToast shareToast] initWithText:@"签收成功" duration:1 offSetY:0];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
            } );
        }];
    });
}

#pragma mark cellDelegate方法
-(void)orderDetailLocation:(UIButton*)btn
{
    //初始化检索对象
    _searchAdress =[[BMKGeoCodeSearch alloc] init];
    _searchAdress.delegate = self;
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeOption.address =_model.consignee_address;
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

        MapRoaldVController*map=[[MapRoaldVController alloc]init];
  
        map.address=_model.consignee_address;
        map. templatitude=item.coordinate.latitude;
        map.templongitude=item.coordinate.longitude;
        [self.navigationController pushViewController:map animated:YES];
        //        _latAndLong=item.coordinate;
        //        [_mapView addAnnotation:item];
        //        _mapView.centerCoordinate = result.location;
    }
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _searchAdress.delegate = nil;
    if ([self.delegate respondsToSelector:@selector(backBtnClick:)]) {
        
        [self.delegate backBtnClick:self.status];
    }
//     self.tabBarController.tabBar.hidden = NO;
}

-(void)problemBack{
    
    [self leftItemClick];
}

@end
