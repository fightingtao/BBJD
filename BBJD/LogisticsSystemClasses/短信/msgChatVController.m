//
//  msgChatVController.m
//  BBJD
//
//  Created by cbwl on 16/12/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "msgChatVController.h"
#import "publicResource.h"
#import "myMsgChatTableViewCell.h"
#import "replyChatTableVCell.h"
#import "ListDetails.h"
#import "coreDataManger.h"
#import "LoginViewController.h"

@interface msgChatVController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField *textIn;
@property (nonatomic,strong)UIButton *sendBtn;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,assign) int msgCount;

@end


@implementation msgChatVController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  /*  self.navigationController.navigationBar.hidden = NO;
    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=NO;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = YES;*/
    if (_tableView) {
        if (self.dataAry.count>8) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataAry.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            
        }
       /* _tableView.sd_layout.leftSpaceToView(self.view,0)
        .rightSpaceToView(self.view,0)
        .bottomSpaceToView(self.view,0)
        .topSpaceToView(self.view,0);*/
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    //    self.view.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
     //[self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
   
    self.view.backgroundColor=ViewBgColor;
    //    self.view.backgroundColor = [UIColor whiteColor];
    [self initNaveView];
    [self.view addSubview: [self initpersonTableView]];
    [self creactRightGesture];
    self.dataAry=[NSMutableArray arrayWithCapacity:0];
    
    if (!self.textIn) {
        self.textIn=[[UITextField alloc]init];
        //self.textIn.frame=CGRectMake(10, SCREEN_HEIGHT-35, SCREEN_WIDTH-60, 25);
        self.textIn.placeholder=@"短信";
        self.textIn.clearButtonMode=UITextFieldViewModeAlways;
        self.textIn.layer.cornerRadius=5;
        self.textIn.layer.masksToBounds=YES;
        self.textIn.borderStyle=UITextBorderStyleNone;
        self.textIn.backgroundColor=[UIColor whiteColor];
        self.textIn.delegate=self;
        // [ self.view addSubview:self.textIn];
    }
    if (!_sendBtn) {
        _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitleColor:kTextBlackCOLOR forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendbtnLCick) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        // [self.view addSubview:_sendBtn];
    }
    
    self.textIn.sd_layout.leftSpaceToView(self.view,10)
    .topSpaceToView(self.tableView,10)
    .heightIs(25)
    .widthIs(SCREEN_WIDTH-70);
    
    self.sendBtn.sd_layout.leftSpaceToView(self.textIn,10)
    .topSpaceToView(self.tableView,10)
    .rightSpaceToView(self.view,10)
    .heightIs(25);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getChatDetailMsgFromeCoreData];
    
    
    
    
    NSDate *senddate = [NSDate date];
    
    NSLog(@"date1时间戳 = %ld",time(NULL));
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSLog(@"date2时间戳 = %@",date2);
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
}



#pragma mark textfiled delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _textIn.text=[NSString stringWithFormat:@"%@",textField.text];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    if([string isEqualToString:@"☻"]){//防止输入^_^崩溃。☻是我输入^_^后系统打印出来的，也就是说输入^_^，系统却理解成了☻
        textField.text=[textField.text stringByAppendingString:@""];//如果你的服务器识别不了，所以还是把这句删除吧，删除后就变成禁止输入^_^
        return NO;
    }
    
    _textIn.text=[NSString stringWithFormat:@"%@",textField.text];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    int zheng =(int) (textField.text.length+10)/70;
    int yue = (textField.text.length+6)%70;
    if (yue>0) {
        _msgCount =zheng+1;
    }
    else{
        _msgCount=zheng;
    }
}

#pragma mark - keyboard events -键盘事件
//
/////键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_textIn.frame.origin.y) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset+30, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}
/////键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)sendbtnLCick{
    
    [self sendMsgRegistWithPhone:self.mobile];
}



-(void)initNaveView{
    //    self.view.backgroundColor = [UIColor whiteColor];
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(( SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text =self.mobile;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    self.navigationItem.titleView = _titleView;
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITECOLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    return _tableView;
}



#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20.0;
    
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
    UILabel *datelbl=[UILabel new];
    datelbl.textColor=TextDetailCOLOR;
    datelbl.textAlignment=NSTextAlignmentCenter;
    datelbl.frame=CGRectMake(0, 0, SCREEN_WIDTH, 10);
    datelbl.backgroundColor=WHITECOLOR;
    datelbl.font=[UIFont systemFontOfSize:12];

    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    chatDetail *outModel=self.dataAry[section];

    NSTimeInterval new_interval=([outModel.time doubleValue])/1000 ;
    NSDate *new=[NSDate dateWithTimeIntervalSince1970:new_interval ];
    NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    
    NSDateComponents *dateCom = [calendar components:unit fromDate:now  toDate:new options:0];//与本地时间对比
    
    
    if (section>0){
        chatDetail *lastChat=self.dataAry[section-1];
        NSTimeInterval last_interval=([lastChat.time doubleValue])/1000 ;
        NSDate *last=[NSDate dateWithTimeIntervalSince1970:last_interval ];
        NSDateComponents *dateLast = [calendar components:unit fromDate:last  toDate:new  options:0];//与上条数据时间对比

        if ((int)dateLast.minute<2&& (int)dateLast.minute>-2){
            return nil;
        }
   
    }
        if (dateCom.day==0) {//今天
        NSString *tmpTime=[NSString stringWithFormat:@"%@",[objDateformat stringFromDate: new]];
        NSString *nowTime=[NSString stringWithFormat:@"%@",[objDateformat stringFromDate: now]];
            NSString *now=[nowTime substringWithRange:NSMakeRange(0, 10)];
            NSString *old=[tmpTime substringWithRange:NSMakeRange(0, 10)];
            if ([now isEqualToString:old]) {
                datelbl.text= [NSString stringWithFormat:@"今天 %@",[tmpTime substringWithRange:NSMakeRange(10, 6)]];

            }
            else
            {
                datelbl.text =[ [objDateformat stringFromDate:new]  substringWithRange:NSMakeRange(0, 16)] ;
            }

        }
        else{
            datelbl.text =[ [objDateformat stringFromDate:new]  substringWithRange:NSMakeRange(0, 16)] ;

        }
         return datelbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatDetail *model=self.dataAry[indexPath.section];
    
    return  [replyChatTableVCell setReplyRowHeightWhitString:model.msgText index:indexPath tableView:tableView]+40 ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView       setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    chatDetail *list = self.dataAry[indexPath.section];
//    NSString *myPhone=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumble"];
    
//    if (  [list.moble isEqualToString:myPhone]) {
//        replyChatTableVCell *replyCell=[replyChatTableVCell replyMsgChatTableviewCellWithIndex:indexPath tableview:tableView listItem:list];
//        
//        return replyCell;
//        
//    }else{
    
        myMsgChatTableViewCell *myChat=[myMsgChatTableViewCell myMsgChatTableviewCellWithIndex:indexPath tableview:tableView listItem:list];
        
        return myChat;
//    }
//    return nil;
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
#pragma mark - coredata 从本地获取数据
-(void) getChatDetailMsgFromeCoreData{
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *messages=[NSMutableArray arrayWithCapacity:0];
    NSArray *tmp= [[coreDataManger shareinstance]lookChatDetailCoreData];
    NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
    if (tmp.count==0) {
       // [self getMsgDetailList];
    }
    else{
        for (NSManagedObject *obj in tmp) {
            chatDetail *model=[[chatDetail alloc]init];
            model.moble=[obj valueForKey:@"moble"];
            model.phoneID=[obj valueForKey:@"phoneID"];
            model.msgText=[obj valueForKey:@"msgText"];
            model.recipient_mobile=[obj valueForKey:@"recipient_mobile"];
            model.time=[obj valueForKey:@"time"];
            
            if ( [userPhone isEqualToString:model.phoneID]) {
               if (![model.moble isEqualToString:self.mobile]) {
                   
               }else{
                    for (chatDetail *phoneList in self.dataAry) {
                        
                        [messages addObject:phoneList.time];
                    }
                    if (self.dataAry.count>0) {
                        [tmpAry removeAllObjects];
                        if( ![messages containsObject:model.time] && model.moble.length>0){
                            
                            [tmpAry addObject:model];
                        }
                    }
                    else{
                        [tmpAry addObject:model];
                    }
                   [self.dataAry addObjectsFromArray:tmpAry];
                   [self.tableView reloadData];

                }
               
            }
                      }
          
    }
    if (self.dataAry.count==0) {

        [self.dataAry insertObject:_noChat atIndex:0];
        [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:_noChat];
    }
}

#pragma mark 获取短信详情列表接口
-(void)getMsgDetailList{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array=[NSArray arrayWithObjects:self.mobile,nil];
    NSString *hmr=[[communcat sharedInstance]ArrayCompareAndHMac:array];
    
    In_msgListModel *inModel=[[In_msgListModel alloc]init];
    inModel.mobile=self.mobile;
    inModel.key=userInfoModel.key;
    inModel.digest=hmr;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getMsgDetailWithModel:inModel  resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic){
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
            }else if (code == 1000){
                [self.dataAry removeAllObjects];
                NSArray *result = [dic[@"data"]  objectForKey:@"data"];
                [[coreDataManger shareinstance] delectChatDetailManager:@"1"];//删除短信数据库
                NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
                NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
                NSMutableArray *msgsAry=[NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary *datadic in result) {
                    out_msgModel *model=[[out_msgModel alloc]initWithDictionary:datadic error:nil];
                    chatDetail *chat=[[chatDetail alloc]init];
                    chat.moble=model.mobile;
                    if ([userPhone isEqualToString:model.mobile]) {
                        chat.phoneID=model.recipient_mobile;
                    }
                    else{
                        chat.phoneID=model.mobile;
                        
                    }
                    chat.msgText=model.messagetext;
                    chat.time=model.createtime;
                    NSArray *coredataAry = [[coreDataManger shareinstance]lookChatDetailCoreData];
                    if (coredataAry.count==0) {
                        [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
                        
                        [tmpAry addObject:chat];
                    }
                    else{
                        for (chatDetail *chatTmp in coredataAry) {
                            [msgsAry addObject:chatTmp.time];
                        }
                        if (![msgsAry containsObject:chat.time]) {
                            [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
                            [tmpAry addObject:chat];
                        }
                    }
                    NSArray  *listAry=[[coreDataManger shareinstance]lookCoreData];
                    NSMutableArray *listMobile=[NSMutableArray arrayWithCapacity:0];
                    for (ListDetails *list in listAry) {                            [listMobile addObject:list.phone];
                        
                    }
                    if ([listMobile containsObject:self.mobile]) {
                        //  [[coreDataManger shareinstance]changeCoreDataMsg:self.mobile kind:@"msgText" changeText:_textIn.text];
                        
                    }
                    
                }
                [self.dataAry addObjectsFromArray:tmpAry];
                
                [self.tableView reloadData];
            }
            
            else{
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

#pragma mark ----------发送短信接口
-(void)sendMsgRegistWithPhone:(NSString *)phone{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    if (_textIn.text.length==0||!_textIn||[_textIn.text isEqualToString:@""]){
        [[KNToast alloc]initWithText:@"请输入短信内容!" offSetY:0];
        return;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",phone],[NSString stringWithFormat:@"%@",_textIn.text],[NSString stringWithFormat:@"%d",_msgCount],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    in_sendMsgModel *inModel=[[in_sendMsgModel alloc]init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.recipientMobile = [NSString stringWithFormat:@"%@",phone];
    inModel.messagetext = [NSString stringWithFormat:@"%@",_textIn.text];
    inModel.countNum = [NSString stringWithFormat:@"%d",_msgCount];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] sendMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }
                else if (code == 1000){
                    [[KNToast shareToast] initWithText:@"短信发送成功！" duration:1 offSetY:0];
                    NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
                    chatDetail *chat=[[chatDetail alloc]init];
                    chat.moble=self.mobile;
                    chat.phoneID=self.mobile;
                    chat.recipient_mobile=userPhone;
                    chat.msgText=self.textIn.text;
                    NSDateFormatter *dataFormat=[[NSDateFormatter alloc]init];
                    [dataFormat setDateStyle:NSDateFormatterMediumStyle];
                    [dataFormat setDateFormat:@"YYYY:MM:dd HH:mm:ss"];
                    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000.0;
                    chat.time=[NSString stringWithFormat:@"%f",interval];
                    NSArray *coredataAry = [[coreDataManger shareinstance]lookChatDetailCoreData];
                    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
                    NSMutableArray *timeAry=[NSMutableArray arrayWithCapacity:0];
                    
                    if (coredataAry.count==0) {
                        if (_textIn.text.length>0){
                            [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
                            
                            [tmpAry addObject:chat];
                        }
                    }
                    else{
                        for (chatDetail *chatTmp in coredataAry) {
                            [timeAry addObject:chatTmp.time];
                        }
                        if (![timeAry containsObject:chat.time] &&_textIn.text.length>0) {
                            [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
                            [tmpAry addObject:chat];
                        }
                        
                        
                    }
                    [self.dataAry addObjectsFromArray:tmpAry];
                    [self.tableView reloadData];
                    _textIn.text=@"";
                    
                }else{
                    
                    [[KNToast alloc]initWithText:[dic objectForKey:@"message"] offSetY:0];
                }
            });
        }];
    });
}
#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // [self.dateAry removeAllObjects];
            // offset = 0;
            [self getMsgDetailList];
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
            //    offset =  offset +10;
            [self getMsgDetailList];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

@end


