//
//  historyVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "historyVController.h"
#import "publicResource.h"
#import "historyAndMoneyTableViewCell.h"
#import "XBRuleView.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface historyVController ()<UITableViewDelegate,UITableViewDataSource,RuleEndScrollDelegate,UIGestureRecognizerDelegate>
{
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    UILabel *showLabel;
    UIImageView *_timeBG;
    Out_historyOrderBody * _model;
    XBRuleView *_ruleView;//刻度尺
    
}
@property (nonatomic,strong) UITableView *tableView;
 
@property (nonatomic,strong) UILabel *date;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property(nonatomic,strong)NSMutableArray *tmpArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property(nonatomic,strong)UILabel *label;//刻度尺
@end

@implementation historyVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset=0;
    _page_size=10;
    _dataAry = [NSMutableArray array];
    _orders = [NSMutableArray array];
    _dicData=[[NSMutableDictionary alloc]init];
    _keyArray=[NSMutableArray array];
    _dayArray =[[NSMutableArray alloc]init];
    self.view.backgroundColor = ViewBgColor ;
    
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"历史订单"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [ self.view addSubview:[self initpersonTableView]];
    
    [self getSendOrderList];
    
    [self setupRefresh];
    [self initKeDu];
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

-(void)setDate:(UILabel *)date{
    
    
}
#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _offset=0;
            [self.dataAry removeAllObjects];
            [self.dicData removeAllObjects];
            [self.keyArray removeAllObjects];
            [self getSendOrderList];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //进入后自动刷新
    [self.tableView.mj_footer
     beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _offset = _offset+10;
            [self getSendOrderList];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}
#pragma mark tableView delegate
//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 10;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - 70-64-10;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ViewBgColor;
    _tableView.tag=100;
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (_dicData.count>0) {
        
        return [[_dicData allKeys] count];
    }
    else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dicData.count>0){
        
        NSArray *ary=[_dicData objectForKey:_keyArray[section]];
        return ary.count;
    }
    else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _headerView=[[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    //    _headerView.backgroundColor=ViewBgColor;
    _headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 35);
    //
    _date=[[UILabel alloc]init];
    //
    if (_keyArray.count > 0) {
        _date.text=_keyArray[section];
        
    }
    
    _date.textAlignment = 1;
    _date.font = LargeFont;
    _date.textColor = [UIColor whiteColor];
    _date.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
    _date.frame = CGRectMake((SCREEN_WIDTH-100)/2, 10, 100, 26);
    _date.clipsToBounds = YES;
    _date.layer.cornerRadius = 10;
    [_headerView addSubview:self.date];
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    historyAndMoneyTableViewCell *cell=[historyAndMoneyTableViewCell historyTableViewCellWith:tableView indexPath:indexPath msg:nil];
    
    if (_dicData.count>0) {
        NSString *key =_keyArray[indexPath.section];
        NSArray *dataTmp = [_dicData objectForKey:key];
        Out_historyOrderBody * model= [[Out_historyOrderBody alloc]initWithDictionary:dataTmp[indexPath.row] error:nil];
        [cell historySetModel:model];
        
    }
    return cell;
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------获取历史订单数据-----------------------
- (void)getSendOrderList{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_page_size],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    In_historyOrderModel *inModel = [[In_historyOrderModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getHistoryOrderlInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code == 1000){
                    DLog(@"@@@@@@@@@@@@!!!!!!!!!!!%@",dic);
                    NSArray *data =[dic objectForKey:@"data"];
                    for (NSDictionary *tmp2 in data) {
                        //如果数组没有值
                        if ([[_dicData allKeys] count] == 0) {
                            _orders =[tmp2 objectForKey:@"orders"];
                            [_dicData setValue:_orders forKey:[tmp2 objectForKey:@"date"]];
                            [_keyArray addObject:[tmp2 objectForKey:@"date"]];
                            
                            for (NSDictionary *everyData in data) {//挑选日期
                                NSString *time=everyData[@"date"] ;
                                if (![self.dayArray containsObject:time])
                                {
                                    [self.dayArray addObject:time];
                                }
                            }
                            
                        }else{//如果不为0
                            if ([_keyArray containsObject:[tmp2 objectForKey:@"date"]]) {
                                NSArray *tmpAry=[_dicData objectForKey:[tmp2 objectForKey:@"date"]];
                                NSArray *temAry2 = [tmp2 objectForKey:@"orders"];
                                NSMutableArray *ary=[[NSMutableArray alloc]init];
                                [ary addObjectsFromArray:tmpAry];
                                [ary addObjectsFromArray:temAry2];
                                [_dicData setValue:ary forKey:[tmp2 objectForKey:@"date"]];
                                
                            }else{//不包含Key
                                    [_dicData setValue:[tmp2 objectForKey:@"orders"] forKey:[tmp2 objectForKey:@"date"]];
                                    
                                    if (![_keyArray containsObject:[tmp2 objectForKey:@"date"]]){
                                        [_keyArray addObject:[tmp2 objectForKey:@"date"]];
                                    }
                                }
                                
                                //挑选日期
                                for (NSDictionary *everyData in data) {
                                    NSString *time=everyData[@"date"];
                                    if (![self.dayArray containsObject:time])
                                    {
                                        [self.dayArray addObject:time];
                                    }
                                    
                                }
                            }
                            for (NSDictionary *everyData in data) {//挑选日期
                                NSString *time=everyData[@"date"] ;
                                if (![self.dayArray containsObject:time])
                                {
                                    [self.dayArray addObject:time];
                                }
                            }
                       
                    }
                    
                    if (_dayArray.count>0){
                        [self initKeDu];
                        
                        [_tableView reloadData];
                    }
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                }
                
            } );
            
        }];
    });
    
    
}

#pragma mark 初始化刻度尺
-(void)initKeDu{
    if (_dayArray.count<=0) {
        return;
    }

    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    for (NSString *tmpDate in _dayArray) {
        NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
        
        [tmpAry addObject:str2];
    }
    
    if (_ruleView){
        [_ruleView removeFromSuperview];
    }
    _ruleView = [[XBRuleView alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-70-64, [UIScreen mainScreen].bounds.size.width - 40, 70)];
    _ruleView.delegate = self;
    _ruleView.backgroundColor = [UIColor clearColor];
    _ruleView.textColor = MAINCOLOR;
    _ruleView.textFont = [UIFont systemFontOfSize:15];
    _ruleView.longSymbolHeight = 40;
    _ruleView.dalist=[NSMutableArray arrayWithCapacity:0];
    
    [_ruleView.dalist addObjectsFromArray: tmpAry];
    
    NSMutableArray *arrayDate = [NSMutableArray array];
    for (int i = 0; i <= 45; i++) {
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*(45 -i)sinceDate:currentDate ];//前一天
        NSString *dateString = [dateFormatter stringFromDate:lastDay];
        if ([[dateString substringToIndex:1] isEqualToString:@"0"]) {
            dateString = [dateString substringFromIndex:1];
        }
        [arrayDate addObject:dateString];
        
    }
    NSInteger index = [arrayDate indexOfObject:[tmpAry firstObject]];
    
    [ _ruleView setRangeFrom:0 to:45 minScale:1 minScaleWidth:10];
    _ruleView.currentValue = index;
    
    [self.view addSubview: _ruleView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height,2, 70)];
    view.backgroundColor = [UIColor purpleColor];
    view.center =  _ruleView.center;
    [self.view addSubview:view];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    
}

#pragma mark ---------滑动时候的代理------
-(void)ruleEndScroll:(int)index scroll:(UIScrollView *)scrollView;
{
    if (scrollView.tag==100) {
       
    }else{
        NSMutableArray *arryTmp=[NSMutableArray arrayWithCapacity:0];
        for (NSString *tmpDate in _dayArray) {
         
            NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
            NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
            
            [arryTmp addObject:str2];
        }
        
        NSMutableArray *arrayDate=[NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <= 45; i++) {
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*(45 -i)sinceDate:currentDate ];//前一天
            NSString *dateString = [dateFormatter stringFromDate:lastDay];
            if ([[dateString substringToIndex:1] isEqualToString:@"0"]) {
                dateString = [dateString substringFromIndex:1];
            }
            [arrayDate addObject:dateString];
            
        }
        NSString *dateSelct = arrayDate[index];
        for (int indeXX = 0; indeXX<arryTmp.count; indeXX++) {
            if ([arryTmp[indeXX] isEqualToString:dateSelct]) {
                NSIndexPath * scrollIndex= [NSIndexPath indexPathForRow:0 inSection:indeXX];
                [_tableView scrollToRowAtIndexPath:scrollIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
}

@end
