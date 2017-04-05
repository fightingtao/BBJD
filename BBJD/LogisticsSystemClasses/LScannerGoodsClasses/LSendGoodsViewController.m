//
//  LSendGoodsViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/25.
//  Copyright © 2016年 xc. All rights reserved.
//

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
#define sendOrderListCell @"sendOrderListCell"
#define normalColor [UIColor colorWithRed:0.5333 green:0.4588 blue:0.6471 alpha:1.0]
#define whiteColor [UIColor whiteColor]

@interface LSendGoodsViewController ()<UISearchDisplayDelegate,LOrderListDelegate,ScannerGoodsDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,backBtnClickDelegate,distributionDelagate,LOtherSignDelegate>
{
    NSMutableArray *_totalOrderArray;
    NSArray *_searchData;
    NSMutableArray *_filterData;
    UIButton *_searchBtn;
    int _btnMove;//扫码搜索按钮移动
    int _pageIndex;//分页大小
    float lastContentOffset;
    
    /**
     *  送货列表请求网络参数
     */
    int _status;//1配送中 2已签收 3异常件 4 已分配
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    NSString *_word;//模糊查询字段
    NSString *_word_scan;//模糊查询字段

    /**
     *  存储配送状态
     */
    int _sending_count;//配送中订单量
    int _expt_count;//异常件数量
    int _sign_count;//已签收数量
    int _assign_count;//已分配单量
    /**
     *  记录配送状态
     */
    NSInteger _distributRecord ;//记录分配中加载哪种cell 1需求 2网点
    NSInteger _sendingRecord;//配送中
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
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
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
//@property(nonatomic,strong)UIButton *distributionBtn;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImgview;
@property (nonatomic, strong) UIButton *scannerBtn;


//搜索输入
@property (nonatomic, strong) UISearchBar *searchBar;

//@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@end

@implementation LSendGoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
  
    if (_word_scan.length == 0|| !_word_scan || [_word_scan isEqualToString:@""]) {
        
//        [self distributionBtnClick];
        
    }else{
        _offset = 0;
        _page_size = 10;
//        _status = 1;
        _word = _word_scan;
//        [self getSendOrderList];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _word_scan = @"";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"送货";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    if (!_viewbg) {
        _viewbg=[[noConnetView alloc]initWithName: @"error"];
        _viewbg.frame = CGRectMake(0, 150, SCREEN_WIDTH,SCREEN_HEIGHT-150);
    }
   
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    //生成顶部右侧按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_扫描.png"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(scannerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _word_scan = @"";
    
    [self initWithSubViews];
    [self inithomeTableView];
    [self assignment];
    self.navigationItem.titleView = _titleView;
    
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifChange:) name:@"scan-out" object:nil];
    
    [self button1Click];
}

-(void)notifChange:(NSNotification*) notification
{
    _word_scan = [notification object];//通过这个获取到传递的对象
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (_status == 1){
        [self button1Click];
    }else if (_status == 2){
        [self button2Click];
    }else{
        [self button3Click];
    }
}

#pragma mark ------------模糊查询-------------
-(void)scannerBtnClick{
    
    DimChectViewController *vc = [[DimChectViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getOrder_id:(NSString *)order_id{
    _word_scan = order_id;
    _offset = 0;
    _page_size = 10;
    _word = _word_scan;
    [self.dataList removeAllObjects];
    [self getSendOrderList];
}

//初始化tableView
-(void)inithomeTableView
{
    _dataList = [NSMutableArray array];
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 100.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height - 164;
    
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.goodsTableview.delegate = self;
    self.goodsTableview.dataSource = self;
    self.goodsTableview.backgroundColor = ViewBgColor;
    
    self.goodsTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.goodsTableview];
    
}

#pragma  mark -------tableView delegate-------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataList.count;
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
   
   if (_status == 3){
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(_status == 1){
        if (_sendingRecord == 1) {
            return 260;
        }else{
            return 160;
        }
        
    }else if(_status == 2){
        if (_alreadySendRecord == 1) {
            return 250;
        }else{
            return 130;
        }
        
    }else{
        if (_problemRecord == 1) {
            return 250;
        }else{
            return 140;
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.dataList.count >0){
        NSDictionary *dic = self.dataList[section];
        _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
    }
#warning 要有判断！！！！！！！！！！！！！！！！！！！！！
    if (_status == 3) {
        //异常件
        static NSString *viewIdentfier = @"footView";
        problemFooterView *sectionFootView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        
        if(!sectionFootView){
            
            sectionFootView = [[problemFooterView alloc] initWithReuseIdentifier:viewIdentfier];
        }
        sectionFootView.proInforLabel.text = _model.expt_msg;
        return sectionFootView;
      
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(_status == 4){//已分配
//        if(self.dataList.count >0){
//            NSDictionary *dic = self.dataList[indexPath.section];
//            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
//        }
//        distributionTableViewCell *cell = [distributionTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
//        
//        if ([_model.consignee_address isEqualToString:@""] | (_model.consignee_address.length == 0) ) {
//            cell.relaseButton.hidden = NO;
//            cell.reasonButton.hidden = YES;
//            cell.signButton.hidden = YES;
//            _distributRecord = 1;
//
//        }else{
//            _distributRecord = 2;
//            cell.relaseBtn.hidden = NO;
//            cell.reasonBtn.hidden = YES;
//            cell.signBtn.hidden = YES;
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
//        return cell;
//        
//    }else
        if (_status == 1){//配送中
        
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        distributionTableViewCell *cell = [distributionTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
        if ((_model.consignee_address.length == 0) ||[_model.consignee_address isEqualToString:@""] ||!_model.consignee_address ) {
            cell.relaseButton.hidden = YES;
            
            cell.reasonButton.hidden = NO;
            cell.signButton.hidden = NO;
            _sendingRecord = 2;
            
        }else{
            _sendingRecord = 1;
            cell.relaseBtn.hidden = YES;
            cell.reasonBtn.hidden = NO;
            cell.signBtn.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
        
    }else if(_status == 2){//已签收
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        if (_model.consignee_address.length == 0 || [_model.consignee_address isEqualToString:@""] ) {
            websiteTableViewCell *cell = [websiteTableViewCell webTableViewCellWith:tableView indexPath:indexPath msg:_model];
            _alreadySendRecord = 2;
            return cell;
            
        }else{//异常件
            _alreadySendRecord = 1;
            distributionTableViewCell *cell = [distributionTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_model];
            cell.relaseBtn.hidden = YES;
            cell.reasonBtn.hidden = YES;
            cell.signBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
       
        if (_model.consignee_address.length == 0 || [_model.consignee_address isEqualToString:@""] ){
        websiteTableViewCell *cell = [websiteTableViewCell webTableViewCellWith:tableView indexPath:indexPath msg:_model];
        return cell;
        }else{
            return nil;
        }
    }
}

#pragma mark ---------distributionDelagate

-(void)telphoneBtnClick:(NSString *)tel{
 
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    

}

#pragma mark -------------------释放按钮点击----------
#pragma mark 需求接单释放
-(void)relaseBtnClick:(UIButton *)btn{
 
    _order_original_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    _sign_type = 1;
    _sign_man = @"";
    _type = 3;
    _expt_code = @"";
    _expt_msg = @"";
    _next_delivery_time = @"";
    [self distributionCoupleBack];
    
}

#pragma mark 网点或网格接单释放
-(void)relaseBtn2Click:(UIButton *)btn{
  
    _order_original_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    _sign_type = 1;
    _sign_man = @"";
    _type = 3;
    _expt_code = @"";
    _expt_msg = @"";
    _next_delivery_time = @"";
    [self distributionCoupleBack];
    [self getSendOrderList];
}


#pragma mark -----------------签收按钮点击------------------
#pragma mark 需求签收
-(void)signBtnClick:(UIButton *)btn{
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle: @"本人签收"  otherBtnTitle:@"他人签收" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
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

#pragma mark 网点或网格签收
-(void)signBtn2Click:(NSString*)num{
  
    CustomAlertView *alert=[[CustomAlertView alloc] initWithTitle:@"" message:@"" cancelBtnTitle: @"本人签收"  otherBtnTitle:@"他人签收" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
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
    if(self.dataList.count >0){
        NSDictionary *dic = self.dataList[indexPath.section];
        _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
    }
    
    if (_status == 4) {
        return;
    }else if (_status == 1){
        
         LOrderDetailViewController *orderDetail=[[LOrderDetailViewController alloc]init];
        orderDetail.kindType = _sendingRecord;
        orderDetail.status = [NSString stringWithFormat:@"%d",_status];
        orderDetail.order_id = _model.order_original_id;
         orderDetail.delegate = self;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else if (_status == 2){
        LOrderDetailViewController *orderDetail=[[LOrderDetailViewController alloc]init];
        orderDetail.kindType = _alreadySendRecord;
        orderDetail.status = [NSString stringWithFormat:@"%d",_status];
        orderDetail.order_id = _model.order_original_id;
        orderDetail.delegate = self;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }else{
        
    }
}

-(void)backBtnClick:(NSString*)status{
    
    if ([status isEqualToString:@"1"]) {
        [self button1Click];
    }else if ([status isEqualToString:@"2"]){
        [self button2Click];
    }else if([status isEqualToString:@"3"]){
        [self button3Click];
    }
}

#pragma LOrderListDelegate 拨打电话代理实现
//代理实现
-(void)callPhoneWithModel:(NSString*)phone{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

#pragma mark-----------正在配送----------------
//分配中按钮点击
//-(void)distributionBtnClick{
//    [self.dataList removeAllObjects];
//     _status = 4;
//    _offset = 0;
//    _page_size = 10;
//     _word = @"";
//    _distributionBtn.selected = YES;
//    _sendIngBtn.selected = NO;
//    _alreadySendBtn.selected = NO;
//    _problemBtn.selected = NO;
//     [self getSendOrderList];
//    
//}

//配送中按钮点击
- (void)button1Click
{
    [self.dataList removeAllObjects];
    _offset = 0;
    _page_size = 10;
    _status = 1;
    _word = @"";
    _sendIngBtn.selected = YES;
    _alreadySendBtn.selected = NO;
    _problemBtn.selected = NO;
//    _distributionBtn.selected = NO;
    [self getSendOrderList];
}

//已签收按钮点击
#pragma mark-----------已签收----------------
- (void)button2Click
{
    [self.dataList removeAllObjects];
    _offset = 0;
    _page_size = 10;
    _status = 2;
    _word = @"";
    _sendIngBtn.selected = NO;;
    _alreadySendBtn.selected = YES;
    _problemBtn.selected = NO;
//    _distributionBtn.selected = NO;
    [self getSendOrderList];
    
}

//异常件按钮点击
#pragma mark ------------异常件------------
- (void)button3Click
{
 [self.dataList removeAllObjects];
    _offset = 0;
    _page_size = 10;
    _status = 3;
    _word = @"";
    _sendIngBtn.selected = NO;;
    _alreadySendBtn.selected = NO;;
    _problemBtn.selected = YES;
//    _distributionBtn.selected = NO;
    [self getSendOrderList];
}

#pragma mark -----------获取送货列表--------------------------
- (void)getSendOrderList{
    
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] sendGoodsListWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if (code == 1000){
                    _sending_count = [dic[@"data"][@"sending_count"] intValue];//配送中
                    _expt_count = [dic[@"data"][@"expt_count"] intValue];//异常件
                    _sign_count = [dic[@"data"][@"sign_count"] intValue];//已签收
                    _assign_count =[dic[@"data"][@"assign_count"] intValue];//分配中
                    //1.
//                     [_distributionBtn setTitle:[NSString stringWithFormat:@"分配中(%d)",_assign_count] forState:UIControlStateNormal];
                    //2.
                    [_sendIngBtn setTitle:[NSString stringWithFormat:@"配送中(%d)",_sending_count] forState:UIControlStateNormal];
                    //3.
                    [_alreadySendBtn setTitle:[NSString stringWithFormat:@"已签收(%d)",_sign_count] forState:UIControlStateNormal];
                    
                    //4.
                    [_problemBtn setTitle:[NSString stringWithFormat:@"异常件(%d)",_expt_count] forState:UIControlStateNormal];
                    NSArray *array = dic[@"data"][@"orders"];
                    
                    for(NSDictionary*dic in array){
                        
                        if (![_dataList containsObject:dic]) {
                            
                            [self.dataList addObject:dic];
                            
                        }
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
                    
                    if (self.dataList.count == 0 ) {
                        if (_word_scan.length!=0|| _searchText.text.length!=0) {
                            
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
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
            } );
        }];
    });
}

-(void)assignment{
    
    //1.
//    [_distributionBtn setTitle:@"分配中(0)" forState:UIControlStateNormal];
    //2/
    [_sendIngBtn setTitle:@"配送中(0)" forState:UIControlStateNormal];
    
    //3.
    [_alreadySendBtn setTitle:@"已签收(0)" forState:UIControlStateNormal];
    
    //4.
    [_problemBtn setTitle:@"异常件(0)" forState:UIControlStateNormal];

}

#pragma mark 搜索按钮被点击
-(void)onSearchbtnClick:(UIButton *)btn{
    if (btn.tag == 10){
        _pageIndex = 0;
        if ([_searchText.text isEqualToString:@""] ||_searchText.text.length == 0){
//            [self getSendOrderList];
//            return;
            [self button1Click];//要加判断的************
        }
        else{
            _offset = 0;
            _page_size = 10;
            _word = _searchText.text;
            [self.dataList removeAllObjects];
        [self getSendOrderList];

        }
    }
}

#pragma ScannerSearchDelegate 扫码搜索代理实现

//- (void)scannerSearchWithResult:(NSString *)result
//{
//    _searchDisplayController.active = YES;
//    _searchText.text = result;
//    //    [self getOrderListWithType:_type];
//    [_searchDisplayController.searchBar becomeFirstResponder];
//}

#pragma mark -----------刷新----------------------
- (void)setupRefresh
{
    self.goodsTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataList removeAllObjects];
           
            _offset = 0;
            [self getSendOrderList];
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
            _offset = _offset +10;
        
            [self getSendOrderList];
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

-(void)confirmGoodsClick{
        
}

- (void) dragMoving: (UIButton *)btn withEvent:(UIEvent *)event

{
    _btnMove = 1;
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    CGFloat x = point.x;
    CGFloat y = point.y;
    CGFloat btnx = btn.frame.size.width/2;
    CGFloat btny = btn.frame.size.height/2;
    if(x<=btnx) point.x = btnx;
    if(x >= self.view.bounds.size.width - btnx)
        point.x = self.view.bounds.size.width - btnx;
    if(y<=btny) point.y = btny;
    if(y >= self.view.bounds.size.height - btny)
        point.y = self.view.bounds.size.height - btny;
    if (y <= 64) {
        point.y = 94;
    }
    btn.center = point;
    btn.center = point;

}

-(void)initWithSubViews{
    //加载头部选择功能
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 100)];
        _headView.backgroundColor = MAINCOLOR;
        [self.view addSubview:_headView];
    }
//    if (!_distributionBtn) {
//        
//        _distributionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _distributionBtn.frame = CGRectMake(10, 10, (SCREEN_WIDTH-50)/4, 30);
//        [_distributionBtn setTitleColor:whiteColor forState:UIControlStateSelected];
//        [_distributionBtn setTitleColor:normalColor forState:UIControlStateNormal];
//        
//        [_distributionBtn addTarget:self action:@selector(distributionBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        _distributionBtn.titleLabel.font = LittleFont;
//        _distributionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _distributionBtn.selected = YES;//开始时加载配送中
//        _distributionBtn.layer.cornerRadius=15;
//        _distributionBtn.clipsToBounds=YES;
//        [_headView addSubview:_distributionBtn];
//    }
    
    if (!_sendIngBtn) {
        _sendIngBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendIngBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
        [_sendIngBtn setTitleColor:kTextWorkCOLOR forState:UIControlStateNormal];
        [_sendIngBtn setBackgroundImage:[[communcat sharedInstance] createImageWithColor:TextMainCOLOR] forState:UIControlStateSelected];
        
        [_sendIngBtn addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
        _sendIngBtn.frame = CGRectMake(20, 10, (SCREEN_WIDTH-80)/3, 30);
        
        _sendIngBtn.titleLabel.font = LittleFont;
        _sendIngBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sendIngBtn.layer.cornerRadius=15;
        _sendIngBtn.clipsToBounds=YES;
        [_headView addSubview:_sendIngBtn];
    }
    
    if (!_alreadySendBtn) {
        _alreadySendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alreadySendBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
        [_alreadySendBtn setTitleColor:kTextWorkCOLOR forState:UIControlStateNormal];
        [_alreadySendBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:TextMainCOLOR] forState:UIControlStateSelected];
        
        [_alreadySendBtn addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
        _alreadySendBtn.frame = CGRectMake(_sendIngBtn.x+_sendIngBtn.width+10,10, (SCREEN_WIDTH-80)/3, 30);
        _alreadySendBtn.titleLabel.font = LittleFont;
        _alreadySendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _alreadySendBtn.layer.cornerRadius=15;
        _alreadySendBtn.clipsToBounds=YES;
        [_headView addSubview:_alreadySendBtn];
    }
    
    
    if (!_problemBtn) {
        _problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_problemBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
        [_problemBtn setTitleColor:kTextWorkCOLOR forState:UIControlStateNormal];
        [_problemBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:TextMainCOLOR] forState:UIControlStateSelected];
        [_problemBtn addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
        _problemBtn.frame = CGRectMake(_alreadySendBtn.width+_alreadySendBtn.x+10, 10, (SCREEN_WIDTH-80)/3, 30);
        _problemBtn.titleLabel.font = LittleFont;
        _problemBtn.layer.cornerRadius=15;
        _problemBtn.clipsToBounds=YES;
        _problemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:_problemBtn];
    }
    
    _totalOrderArray = [[NSMutableArray alloc] init];
    
    _filterData = [[NSMutableArray alloc] init];
    
    _searchData = [[NSMutableArray alloc] init];
    
    [self inithomeTableView];
    
    [self.view addSubview:_goodsTableview];
    
    
    if (!_searchBtn) {
        
        _searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(onSearchbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.tag = 10;
        _searchBtn.frame=CGRectMake(SCREEN_WIDTH-90, 60, 70, 30);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"btn_serech.png"] forState:UIControlStateNormal];
        [_headView addSubview:_searchBtn];
        
    }
    
    if (!_searchText){
        _searchText=[[UITextField alloc]initWithFrame:CGRectMake(30, 60, SCREEN_WIDTH-130, 30)];
        _searchText.layer.cornerRadius = 10.0;
        _searchText.delegate=self;
        _searchText.clearButtonMode= UITextFieldViewModeAlways;
        _searchText.backgroundColor= whiteColor;
        _searchText.placeholder=@"   请输入订单号/地址";
        _searchText.clearsOnBeginEditing=YES;
         _searchText.clearButtonMode = UITextFieldViewModeAlways;
        [_headView addSubview:_searchText];
    }
    
//    if (!_scannerBtn) {
//        _scannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _scannerBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
//        _scannerBtn.frame = CGRectMake(SCREEN_WIDTH-70,94,50,50);
//        [_scannerBtn setImage:[UIImage imageNamed:@"scanning"] forState:UIControlStateNormal];
//        [_scannerBtn addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
//        _scannerBtn.layer.cornerRadius = 25;
//        _scannerBtn.layer.borderColor = [UIColor clearColor].CGColor;
//        _scannerBtn.layer.borderWidth = 0.5;
//        [_scannerBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
//        
//        _btnMove = 0;
//    }
}

#pragma mark --------textFileDelegate---------------
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField == _searchText) {
        if (_searchText.text.length==0||[_searchText.text isEqualToString:@""]||!_searchText.text) {
            [self getSendOrderList];
        }
    }
}

#pragma mark -----------------正常签收意见反馈
-(void)distributionCoupleBack{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",_order_original_id],[NSString stringWithFormat:@"%d",_type],[NSString stringWithFormat:@"%d",_sign_type],[NSString stringWithFormat:@"%@",_sign_man],[NSString stringWithFormat:@"%@",_expt_code],[NSString stringWithFormat:@"%@",_expt_msg],[NSString stringWithFormat:@"%@",_next_delivery_time],nil];
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
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code == 1000){
                    if ( _type == 3) {
                        [[iToast makeText:@"释放成功"] show];
                    }else {
                        [[iToast makeText:@"签收成功"] show];
                    }
                    [self.dataList removeAllObjects];
                    [self getSendOrderList];//****可能有改动（刷新表格*******
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
            } );
            
        }];
    });
}

#pragma mark -----------------异常反馈------------
#pragma mark ------需求反馈------
-(void)reasonBtnClick:(UIButton *)btn{
    UnusualReasonListController *VC = [[ UnusualReasonListController alloc]init];
    if (self.dataList.count > 0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag] error:nil];
    }
    VC.order_id = _model.order_original_id;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --------网点或网格反馈------
-(void)reasonBtn2Click:(UIButton*)btn{
    UnusualReasonListController *VC = [[ UnusualReasonListController alloc]init];
    if (self.dataList.count > 0) {
        _model = [[Out_sendGoodsBody alloc] initWithDictionary:self.dataList[btn.tag] error:nil];
    }
    VC.order_id = _model.order_original_id;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
