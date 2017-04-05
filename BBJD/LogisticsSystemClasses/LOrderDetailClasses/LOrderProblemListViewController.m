//
//  LOrderProblemListViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/27.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LOrderProblemListViewController.h"

#import "FDCalendar.h"
#import "FDCalendarItem.h"

@interface LOrderProblemListViewController ()
{
    NSArray *_dataArray;
    int _PType;//异常原因
    
    FDCalendar *calendar;
}
 
@property (nonatomic, strong) UITableView *problemTableview;

@end

@implementation LOrderProblemListViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ViewBgColor;
    [self.navigationController.navigationBar setBarTintColor:WhiteBgColor];
    
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"异常状态"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    if ([_TypeStr isEqualToString:@"拒收"]) {
        
        
    }
    else{
        
        UIButton *RightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        RightItem.frame = CGRectMake(0, 0, 60, 60);
        [RightItem setTitle:@"日历" forState:UIControlStateNormal];
        RightItem.titleLabel.font = MiddleFont;
        [RightItem setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        [RightItem addTarget:self action:@selector(RightItemClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightItem];

    }

    _dataArray = [[NSArray alloc] init];
    
    [self inithomeTableView];
    [self.view addSubview:_problemTableview];
    self.problemTableview.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetDate:) name:@"SelectDate" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化table
-(UITableView *)inithomeTableView
{
    if (_problemTableview != nil) {
        return _problemTableview;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height;
    
    self.problemTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _problemTableview.delegate = self;
    _problemTableview.dataSource = self;
    _problemTableview.backgroundColor = ViewBgColor;
    _problemTableview.showsVerticalScrollIndicator = NO;
    return _problemTableview;
    
}

- (void)getExptReasonWithType:(int)type
//{
//    //异常类型（1拒收  2滞留）
//    _PType = type;
//    
//    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    mbp.labelText = @"获取中...";
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSData *userData = [userDefault objectForKey:UserKey];
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//
//    NSString *hamcString = [[communcation sharedInstance] hmac:[NSString stringWithFormat:@"%d",type] withKey:userInfoModel.primaryKey];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        Out_LExptreasonModel *outModel = [[communcation sharedInstance] getExptReasonListWith:userInfoModel.userId andDigest:hamcString andExpttype:[NSString stringWithFormat:@"%d",type]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            if (!outModel)
//            {
//                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
//                
//            }else if (outModel.code ==1000)
//            {
//                _dataArray = outModel.data;
//                [_problemTableview reloadData];
//            }else{
//                [[iToast makeText:outModel.message] show];
//            }
//        });
//        
//    });
//
//}
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identCell = @"UITableViewCell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identCell];
    }
//    Out_LExptreasonBody *model = [_dataArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,model.exptmsg];
    cell.textLabel.textColor = TextMainCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     Out_LExptreasonBody *model = [_dataArray objectAtIndex:indexPath.row];
//    _exptycode = model.exptycode;
    

    [self FeedbackOrderidWithModel];
//    NSNotification * notice = [NSNotification notificationWithName:@"dingdan" object:nil userInfo:@{@"1":@"异常件"}];
//    //发送消息
//    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    
    
}

- (void)FeedbackOrderidWithModel
//{
//    
//    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    mbp.labelText = @"反馈中...";
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSData *userData = [userDefault objectForKey:UserKey];
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    
//    In_FeedbackOrderidWithModel *InModel = [[In_FeedbackOrderidWithModel alloc]init];
//    
//    //异常原因码 （01 滞留，修改配送时间 02客户拒收 。。。）
//    if ([_TypeStr isEqualToString:@"拒收"]){
//        
////         NSString *hamcString = [[communcation sharedInstance] hmac:_tempModel.cwb withKey:userInfoModel.primaryKey];
//        
//        NSArray *KeyArr = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d",2],_tempModel.cwb,[NSString stringWithFormat:@"%d",4],_exptycode,@"",[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%f",0.00],@"",@"",[NSString stringWithFormat:@"%d",_tempModel.cwbordertypeid],@"",@"",@"", nil];
////        [NSString stringWithFormat:@"%d",1],
//        
////        NSString *hamcString = [[communcation sharedInstance] hmac:_tempModel.cwb withKey:userInfoModel.primaryKey];
//        NSString *hamcString = [[communcation sharedInstance]ArrayCompareAndHMac:KeyArr];
//        InModel.terminaltype=2;
//        
//        InModel.key = userInfoModel.key;
//        InModel.digest = hamcString;
//       
//        InModel.cwbs = _tempModel.cwb;
//        InModel.deliverystate = 4;
//
//        InModel.exptioncode = _exptycode;
//
//        InModel.nextdispatchtime = @"";
//        
//
//        InModel.paywayid = 0;
//
//        InModel.cash = 0;
//
//        InModel.signman = @"";
//        InModel.signtime = @"";
//        InModel.cwbordertypeid = _tempModel.cwbordertypeid;
// 
//        InModel.terminalid = @"";
//        
//        InModel.postrace = @"";
//        
//        InModel.traceno = @"";
//        
////        InModel.signtypeid = 1;
//
//       
//    }
//    else if ([_TypeStr isEqualToString:@"滞留"]){
//        
//        if ( _DateStr==nil ) {
//            [[iToast makeText:@"请选择一个下次配送的时间"] show];
//            [self RightItemClick];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            return;
//        }
//        
//        NSDate *NowDate = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"HH:mm:ss"];
//        NSString *NowTime = [formatter stringFromDate:NowDate];
//        
//        NSString *SelectDate = [_DateStr stringByAppendingString:@" "];
//        SelectDate = [SelectDate stringByAppendingString:NowTime];
//        
//        //应缴金额 （）
//     
//        NSArray *KeyArr = [[NSArray alloc]initWithObjects: _tempModel.cwb,[NSString stringWithFormat:@"%d",_tempModel.cwbordertypeid],[NSString stringWithFormat:@"%d",3],[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],SelectDate,_exptycode,[NSString stringWithFormat:@"%d",2],@"",@"",nil];
//        NSString *hamcString = [[communcation sharedInstance] ArrayCompareAndHMac:KeyArr];
//        InModel.key = userInfoModel.key;
//        InModel.digest = hamcString;
//        InModel.cwbs = _tempModel.cwb;
//        InModel.cwbordertypeid = _tempModel.cwbordertypeid;
//        InModel.deliverystate = 3;
//        InModel.paywayid = 0;
//        InModel.cash = 0;
//        InModel.exptioncode = _exptycode;
//        InModel.nextdispatchtime = SelectDate;
//        InModel.signman = @"";
//        InModel.signtime = @"";
//        InModel.terminaltype=2;
//    }
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        Out_FeedbackOrderidWithModel *outModel = [[communcation sharedInstance] getFeedBackWithModel:InModel];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            if (!outModel)
//            {
//                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
//                
//            }else if (outModel.code ==1000)
//            {
//                
//                AlertViewOne = [[UIAlertView alloc]initWithTitle:@"用户提示" message:@"反馈成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [AlertViewOne show];
//                
//                [self leftItemClick];
//                
//            }else{
//                [[iToast makeText:outModel.message] show];
//            }
//            
//        });
//        
//    });
//    
//}
{
    
}
-(void)GetDate:(NSNotification*)notification{
    
    NSDictionary *DateDic = notification.userInfo;
    _DateStr = [DateDic objectForKey:@"date"];
    
    calendar.hidden = YES;
    self.problemTableview.hidden = NO;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == AlertViewOne) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    UIViewController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)RightItemClick{
    
    self.problemTableview.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    calendar.frame = CGRectMake(0,74, SCREEN_WIDTH, SCREEN_HEIGHT);
    calendar.hidden = NO;
    [self.view addSubview:calendar];
    
}

@end
