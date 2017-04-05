//
//  msgHomeViewController.m
//  BBJD
//
//  Created by cbwl on 16/12/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "msgHomeViewController.h"
#import "publicResource.h"
#import "msgHomeCell.h"
#import "oneMessageVC.h"
#import "msgHomeHeaderview.h"//搜索框  按钮  tableviewheader
#import "msgChatVController.h"//短信详情界面
#import "LoginViewController.h"
#import "coreDataManger.h"//baoc 保存数据
#import "ListDetails.h"
#import "CustomTransization.h"//自定义导航push动画
#import "emptyView.h"

@interface msgHomeViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate,allAndFailBtnDelegate>
{
    int isSend;//短信类型  1.全部  2.发送失败
    NSString *mobile;//手机号 (订单详情)
    NSString *keyWords;//模糊查询
    int offset;
    int page_size;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)msgHomeHeaderview *headerView;
@property (nonatomic,strong)NSMutableArray *dateAry;
@property (nonatomic,strong)NSMutableArray *searchAry;

@property (nonatomic,strong) emptyView *empty;

@end

@implementation msgHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.automaticallyAdjustsScrollViewInsets=YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getMsgFromeCoreData];//获取msg数据
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    
    self.view.backgroundColor = MAINCOLOR;
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self initNaveView];
    offset=0;
    page_size=10;
    isSend=1;
    [self.view addSubview: [self initpersonTableView]];
    if (!self.empty){
        self.empty=[[emptyView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-81)/2, 200, 162/2, 259/2)];
        self.empty.hidden=YES;
        [self.view addSubview:self.empty];
    }
    
    if (!_statusBar) {
        _statusBar=[[UIView alloc]init];
        _statusBar.backgroundColor=MAINCOLOR;
        _statusBar.frame=CGRectMake(0, -66, SCREEN_WIDTH, 20);
        
        [self.view addSubview:_statusBar];
    }
    _dateAry=[NSMutableArray arrayWithCapacity:0];
    _searchAry=[NSMutableArray arrayWithCapacity:0];
    
}

#pragma mark 从本地数据获取短信数据
-(void)getMsgFromeCoreData{
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *phones=[NSMutableArray arrayWithCapacity:0];
    
    NSArray *tmp= [[coreDataManger shareinstance]lookCoreData];
    NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
    if (tmp.count==0) {// 本地无数据
      //  [self getNoReadMsgNumble];
    }
    else{
        for (NSManagedObject *obj in tmp) {
            ListDetails *model=[[ListDetails alloc]init];
            model.phone=[obj valueForKey:@"phone"];
            model.isRead=[obj valueForKey:@"isRead"];
            model.isSend=[obj valueForKey:@"isSend"];
            model.msgText=[obj valueForKey:@"msgText"];
            model.recipient_mobile=[obj valueForKey:@"recipient_mobile"];
            model.time=[obj valueForKey:@"time"];
            if ( [userPhone isEqualToString: model.recipient_mobile]){
                for (ListDetails *phoneList in self.dateAry) {
                    [phones addObject:phoneList.phone];
                }
                if (self.dateAry.count>0) {
                    [tmpAry removeAllObjects];
                    if( ![phones containsObject:model.phone] && model.phone.length>0){
                        [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:model];
                        [tmpAry insertObject:model atIndex:0];
                    }
                    else if ([phones containsObject:model.phone] && model.phone.length>0){
                        
                        for (int j=0; j<self.dateAry.count; j++) {
                            ListDetails *listTmp=self.dateAry[j];
                            if ([listTmp.phone isEqualToString:model.phone]) {
                                [self.dateAry replaceObjectAtIndex:j withObject:model];
                            }
                        }
                    }
                }
                else{
                    [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:model];
                    [tmpAry insertObject:model atIndex:0];
                }
                [self.dateAry addObjectsFromArray:tmpAry];
            }

             }
            
                }
    if (self.dateAry.count==0){
        self.empty.hidden=NO;
    }
    else{
        self.empty.hidden=YES;
    }
        
    [self.tableView reloadData];
}

-(void)initNaveView{
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"短信"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(leftItemClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_btn_message" target:self action:@selector(rightItemClick)];
    if ( !_headerView) {
        _headerView = [[msgHomeHeaderview alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 86)];
        _headerView.backgroundColor=WHITECOLOR;
        _headerView.searchBr.delegate=self;
        _headerView.delegate=self;
        [self.view addSubview:_headerView];
    }
    
  
}


#pragma mark textfile  Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
{
    
//    _viewHolde.hidden=NO;
    _headerView.searchBr.showsCancelButton=YES;
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden=YES;
    _headerView.frame=CGRectMake(0, -44, SCREEN_WIDTH, 86);
    _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    _viewHolde.hidden=YES;
    _headerView.searchBr.showsCancelButton=NO;
    
    self.navigationController.navigationBar.hidden=NO;
    _headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 86);
    _tableView.frame=CGRectMake(0, 86, SCREEN_WIDTH,SCREEN_HEIGHT- 86-64);
    //_headerView.searchBr.text=@"";
    [_dateAry addObjectsFromArray:_searchAry];
    [_tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self getMsgFromeCoreData];
    
    NSMutableArray *tmpAry=[[NSMutableArray alloc]initWithArray:_dateAry];
    
    for (int i=0;i<_dateAry.count;i++){
        ListDetails *model=_dateAry[i];
        // for (ListDetails *model in _dateAry) {
        if (![model.phone containsString:searchText]) {
            [tmpAry removeObject:model];
            // [_searchAry addObject:model];
            
        }
    }
    [self.dateAry removeAllObjects];
    [self.dateAry addObjectsFromArray:tmpAry];
    
    if (self.dateAry.count==0) {
        keyWords=searchBar.text;
    //    [self getNoReadMsgNumble];
    }
    if(searchText.length==0){
        [self getMsgFromeCoreData];
        
    }
    
    [_tableView reloadData];
    
//    _viewHolde.hidden=YES;
    keyWords=searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)leftItemClick{
    if (self.frome==2){
     
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightItemClick{
    if(self.frome==1){
        [self leftItemClick];
    }
    else{
        oneMessageVC *oneMsg=[[oneMessageVC alloc] init];
        [self.navigationController pushViewController:oneMsg animated:YES];
        
    }
}

#pragma mark tableView 初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 86.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-86-64 ;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ViewBgColor;
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}


#pragma tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  if (_headerView.searchBr.text.length>0) {
    //  return _searchAry.count;
    // }
    /// else{
    return _dateAry.count;
    //}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"msgHomeCell";
    msgHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell  = [[[NSBundle mainBundle]loadNibNamed:@"msgHomeCell" owner:self options:nil] objectAtIndex:0];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ListDetails *msg;

    msg=  _dateAry[indexPath.row];
    
    NSString *myPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
    if ([myPhone isEqualToString:msg.phone]) {
        cell.phone.text=msg.recipient_mobile;
        
    }
    else{
        cell.phone.text=msg.phone;
        
    }
    cell.msg.text=[NSString stringWithFormat:@"%@",msg.msgText];
    NSDate *date=[NSDate date];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    
     NSTimeInterval _interval=[msg.time doubleValue] / 1000.0;
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat2 = [[NSDateFormatter alloc] init];
    [objDateformat2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([[objDateformat2 stringFromDate: date2] containsString:[objDateformat stringFromDate: date]]) {
        cell.date.text=[NSString stringWithFormat:@"%@ >",[[objDateformat2 stringFromDate: date2] substringWithRange:NSMakeRange(10,6)]];
    }
    else
    {
        cell.date.text=[NSString stringWithFormat:@"%@ >",[objDateformat2 stringFromDate: date2]];
        
    }
    
    if ( [msg.isSend isEqualToString:@"1"]){//发送成功
     
        cell.failSend.hidden=YES;
        cell.noRead.hidden=YES;
        
    }
    else{
        cell.failSend.hidden=NO;
        cell.noRead.hidden=YES;

    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    chatDetail *tmp=self.dateAry[indexPath.row];
    msgHomeCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.noRead.hidden=YES;
    
    
    msgChatVController *chat=[[msgChatVController alloc]init];
     chat.mobile=cell.phone.text;
     chat.noChat =[[chatDetail alloc]init];
     chat.noChat.moble=cell.phone.text;
      chat.noChat.phoneID=cell.phone.text;
     chat.noChat.msgText=tmp.msgText;
     chat.noChat.recipient_mobile=tmp.recipient_mobile;
     chat.noChat.time=tmp.time;
    [self.navigationController showViewController:chat sender:chat];
    
    
}
#pragma mark 全部短信按钮被点击
-(void)allBtnCLickWithBtn:(UIButton *)sender;{
    
    [self getMsgFromeCoreData];
    NSMutableArray *tmpAry=[[NSMutableArray alloc]initWithArray:_dateAry];
    
    if (_headerView.searchBr.text.length>0 ) {
        for (ListDetails *list in _dateAry) {
            if ( [list.phone containsString:_headerView.searchBr.text] ||  [list.msgText containsString:_headerView.searchBr.text]) {
            }
            else{
                [tmpAry removeObject:list];
                
            }
            
        }
        [self.dateAry removeAllObjects];
        [self.dateAry addObjectsFromArray:tmpAry];
        
        [self.tableView reloadData];
    }
}

#pragma mark 发送失败按钮被点击
-(void)failBtnCLickWithBtn:(UIButton *)sender;{
    
    NSMutableArray *tmpAry=[[NSMutableArray alloc]initWithArray:_dateAry];
    
    if (_headerView.searchBr.text.length>0) {//是否有搜索文字
        for (int i=0;i<_dateAry.count;i++){
            ListDetails *model=_dateAry[i];
            
            //   for (ListDetails *model in _dateAry) {
            if ([model.isSend isEqualToString:@"0"]) {
                if ([model.msgText containsString:_headerView.searchBr.text] ||[model.phone containsString:_headerView.searchBr.text]) {
                }
                else{
                    [tmpAry removeObject:model];
                }
            }
            else{
                [tmpAry removeObject:model];
            }
        }
    }else{
        for (int i=0;i<_dateAry.count;i++) {
            ListDetails *model =_dateAry[i];
            
            if (![model.isSend containsString:@"0"]) {
                 [tmpAry removeObject:model];
            }
            else{
                
            }
            
        }
    }
    [self.dateAry removeAllObjects];
    [self.dateAry addObjectsFromArray:tmpAry];
    
    if (self.dateAry.count==0){
        self.empty.hidden=NO;
    }
    else{
        self.empty.hidden=YES;
    }
    [self.tableView reloadData];
    
}

#pragma mark 获取 短信列表数据的接口
-(void)getNoReadMsgNumble;{
    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    keyWords=_headerView.searchBr.text;
    if (!keyWords||keyWords.length==0){
        keyWords=@"";
    }
    NSArray *array=[NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",keyWords],[NSString stringWithFormat:@""],nil];
    NSString *hmr=[[communcat sharedInstance]ArrayCompareAndHMac:array];
    In_msgListModel *inModel=[[In_msgListModel alloc]init];
    inModel.keyWords=[NSString stringWithFormat:@"%@",keyWords];
    inModel.key=userInfoModel.key;
    inModel.digest=hmr;
    inModel.issend=[NSString stringWithFormat:@""];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getMsgListWithModel:inModel  resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic){
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }
            else if (code == 1000){
                NSArray *result = dic[@"data"] ;
                //  [self getMsgFromeCoreData];
                NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
                NSMutableArray *phones=[NSMutableArray arrayWithCapacity:0];
                for (ListDetails *listPhone in self.dateAry) {
                    [phones addObject:listPhone.phone];
                }
                if (result.count>0){
                    for(NSDictionary *tmp in result)
                    {
                        out_msgModel *outModel=[[out_msgModel alloc]initWithDictionary:tmp error:nil];
                        ListDetails  *list=[[ListDetails  alloc]init];
                        list.phone=outModel.mobile;
                        list.msgText=outModel.messagetext;
                        // list.time=[objDateformat stringFromDate: date];
                        list.time=outModel.createtime;
                        list.isRead=outModel.isRead;
                        list.isSend=outModel.isSend;
                        list.recipient_mobile=outModel.recipient_mobile;
                        if (self.dateAry.count>0) {
                            [tmpAry removeAllObjects];
                            if( ![phones containsObject:list.phone] && list.phone.length>0){
                                [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:list];
                                [tmpAry insertObject:list atIndex:0];
                            }
                            else{
                                [[coreDataManger shareinstance]changeCoreDataMsg:list.phone kind:@"msgText" changeText:list.msgText isSend:list.isSend];
                                for (int i=0; i<self.dateAry.count; i++) {
                                    ListDetails *tmpPhones=self.dateAry[i];
                                    if ([tmpPhones.phone isEqualToString:list.phone]) {
                                        [self.dateAry removeObject:tmpPhones];
                                        [self.dateAry addObject:list];
                                    }
                                    
                                }
                            }
                        }
                        else{
                            NSMutableArray *tmpListAry=[NSMutableArray arrayWithCapacity:0];
                            for (ListDetails *noCoredata in tmpAry) {
                                [tmpListAry addObject:noCoredata.phone];
                                
                            }
                            if (![tmpListAry containsObject:list.phone]) {
                                [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:list];
                                
                                [tmpAry insertObject:list atIndex:0];
                            }
                            
                            
                        }
                        //      if(![self.dateAry containsObject:list] && list.phone.length>0){
                        //        [[[coreDataManger alloc]init] insertCoreDataObjectWithOrder:list];
                        //  }else{
                        [self.dateAry addObjectsFromArray:tmpAry];
                        
                    }
                    if (self.dateAry.count==0){
                        self.empty.hidden=NO;
                    }
                    else{
                        self.empty.hidden=YES;
                        
                    }
                    [self.tableView reloadData ];
                    
                    
                }
                
                
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){
                     LoginViewController *login = [[LoginViewController alloc] init];
                    self.hidesBottomBarWhenPushed=YES;
                     [self.navigationController pushViewController:login animated:YES];
                }
            }
        }];
    });
}

#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [self.dataAry removeAllObjects];
            // [self.dateAry removeAllObjects];
            offset = 0;
            //[self getNoReadMsgNumble];
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
            offset =  offset +10;
//             [self getNoReadMsgNumble];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

@end
