//
//  NotificationViewController.m
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "noConnetView.h"
#import "publicResource.h"

#define ReuseIdentifier @"cell"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _pagesize;
    NSInteger _offset;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)Out_informBody *informBody;
@property(nonatomic,strong)noConnetView *noDataView;
@end

@implementation NotificationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.dataList removeAllObjects];
    [self getNotificationInfor];
}

-(NSMutableArray*)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;
    _pagesize = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"通知";
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self initTableView];
    
    if (!_noDataView) {
        _noDataView=[[noConnetView alloc]initWithName: @"nonemessagye"];
        _noDataView.imgbg.frame= CGRectMake((SCREEN_WIDTH-80)/2, 50, 80, 80);
        _noDataView.label.text = @"暂无通知";
        _noDataView.frame = CGRectMake(0, 80, SCREEN_WIDTH,200);
    }
    [self setupRefresh];
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

-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
}

#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataList removeAllObjects];
            _offset = 0;
            _pagesize = 10;
            
            [self getNotificationInfor];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        });
    }];
    
    //进入后自动刷新
    [self.tableView.mj_footer
     beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pagesize = 10;
            _offset = _offset+10;
            [self getNotificationInfor];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}


#pragma mark --------tableViewDelegate-----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
        return self.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil] firstObject];
    }
    if (self.dataList.count >0) {
        cell.model = self.dataList[indexPath.section];
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil] firstObject];
    }
    if (self.dataList.count >0) {
        cell.model = self.dataList[indexPath.section];
    }
    return cell.cellHeight;
}

//获取通知信息
-(void)getNotificationInfor{
    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",(long)_offset],[NSString stringWithFormat:@"%ld",_pagesize],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    In_informModel *inModel= [[In_informModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.offset = [NSString stringWithFormat:@"%ld",(long)_offset];
    inModel.page_size = [NSString stringWithFormat:@"%ld",(long)_pagesize];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getInformListWithMsg: inModel degist:hmacString resultDic:^(NSDictionary *dic) {
            DLog(@"最大胆量%@",dic);
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                [self.view addSubview:_noDataView];

            }
            else if (code == 1000)
            {
                NSArray *result = dic [@"data"][@"messages"];
                
                for (NSDictionary *dict in result) {
                    _informBody = [[Out_informBody alloc]initWithDictionary:dict error:nil];
                    [self.dataList addObject:_informBody];
                }
                
                if (self.dataList.count ==0) {
                    [self.tableView removeFromSuperview];
                    [self.view addSubview:_noDataView];
                }else{
                    [ self.view addSubview:self.tableView];
                    [_noDataView removeFromSuperview];
                }
                
                [self.tableView reloadData];
                
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
            }
        }];
    });
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
