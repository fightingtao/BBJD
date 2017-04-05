//
//  citySelectVController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "citySelectViewController.h"
#import "publicResource.h"
#import "ChineseString.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
@interface citySelectViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSString *_name;//城市名
    
}
 
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *loctionCity;
@property (nonatomic, strong)  BMKLocationService *locService ;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation citySelectViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexArray = [NSMutableArray array];
    self.letterResultArr = [NSMutableArray array];
    self.view.backgroundColor = ViewBgColor;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"选择城市"];
    
    [self.view addSubview:[self initpersonTableView]];
    [self getCity];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _loctionCity=@"";
    
    self.sectionTitleView = ({
        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-100)/2,100,100)];
        sectionTitleView.textAlignment = NSTextAlignmentCenter;
        sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
        sectionTitleView.textColor = MAINCOLOR;
        sectionTitleView.backgroundColor = [UIColor whiteColor];
        sectionTitleView.layer.cornerRadius = 6;
        sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
        _sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;

}

#pragma mark 初始化下单table
-(UITableView *)initpersonTableView
{
    if (self.tableView != nil) {
        return self.tableView ;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .backgroundColor = ViewBgColor;
    self.tableView .showsVerticalScrollIndicator = NO;
    self.tableView.sectionIndexColor = MAINCOLOR;//右侧索引的颜色
    return self.tableView ;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.indexArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
        
    }
    return [[self.letterResultArr objectAtIndex:section-1] count]; ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        
        return  self.indexArray[section - 1];
        
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"当前城市";
        }else {
            if ([_loctionCity isEqualToString:@""] || -_loctionCity.length == 0){
                
                NSMutableArray *arrayCity = [NSMutableArray array];
                for (NSArray *array in self.letterResultArr) {
                    [arrayCity addObjectsFromArray:array];
                }
                if ([arrayCity containsObject:_name]) {
                    
                    cell.textLabel.text= _name;
                }else{
                    cell.textLabel.text=[NSString stringWithFormat:@"%@(该城市暂未开放)",_name];
                    
                }
            }
        }
    }
    else{
        cell.textLabel.text = self.letterResultArr[indexPath.section-1][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        if(indexPath.row == 0){
        return;
        }else{
            NSMutableArray *arrayCity = [NSMutableArray array];
            for (NSArray *array in self.letterResultArr) {
                [arrayCity addObjectsFromArray:array];
            }
            
            if ([arrayCity containsObject:_name]) {
                _loctionCity = _name;
            }else{
                return;
            }
        }
    }else{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    _loctionCity = cell.textLabel.text;
    
    }
    [self leftItemClick];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_status==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"citySelect2" object:_loctionCity];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:_loctionCity];
    }
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------展示当前选中----------
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showSectionTitle:title];
    return index;
}


#pragma mark - private
-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

#pragma mark 获取开放城市

-(void)getCity{
    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getCityWithKey:userInfoModel.key digest:hmac resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"]show];
                
            }else if (code ==1000)
            {
                
                NSMutableArray *array = [NSMutableArray array];
                NSDictionary *data = [dic objectForKey:@"data"];
                NSArray *citys=[data objectForKey:@"opencitys"];
                for (NSDictionary *city in citys) {
                    [array addObject:city[@"name"]];
                }
                self.indexArray = [ChineseString IndexArray:array];
                self.letterResultArr = [ChineseString LetterSortArray:array];
                [_tableView reloadData];
                
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
            }
        }];
    });
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    
    //    _staticlat = userLocation.location.coordinate.latitude;
    //    _staticlng = userLocation.location.coordinate.longitude;
    
    BMKGeoCodeSearch *bmGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    bmGeoCodeSearch.delegate = self;
    
    BMKReverseGeoCodeOption *bmOp = [[BMKReverseGeoCodeOption alloc] init];
    bmOp.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL geoCodeOk = [bmGeoCodeSearch reverseGeoCode:bmOp];
    if (geoCodeOk) {
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKAddressComponent *city = result.addressDetail;
    
   _name = [NSString stringWithFormat:@"%@",city.city];
  
    NSIndexPath *ind=[NSIndexPath indexPathForRow:1 inSection:0 ];
    
    [_tableView reloadRowsAtIndexPaths:@[ind] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [[iToast makeText:@"定位失败，请检查是否打开定位服务!"]show];

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    DLog(@"heading is %@",userLocation.heading);
}

//tableView右侧数组索引
-(NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.indexArray];
    [array insertObject:@"当" atIndex:0];
    return array;
}
@end
