//
//  UnusualReasonListController.m
//  BBJD
//
//  Created by 李志明 on 16/8/30.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "UnusualReasonListController.h"
#import "FDCalendar.h"


@interface UnusualReasonListController()<UITableViewDataSource,UITableViewDelegate>
{
    FDCalendar *calendar;
//    int _type ;
    int _sign_type;
    NSString *_sign_man;
    NSString *_next_delivery_time;
}
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property(nonatomic,copy)NSString *reason_code;//异常原因编码
@property(nonatomic,copy)NSString *reason_msg;//异常原因
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)Out_distributionProblemBody *model;

@end

@implementation UnusualReasonListController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.automaticallyAdjustsScrollViewInsets = NO;
      if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"异常原因";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    [self initTableView];
    [self getUnusualReason];
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetDateInfor:) name:@"selectedDate" object:nil];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)initTableView{
    _dataList = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static  NSString *ID = @"";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _model = _dataList[indexPath.section];
    cell.textLabel.text = _model.reason_msg;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = _dataList[indexPath.section];
    _reason_code=_model.reason_code;
    _reason_msg=_model.reason_msg;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (_reasonKind==1){
        self.tableView.hidden = YES;

    calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    
    calendar.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    calendar.hidden = NO;
    [self.view addSubview:calendar];
    }
    else if(_reasonKind==2){
        [self distributionCoupleBack];

    }
}

-(void)GetDateInfor:(NSNotification*)notification{
    
    NSDictionary *DateDic = notification.userInfo;
  
    _next_delivery_time = [[NSString stringWithFormat:@"%@",[DateDic objectForKey:@"chuanzhi"]] substringWithRange:NSMakeRange(0,19)];
    
    calendar.hidden = YES;
    self.tableView.hidden = NO;
    
    [self distributionCoupleBack];

}

-(void)getUnusualReason{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length==0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:[NSString stringWithFormat:@"%d",_reasonKind] withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getDistributionProblemInfoWithkey:userInfoModel.key degist:hmac type:[NSString stringWithFormat:@"%d",_reasonKind] resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }else if (code ==1000)
            {
                NSArray *result = [dic objectForKey:@"data"][@"expt_reasons"];
                
                for(NSDictionary *dic in result){
                    _model = [[Out_distributionProblemBody alloc]initWithDictionary:dic error:nil];
                    [_dataList addObject:_model];
                    [_tableView reloadData];
                }
            }else{
                [[iToast makeText:[dic objectForKey:@"message"]] show];
            }
        }];
    });
}

-(void)leftItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ------------配送异常反馈-----------------------
-(void)distributionCoupleBack{
    _type =  2;
    _sign_man = @"";

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    if (_reasonKind==2){
        _next_delivery_time=@"";
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",_order_id],[NSString stringWithFormat:@"%d",_type],@"1",[NSString stringWithFormat:@"%@",_sign_man],[NSString stringWithFormat:@"%@",_reason_code],[NSString stringWithFormat:@"%@",_reason_msg],[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_next_delivery_time]],nil];

    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    In_distributionBackModel *inModel = [[In_distributionBackModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    
    inModel.order_id = [NSString stringWithFormat:@"%@",_order_id];
    inModel.type = [NSString stringWithFormat:@"%d",_type];
    inModel.sign_type = @"1";
    inModel.sign_man = [NSString stringWithFormat:@"%@",_sign_man];
    inModel.expt_code = [NSString stringWithFormat:@"%@",_reason_code];
    inModel.expt_msg = [NSString stringWithFormat:@"%@",_reason_msg];
    inModel.next_delivery_time =[NSString stringWithFormat:@"%@",_next_delivery_time];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]getDistributionBackInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                 int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if (code == 1000){
                    
                    [[iToast makeText:@"反馈成功"] show];

                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
             } );
            
        }];
    });
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if ([self.delegate respondsToSelector:@selector(problemBack)]) {
        [self.delegate problemBack];
    }
   
}

@end

