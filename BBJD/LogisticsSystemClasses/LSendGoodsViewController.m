//
//  LSendGoodsViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/25.
//  Copyright © 2016年 xc. All rights reserved.

#import "LSendGoodsViewController.h"
#import "LoginViewController.h"
#import "LOrderDetailViewController.h"
#import "DimChectViewController.h"
#import "MJRefresh.h"
#import "noConnetView.h"
#import "LOrderDetailViewController.h"//订单详情
#import "distributionTableViewCell.h"//分配中的cell
#import "websiteTableViewCell.h"
#import "LGoodsListTableViewCell.h"
#import "UnusualReasonListController.h"
#import "LOtherSignViewController.h"
#import "problemFooterView.h"
#import "singnFooterView.h"
#import "orderDetailTViewCell.h"
#import "MapRoaldVController.h"
#import "CustomTransization.h"
#import "sendMsgTableViewCell.h"
#import "MessageVController.h"

#define sendOrderListCell @"sendOrderListCell"
#define normalColor [UIColor colorWithRed:0.5333 green:0.4588 blue:0.6471 alpha:1.0]
#define whiteColor [UIColor whiteColor]

@interface LSendGoodsViewController ()<UISearchDisplayDelegate,LOrderListDelegate,ScannerGoodsDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,backBtnClickDelegate,distributionDelagate,LOtherSignDelegate,orderLocationDelegate,BMKGeoCodeSearchDelegate,problemBackDelegate,UIScrollViewDelegate>
{
    UIButton *_searchBtn;
    int _btnMove;//扫码搜索按钮移动
    int _pageIndex;//分页大小
    float lastContentOffset;
    /**
     *  送货列表请求网络参数
     */
    int _status;//1配送中 2已签收 3异常件
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    NSString *_word;//模糊查询字段
    NSString *_word_scan;//模糊查询字段
    BOOL _isFooterRefresh;
    /**
     *  存储配送状态
     */
    int _sending_count;//配送中订单量
    int _expt_count;//异常件数量
    int _sign_count;//已签收数量
  
    /**
     *  记录配送状态
     */
    NSInteger _sendingRecord;//配送中 1需求 2网点
    NSInteger _alreadySendRecord;//已配送
    NSInteger _problemRecord;//异常件
   
    /**
     *  反馈信息
     */
    
    int _type;//1配送成功 2配送异常 3释放
    int _sign_type;//1本人签收 2他人签收
    NSString *_sign_man;//签收人
    NSString *_expt_code;//配送异常编码（参考17）
    NSString *_expt_msg;//配送异常原因（参考17）
    NSString *_next_delivery_time;//下次配送时间
    NSString *_order_original_id;//订单号
    
    BOOL  _allSelected;//记录是否全部选中按钮
    BOOL _sendMsgSelected;//记录是否点击群发短信按钮
    
}


@property (nonatomic, strong) UITextField *searchText;
@property(nonatomic,strong)noConnetView *viewbg;//没有数据显示
@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)Out_sendGoodsBody *model;

///头部类型选择按钮view
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *sendIngBtn;
@property (nonatomic, strong) UIButton *alreadySendBtn;
@property (nonatomic, strong) UIButton *problemBtn;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImgview;
@property (nonatomic, strong) UIButton *scannerBtn;
@property (nonatomic, strong) BMKGeoCodeSearch *searchAdress;
@property (nonatomic,strong)UILabel *animateLabel;
@property(nonatomic,strong)UIButton *sendMsgBtn;//发送短信

@property(nonatomic,strong)UIView *headerView;//头视图
@property(nonatomic,strong)UIButton *allBtn;//全选
@property(nonatomic,strong)UIButton *cancellBtn;//取消
@property(nonatomic,strong)UIButton *sendMessage;//发短信
@property(nonatomic,strong)NSMutableArray *msgArray;

@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)NSMutableArray *recordArray;
@property(nonatomic,strong)UIButton *rightBtn;
@end

@implementation LSendGoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    [self button1Click];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
    _word_scan = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    if (!_viewbg) {
        _viewbg=[[noConnetView alloc]initWithName: @"error"];
        _viewbg.frame = CGRectMake(0, 150, SCREEN_WIDTH,SCREEN_HEIGHT-150);
    }
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"送货"];
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    //生成顶部右侧按钮
   _rightBtn
    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,25,25)];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_扫描.png"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(scannerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    _word_scan = @"";
    _offset = 0;
    _isFooterRefresh=NO;
    [self initWithSubViews];//加载头部视图
    [self inithomeTableView];
    [self assignment];
    [self inithomeTableView];
    [self.view addSubview:_goodsTableview];
    [self setupRefresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifChange:) name:@"scan-out" object:nil];//扫描订单查询
    _page_size = 10;
    _word = @"";
}

//扫描订单号查询
-(void)notifChange:(NSNotification*) notification
{
    _word_scan = [notification object];//通过这个获取到传递的对象
}

#pragma mark ------------模糊查询-------------
-(void)scannerBtnClick{
    
    DimChectViewController *vc = [[DimChectViewController alloc]init];
    vc.delegate = self;

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -------扫描查询代理----
-(void)getOrder_id:(NSString *)order_id{
    _word_scan = order_id;
    _offset = 0;
    _page_size = 10;
    _word = _word_scan;
    [self.dataList removeAllObjects];
    [self getSendOrderList:1];
}

//初始化tableView
-(void)inithomeTableView
{
    _dataList = [NSMutableArray array];
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 98.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height - 98;
    
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.goodsTableview.delegate = self;
    self.goodsTableview.dataSource = self;
    self.goodsTableview.backgroundColor = ViewBgColor;
    
    self.goodsTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.goodsTableview];
  
    
}
#pragma mark 监听tableView的偏移，如果选中状态，偏移量小于0，偏移量置为0
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_sendMsgSelected) {
        if(self.goodsTableview.contentOffset.y<=0){
            self.goodsTableview.contentOffset = CGPointMake(0, 0);
        }
    }
}

#pragma  mark -------tableView delegate-------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_sendMsgSelected) {
        return self.msgArray.count;
    }else{
        
        return self.dataList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_sendMsgSelected) {
        if (self.msgArray.count > 0) {
            _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.msgArray[indexPath.section] error:nil];
        }
        sendMsgTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"sendMsgTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setModel:_model];
        return cell.height;
            
    }else{
    
    if(self.dataList.count >0){
        NSDictionary *dic = self.dataList[indexPath.section];
        _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
    }
    if(_status == 1){
        distributionTableViewCell *cell = [distributionTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
        if (_sendingRecord == 1) {
            return cell.cellHeight1;
        }else{
            return 130;
        }
    }else if(_status == 2){
        distributionTableViewCell *cell = [distributionTableViewCell  alreadyTableViewCellWith:tableView indexPath:indexPath msg:_model];
        if (_alreadySendRecord == 1) {//需求
            return cell.cellHeight2;
        }else{
            return 110;
        }
        
    }else{//异常件
        if (_problemRecord == 1) {
            orderDetailTViewCell *cell = [orderDetailTViewCell  tableViewCellWith:tableView indexPath:indexPath msg:_model];
            return cell.cellHeight2;
        }else{
             websiteTableViewCell *cell = [websiteTableViewCell webTableViewCellWith:tableView indexPath:indexPath msg:_model];
            return cell.cellHeight2;
        }
    }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_sendMsgSelected) {
        if(self.msgArray.count >0){
            NSDictionary *dic = self.msgArray[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        static NSString *msgCell = @"msgCell";
        
        sendMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCell];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"sendMsgTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.isSelected = _allSelected;
        cell.subject = [RACSubject subject];
        //是否被选中
        if ([self.recordArray containsObject:self.msgArray[indexPath.section]]) {
            cell.isSelected  = YES;
        }
        
        [cell.subject subscribeNext:^(id x) {
          
            if ([x isEqualToString:@"1"]) {
                [self.recordArray addObject:self.msgArray[indexPath.section]];
            }
            else
            {
                [self.recordArray removeObject:self.msgArray[indexPath.section]];

            }
            if (self.selectArray.count == self.msgArray.count) {
                _allSelected = YES;
                [_allBtn setTitle:@"全不选" forState:UIControlStateNormal];
            }else{
                [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
                _allSelected = NO;
            }
        }];
        [cell setModel:_model];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (_status == 1){//配送中
            if(self.dataList.count >0){
                NSDictionary *dic = self.dataList[indexPath.section];
                _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
            }
            distributionTableViewCell *cell = [distributionTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            if ((_model.consignee_address.length == 0) ||[_model.consignee_address isEqualToString:@""] ||!_model.consignee_address ) {
                _sendingRecord = 2;
            }
            else
            {
                _sendingRecord = 1;
                [cell.contentView addSubview:cell.reasonBtn];
                [cell.contentView addSubview: cell.signBtn];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            
        }else if(_status == 2){//已签收
            if(self.dataList.count >0){
                NSDictionary *dic = self.dataList[indexPath.section];
                _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
            }
            distributionTableViewCell *cell = [distributionTableViewCell  alreadyTableViewCellWith:tableView indexPath:indexPath msg:_model];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_model.consignee_address.length == 0 || [_model.consignee_address isEqualToString:@""] ) {
                
                _alreadySendRecord = 2;
            }else{
                _alreadySendRecord = 1;
                
            }
            return cell;
            
        }else{//异常件
            if(self.dataList.count >0){
                NSDictionary *dic = self.dataList[indexPath.section];
                _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
            }
            
            if (_model.consignee_address.length == 0 || [_model.consignee_address isEqualToString:@""] ){
                _problemRecord = 2;
                websiteTableViewCell *cell = [websiteTableViewCell webTableViewCellWith:tableView indexPath:indexPath msg:_model];
                return cell;
            }else{
                _problemRecord = 1;
                orderDetailTViewCell *cell = [orderDetailTViewCell  tableViewCellWith:tableView indexPath:indexPath msg:_model];
                cell.delegate = self;
                return cell;
            }
        }
    }
}

#pragma mark ---------distributionDelagate

-(void)telphoneBtnClick:(NSString *)tel{
 
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

#pragma mark -----------------签收按钮点击------------------
#pragma mark 需求签收
-(void)signBtnClick:(UIButton *)btn{
    if (self.dataList.count >0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag -10] error:nil];
    }
    _order_original_id = _model.order_original_id;
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle: @"他人签收"  otherBtnTitle:@"本人签收" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 100) {
            LOtherSignViewController *otherSignVC = [[LOtherSignViewController alloc] init];
            otherSignVC.delegate = self;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:otherSignVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
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

#pragma mark 网点或网格签收
-(void)signBtn2Click:(UIButton*)sign{
    if (self.dataList.count >0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[sign.tag -100] error:nil];
    }
    _order_original_id = _model.order_original_id;
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle: @"他人签收"  otherBtnTitle:@"本人签收" clickIndexBlock:^(NSInteger clickIndex) {
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
            _next_delivery_time = @"";
            [self distributionCoupleBack];
        }
    }];
    //显示
    [alert showLXAlertView];
}

//代理方法实现
-(void)LOtherSignWithName:(NSString *)name{
    _sign_man = name;
    _sign_type = 2;
    _type = 1;
    _expt_code = @"";
    _expt_msg = @"";
    _next_delivery_time = @"";
    [self distributionCoupleBack];
}

#pragma mark ------------tableViewSelect------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_sendMsgSelected) {
        
    if(self.dataList.count >0){
        NSDictionary *dic = self.dataList[indexPath.section];
        _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
    }
   if (_status == 1){//配送中
       LOrderDetailViewController *orderDetail=[[LOrderDetailViewController alloc]init];
       orderDetail.status = [NSString stringWithFormat:@"%d",_status];
       orderDetail.order_id = _model.order_original_id;
       
       if(_model.consignee_address.length >0){
           orderDetail.kindType = 1;
       }else{
           orderDetail.kindType = 2;
       }
       orderDetail.delegate = self;
       [self.navigationController pushViewController:orderDetail animated:YES];
    }else if (_status == 2){//已签收
        LOrderDetailViewController *orderDetail=[[LOrderDetailViewController alloc]init];
        orderDetail.status = [NSString stringWithFormat:@"%d",_status];
        orderDetail.order_id = _model.order_original_id;
        if(_model.consignee_address.length >0){
            orderDetail.kindType = 1;
        }else{
            orderDetail.kindType = 2;
        }
        orderDetail.delegate = self;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        return;
    }
    }
}


//详情返回处理
-(void)backBtnClick:(NSString*)status{
    if ([status isEqualToString:@"1"]) {
        [self button1Click];
    }else if ([status isEqualToString:@"2"]){
        [self button2Click];
    }
}

#pragma LOrderListDelegate 拨打电话代理实现
//代理实现
-(void)callPhoneWithModel:(NSString*)phone{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:phone message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",phone];
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

#pragma mark-----------正在配送----------------
//配送中按钮点击
- (void)button1Click
{
    self.sendMsgBtn.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        _animateLabel.frame = CGRectMake(20, 45, _sendIngBtn.width, 5);
    }];
    [self.dataList removeAllObjects];
    [self.msgArray removeAllObjects];
    _searchText.text = @"";
    [_searchText resignFirstResponder];
    _offset = 0;
    _page_size = 10;
    _status = 1;
    _word = @"";
    _sendIngBtn.selected = YES;
    _alreadySendBtn.selected = NO;
    _problemBtn.selected = NO;
    
    if (_sendMsgSelected) {
        self.sendMsgBtn.hidden = YES;

    }
    
    [self getSendOrderList:1];
    
}

//已签收按钮点击
#pragma mark-----------已签收----------------
- (void)button2Click
{
    self.sendMsgBtn.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _animateLabel.frame = CGRectMake(40+_sendIngBtn.width, 45,_sendIngBtn.width, 5);
    }];
    
    [self.dataList removeAllObjects];
      [_searchText resignFirstResponder];
     _searchText.text = @"";
    _offset = 0;
    _page_size = 10;
    _status = 2;
    _word = @"";
    _sendIngBtn.selected = NO;;
    _alreadySendBtn.selected = YES;
    _problemBtn.selected = NO;
    
    if (_sendMsgSelected) {
        self.sendMsgBtn.hidden = YES;
        _sendMsgSelected = NO;
        _rightBtn.hidden = NO;
        [self initWithSubViews];
        [UIView animateWithDuration:0.1 animations:^{
            _animateLabel.frame = CGRectMake(40+_sendIngBtn.width, 45,_sendIngBtn.width, 5);
        }];
    self.headView.frame = CGRectMake(0,-98, SCREEN_WIDTH, 98);
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.frame = CGRectMake(0, -80, SCREEN_WIDTH, 80);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 98);
        self.sendMessage.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 44);
    }];
    self.goodsTableview.frame = CGRectMake(0,98, SCREEN_WIDTH, SCREEN_HEIGHT-98-64);

    [self.headerView removeFromSuperview];
    }
    [self getSendOrderList:1];
}

//异常件按钮点击
#pragma mark ------------异常件------------
- (void)button3Click
{
    self.sendMsgBtn.hidden = YES;

    [UIView animateWithDuration:0.1 animations:^{
        _animateLabel.frame = CGRectMake(60+_sendIngBtn.width*2, 45,_sendIngBtn.width, 5);
    }];
    [self.dataList removeAllObjects];
      [_searchText resignFirstResponder];
    _searchText.text = @"";
    _offset = 0;
    _page_size = 10;
    _status = 3;
    _word = @"";
    _sendIngBtn.selected = NO;;
   _alreadySendBtn.selected = NO;;
    _problemBtn.selected = YES;
    if (_sendMsgSelected) {
        _rightBtn.hidden = NO;
        _sendMsgSelected = NO;
        [self initWithSubViews];
        self.sendMsgBtn.hidden = YES;
        [UIView animateWithDuration:0.1 animations:^{
            _animateLabel.frame = CGRectMake(60+_sendIngBtn.width*2, 45,_sendIngBtn.width, 5);
        }];
        self.headView.frame = CGRectMake(0,-98, SCREEN_WIDTH, 98);
        [UIView animateWithDuration:0.5 animations:^{
            self.headerView.frame = CGRectMake(0, -80, SCREEN_WIDTH, 80);
            self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 98);
            self.sendMessage.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 44);
        }];
        self.goodsTableview.frame = CGRectMake(0,98, SCREEN_WIDTH, SCREEN_HEIGHT-98-64);
        
        [self.headerView removeFromSuperview];
    }
    [self getSendOrderList:1];
}

#pragma mark -----------获取送货列表--------------------
- (void)getSendOrderList:(NSInteger)status{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_status],[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_page_size],[NSString stringWithFormat:@"%@",_word],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_sendGoodsModel *inModel = [[In_sendGoodsModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.status = [NSString stringWithFormat:@"%d",_status];
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    inModel.word = [NSString stringWithFormat:@"%@",_word];
    if (status == 1) {
        [ZJCustomHud dismiss];
        [ZJCustomHud showWithStatus:@"正在加载..."];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [[communcat sharedInstance] sendGoodsListWithMsg:inModel resultDic:^(NSDictionary *dic) {
       
         [ZJCustomHud dismiss];
     
         int code=[[dic objectForKey:@"code"] intValue];
         if (!dic)
         {
             [[iToast makeText:@"网络不给力,请稍后重试!"] show];
             
         }else if (code == 1000){
           
             _sending_count = [dic[@"data"][@"sending_count"] intValue];//配送中
             _expt_count = [dic[@"data"][@"expt_count"] intValue];//异常件
             _sign_count = [dic[@"data"][@"sign_count"] intValue];//已签收
             //1.
             [_sendIngBtn setTitle:[NSString stringWithFormat:@"配送中(%d)",_sending_count] forState:UIControlStateNormal];
             //2.
             [_alreadySendBtn setTitle:[NSString stringWithFormat:@"已签收(%d)",_sign_count] forState:UIControlStateNormal];
             
             //3.
             [_problemBtn setTitle:[NSString stringWithFormat:@"异常件(%d)",_expt_count] forState:UIControlStateNormal];
             NSArray *array = dic[@"data"][@"orders"];
             NSLog(@"array %lu",(unsigned long)array.count);
             if (array.count<=0&&_isFooterRefresh==YES) {
                 
             }
            else if (array.count<=0&&_isFooterRefresh==NO){
                _offset=_offset-1;

                 if(_offset>=0){
                     [self getSendOrderList:2];
                 }
             }
             else if (array.count>0&&_isFooterRefresh==YES){
                 _offset++;
                 _isFooterRefresh=NO;
             }
             for(NSDictionary*dic in array){
                 
                 if (![_dataList containsObject:dic]) {
                     [self.dataList addObject:dic];
                     if(![dic[@"consignee_mobile"] isKindOfClass:[NSNull class]]){
                        
                         [self.msgArray addObject:dic];
                     }
                 }
             }

             if (self.msgArray.count >0) {
                 [self.view addSubview: self.sendMsgBtn];
             }else{
                 [self.sendMsgBtn removeFromSuperview];
             }

             if (self.dataList.count == 0 && _searchText.text.length == 0 && _word_scan.length == 0) {
                 self.goodsTableview.hidden = YES;
                 _viewbg.imgbg.hidden = NO;
                 _viewbg.label.hidden = NO;
                 [self.view addSubview:_viewbg];
             }else{
                 self.goodsTableview.hidden = NO;
                 _viewbg.imgbg.hidden = YES;
                 _viewbg.label.hidden = YES;
                 [_viewbg removeFromSuperview];
             }
             [self.view addSubview:self.sendMessage];

             if (self.dataList.count == 0 ) {
                 if (_word_scan.length!=0 || _searchText.text.length !=0 ) {
                     [[iToast makeText:@"没有找到订单信息,换个订单号试试吧!"] show];
                 }
             }
             [self.goodsTableview reloadData];
             
         }else{
             if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){
                 LoginViewController *login = [[LoginViewController alloc] init];
                 self.hidesBottomBarWhenPushed=YES;
                 [self.navigationController pushViewController:login animated:YES];
             }
         }
     } fail:^(NSError *error) {
         if (status == 1) {
             [ZJCustomHud dismiss];
               [[KNToast shareToast] initWithText:@"网络不给力！" duration:1 offSetY:0];
         }
     }];
        
    });
}

-(void)assignment{
    //1
    [_sendIngBtn setTitle:@"配送中(0)" forState:UIControlStateNormal];
    //2.
    [_alreadySendBtn setTitle:@"已签收(0)" forState:UIControlStateNormal];
    //3.
    [_problemBtn setTitle:@"异常件(0)" forState:UIControlStateNormal];
}

#pragma mark 搜索按钮被点击
-(void)onSearchbtnClick:(UIButton *)btn{
    if (btn.tag == 10){
        _pageIndex = 0;
        if ([_searchText.text isEqualToString:@""] ||_searchText.text.length == 0){
            return;
        }
        else{
            _offset = 0;
            _page_size = 10;
            _word = _searchText.text;
            [self.dataList removeAllObjects];
            [self getSendOrderList:2];

        }
    }
}

#pragma mark -----------刷新----------------------
- (void)setupRefresh
{
    self.goodsTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.dataList removeAllObjects];

            _offset = 0;
            [self getSendOrderList:1];
            // 结束刷新
            [self.goodsTableview.mj_header endRefreshing];
           
        });
    }];
    
    //进入后自动刷新
    [self.goodsTableview.mj_footer
     beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.goodsTableview.mj_header.automaticallyChangeAlpha = YES;
    self.goodsTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            _isFooterRefresh=YES;
            [self getSendOrderList:1];
            // 结束刷新
            [self.goodsTableview.mj_footer endRefreshing];
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.goodsTableview.mj_footer.automaticallyChangeAlpha = YES;
}


//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------短信群发按钮点击之前的视图
-(void)initWithSubViews{
    //加载头部选择功能
   
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
    _headView.backgroundColor =  ViewBgColor;
    [self.view addSubview:_headView];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view1.backgroundColor = whiteColor;
    [_headView addSubview:view1];
    
    if (!_sendIngBtn) {
        _sendIngBtn = [self creatButtonWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH-80)/3,30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:MiddleFont addTarget:@selector(button1Click)];
       
    }
     [view1 addSubview:_sendIngBtn];
    if (!_alreadySendBtn) {
        _alreadySendBtn = [self creatButtonWithFrame:CGRectMake(_sendIngBtn.x+_sendIngBtn.width+20,10, (SCREEN_WIDTH-80)/3, 30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:LittleFont addTarget:@selector(button2Click)];
      
      
    }
      [view1 addSubview:_alreadySendBtn];
    if (!_problemBtn) {
       _problemBtn =  [self creatButtonWithFrame:CGRectMake(_alreadySendBtn.width+_alreadySendBtn.x+20, 10, (SCREEN_WIDTH-80)/3,30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:LittleFont addTarget:@selector(button3Click)];
    
    }
        [view1 addSubview:_problemBtn];
    _animateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, _sendIngBtn.width, 5)];
    _animateLabel.backgroundColor = MAINCOLOR;
    [view1 addSubview:_animateLabel];
    
    if (!_searchBtn) {
        
        _searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(onSearchbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.tag = 10;
        _searchBtn.frame=CGRectMake(SCREEN_WIDTH-90, 60, 70, 30);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"btn_serech.png"] forState:UIControlStateNormal];
   
    }
         [_headView addSubview:_searchBtn];
    if (!_searchText){
        _searchText=[[UITextField alloc]initWithFrame:CGRectMake(30, 60, SCREEN_WIDTH-130, 30)];
        _searchText.layer.cornerRadius = 14.0;
        _searchText.delegate=self;
        _searchText.clearButtonMode= UITextFieldViewModeAlways;
        _searchText.backgroundColor= whiteColor;
        _searchText.placeholder=@"   请输入订单号/地址";
        _searchText.clearsOnBeginEditing=YES;
        _searchText.font = MiddleFont;
         _searchText.clearButtonMode = UITextFieldViewModeAlways;
        [_searchText addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    }
     [_headView addSubview:_searchText];
}

#pragma mark --------textFileDelegate---------------
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField == _searchText) {
        if (_searchText.text.length==0||[_searchText.text isEqualToString:@""]||!_searchText.text) {
            [self getSendOrderList:2];
        }
    }
}

#pragma mark -----------------正常签收意见反馈---------
-(void)distributionCoupleBack{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",_order_original_id],[NSString stringWithFormat:@"%d",_type],[NSString stringWithFormat:@"%d",_sign_type],[NSString stringWithFormat:@"%@",_sign_man],[NSString stringWithFormat:@"%@",_expt_code],[NSString stringWithFormat:@"%@",_expt_msg],[NSString stringWithFormat:@"%@",@""],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_distributionBackModel *inModel = [[In_distributionBackModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.order_id = [NSString stringWithFormat:@"%@",_order_original_id];
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
                     [self.dataList removeAllObjects];
                    [self.goodsTableview reloadData];
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                       
                        [self getSendOrderList:1];
                    });
                   
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
            } );
        }];
    });
}


#pragma mark -----------------异常反馈------------
#pragma mark -------------需求反馈-------
-(void)reasonBtnClick:(UIButton *)btn{
    if (self.dataList.count > 0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag] error:nil];
    }
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle:@"释放" otherBtnTitle:@"拒收" otherBtn1Title:@"滞留" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 100) {//释放
         CustomAlertView *showView = [[CustomAlertView alloc] initWithTitle:@"您是否确认释放此订单?" message:@"" cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
             if(clickIndex == 200){
                 _type = 3;
                 _sign_man = @"";
                 _sign_type = 0;
                 _expt_code = @"";
                 _expt_msg = @"";
                 _order_original_id = _model.order_original_id;
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
    
      [alert showLXAlertView];

}

#pragma mark --------网点或网格反馈------
-(void)reasonBtn2Click:(UIButton*)btn{
    if (self.dataList.count > 0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag] error:nil];
    }
    
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle:@"释放" otherBtnTitle:@"拒收" otherBtn1Title:@"滞留" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 100) {//释放
            CustomAlertView *showView = [[CustomAlertView alloc] initWithTitle:@"您是否确认释放此订单?" message:@"" cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                if(clickIndex == 200){
                    _type = 3;
                    _sign_man = @"";
                    _sign_type = 0;
                    _expt_code = @"";
                    _expt_msg = @"";
                    _order_original_id = _model.order_original_id;
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
        [alert showLXAlertView];
}

//已签收电话按钮点击
-(void)telphoneBtnClick3:(NSString *)tel{
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

#pragma mark cellDelegate方法
-(void)orderDetailLocation:(UIButton*)btn
{
    if (self.dataList.count > 0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag] error:nil];
    }
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

#pragma mark 定位
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        MapRoaldVController*map = [[MapRoaldVController alloc]init];
        map.address=_model.consignee_address;
        map. templatitude = item.coordinate.latitude;
        map.templongitude = item.coordinate.longitude;
        [self.navigationController pushViewController:map animated:YES];
    }
}

-(void)valueChanged:(UITextField*)filed{
    if (_searchText.text.length==0||[_searchText.text isEqualToString:@""]||!_searchText.text) {
        if (_sendIngBtn.selected) {
            [self.dataList removeAllObjects];
            _offset = 0;
            _page_size = 10;
            _status = 1;
            _word = @"";
            [self getSendOrderList:2];
        }else if (_alreadySendBtn.selected){
            [self.dataList removeAllObjects];
            _offset = 0;
            _page_size = 10;
            _status = 2;
            _word = @"";
            [self getSendOrderList:2];
        }else{
            [self.dataList removeAllObjects];
            _offset = 0;
            _page_size = 10;
            _status = 3;
            _word = @"";
            [self getSendOrderList:2];
        }
    }
}
-(void)problemBack{
    [self.dataList  removeAllObjects];
    [self button1Click];
}

-(void)signProblemBack{
    [self.dataList  removeAllObjects];
    [self button1Click];
}

#pragma mark ------------新增功能
#pragma mark更换头部视图
-(void)initHeaderView{
    //加载头部选择功能
   
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,-80, SCREEN_WIDTH,80)];
    _headerView.backgroundColor =  ViewBgColor;
    [self.view addSubview:_headerView];
  
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = MAINCOLOR;
    [_headerView addSubview:view];
    
    if (!_allBtn) {
        _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allBtn setTitleColor:whiteColor forState:UIControlStateNormal];
        _allBtn.titleLabel.font = MiddleFont;
        
        [[_allBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _allSelected = !_allSelected;
            if (_allSelected) {
                [self.allBtn setTitle:@"全不选" forState:UIControlStateNormal];
                [self.recordArray removeAllObjects];
                for (NSInteger i = 0; i < self.msgArray.count; i++) {
                    [self.recordArray addObject:self.msgArray[i]];
                }
                
            }else{
                [self.allBtn setTitle:@"全选" forState:UIControlStateNormal];
                [self.recordArray removeAllObjects];
            }
            [self.goodsTableview reloadData];
        }];
    }
    [view addSubview:_allBtn];
    if (!_cancellBtn) {
        _cancellBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90,0, 100, 30)];
        [_cancellBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancellBtn setTitleColor:whiteColor forState:UIControlStateNormal];
        _cancellBtn.titleLabel.font = MiddleFont;
        [[_cancellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.sendMsgBtn.hidden = NO;
            _sendMsgSelected = NO;
            _rightBtn.hidden = NO;

            [self initWithSubViews];
            self.headView.frame = CGRectMake(0,-98, SCREEN_WIDTH, 98);
            [UIView animateWithDuration:0.5 animations:^{
                self.headerView.frame = CGRectMake(0, -80, SCREEN_WIDTH, 80);
                self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 98);
                self.sendMessage.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 44);
            }];
            self.goodsTableview.frame = CGRectMake(0,98, SCREEN_WIDTH, SCREEN_HEIGHT-98-64);
            [self button1Click];
            
            [self.headerView removeFromSuperview];
        }];
    }
    [view addSubview:_cancellBtn];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0,30, SCREEN_WIDTH, 50)];
    view1.backgroundColor = whiteColor;
    [_headerView addSubview:view1];

    if (!_sendIngBtn) {
        _sendIngBtn = [self creatButtonWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH-80)/3,30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:MiddleFont addTarget:@selector(button1Click)];
       
    }
     [view1 addSubview:_sendIngBtn];
    if (!_alreadySendBtn) {
        _alreadySendBtn = [self creatButtonWithFrame:CGRectMake(_sendIngBtn.x+_sendIngBtn.width+20,10, (SCREEN_WIDTH-80)/3, 30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:LittleFont addTarget:@selector(button2Click)];
        
    }
      [view1 addSubview:_alreadySendBtn];
    if (!_problemBtn) {
        _problemBtn =  [self creatButtonWithFrame:CGRectMake(_alreadySendBtn.width+_alreadySendBtn.x+20, 10, (SCREEN_WIDTH-80)/3,30) norColor:[UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1.0] selColor:MAINCOLOR font:LittleFont addTarget:@selector(button3Click)];
    }
     [view1 addSubview:_problemBtn];
    _animateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, _sendIngBtn.width, 5)];
    _animateLabel.backgroundColor = MAINCOLOR;
    [view1 addSubview:_animateLabel];
}

#pragma mark--------------调转到群发短信模块
-(UIButton*)sendMessage{
    if (!_sendMessage) {
        _sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 44)];
        [_sendMessage setTitle:@"发短信" forState:UIControlStateNormal];
        [_sendMessage setTitleColor:whiteColor forState:UIControlStateNormal];
        _sendMessage.backgroundColor = MAINCOLOR;
        _sendMessage.titleLabel.font = MiddleFont;
        [[_sendMessage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if(self.recordArray.count <= 0){
                [[KNToast shareToast] initWithText:@"请先选择订单" duration:2 offSetY:SCREEN_HEIGHT-100];
                return ;
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in self.recordArray) {
                [array addObject:dic[@"consignee_mobile"]];
            }
            NSString * showdata = [array componentsJoinedByString:@","];
            MessageVController *msgVC = [[MessageVController alloc] init];
            msgVC.phoneList = showdata;
            msgVC.msgSubject = [RACSubject subject];
            msgVC.status = 1;
            [msgVC.msgSubject subscribeNext:^(id x) {
                
                _allSelected = NO;
                _sendMsgSelected = NO;
                [self.recordArray removeAllObjects];
                self.sendMsgBtn.hidden = NO;
                [self initWithSubViews];
                self.headView.frame = CGRectMake(0,-98, SCREEN_WIDTH, 98);
                [UIView animateWithDuration:0.5 animations:^{
                    self.headerView.frame = CGRectMake(0, -80, SCREEN_WIDTH, 80);
                    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 98);
                    self.sendMessage.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 44);
                }];
                self.goodsTableview.frame = CGRectMake(0,98, SCREEN_WIDTH, SCREEN_HEIGHT-98-64);
            }];
            
            [self.navigationController pushViewController:msgVC animated:YES];
            
        }];
    }
    return _sendMessage;
}

#pragma mark -------群发短信
-(UIButton*)sendMsgBtn{
    if (!_sendMsgBtn) {
        _sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMsgBtn.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-70-64,40,40);
        [_sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"btn_message_all"] forState:UIControlStateNormal];
        [[_sendMsgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.sendMsgBtn.hidden = YES;
            _sendMsgSelected = YES;
            _rightBtn.hidden = YES;
            [self initHeaderView];
            [UIView  animateWithDuration:0.5 animations:^{
                 [self.headView removeFromSuperview];
                _headerView.frame =CGRectMake(0,0, SCREEN_WIDTH,80);
                self.sendMessage.frame = CGRectMake(0, SCREEN_HEIGHT-44-64, SCREEN_WIDTH, 44);
                self.goodsTableview.frame = CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT-80-44-64);
            }];
            [self button1Click];
        }];
    }
    return _sendMsgBtn;
}

-(NSMutableArray*)msgArray{
    if (!_msgArray) {
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}

-(NSMutableArray*)recordArray{
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
    
}

-(UIButton*)creatButtonWithFrame:(CGRect)frame norColor:(UIColor*)normal  selColor:(UIColor*)selColor font:(UIFont*)font addTarget:(SEL)selector{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitleColor:selColor forState:UIControlStateSelected];
    [btn setTitleColor:normal forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}
@end
