//
//  sendMessageVController.m
//  BBJD
//
//  Created by cbwl on 16/12/20.
//  Copyright © 2016年 CYT. All rights reserved.
//
///$(PRODUCT_NAME:c99extidentifier) //在修改在   build setting   中的   Product Module Name   即可。
#import "getPhoneVController.h"
#import "inputPhoneView.h"
 #import "oneMessageVC.h"
#import "phoneInPutView.h"
#import "MessageVController.h"
#import "VoiceVController.h"
#import <TesseractOCR/TesseractOCR.h>
#import "KNToast.h"
#import <QuartzCore/QuartzCore.h>
#import "GrayScale.h"
#import "ImageUtils.h"///图片工具类
#import "setManger.h"//设置手机
#import "telTableViewCell.h"
#import "CustomTransization.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define XCenter self.view.center.x
#define SWidth (XCenter+30)

#define Width [UIScreen mainScreen].bounds.size.width
#define YCenter self.view.center.y

#define SHeight 20


@interface getPhoneVController ()<UITableViewDelegate,UITableViewDataSource,voiceDelegate,VoiceViewCDelegate,G8TesseractDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIAccelerometerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    int num;
    BOOL upOrdown;
  //  VoiceVController *_voice;
    //扫描识别
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *layer;
    AVCaptureDeviceInput *input;
    AVCaptureStillImageOutput *output;
    AVCaptureVideoDataOutput *output2;
    BOOL selected;//选择按钮点击了
    BOOL isSelected;//每个是否选中
    BOOL allSelected;//全部
   NSString *_recordSancn;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIInputView * input;
@property (nonatomic,strong)inputPhoneView *inputView;
@property (nonatomic,strong)UIButton *deleBtn;//底部删除按钮
@property (nonatomic,strong)UIButton *sendMsgBtn;//底部发送短信按钮
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIButton *select;//右侧选择按钮
@property (nonatomic,strong)UIButton *selectAll;//全选按钮
@property (nonatomic,strong)UIButton *back;//fanhui返回按钮

@property (nonatomic,strong)UIImageView *imageScane;
@property (nonatomic,strong)UIImageView *line;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)VoiceVController *voice;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic,strong)UIImage  *shearedImage;//剪切图片
@property (nonatomic,strong)UIImageView *tempImg;//临时图片
@property(nonatomic,strong)NSMutableArray *showArray;
@property(nonatomic,copy)NSString *showdata;
@property (nonatomic,strong)UIButton *startScane;//开始扫描按钮
@property (nonatomic,strong)UIButton *stopScan;//停止扫描按钮
@property(nonatomic,strong)NSMutableArray *recordArray;

@end

@implementation getPhoneVController

//记录
-(NSMutableArray*)recordArray{
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

-(NSMutableArray*)showArray{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _showdata = [NSString new];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"分拣"];
    if (!_back) {
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        _back.frame = CGRectMake(0, 0, 30, 30);
        [_back setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_back];
    }
    
    if (!_select){
        _select = [UIButton buttonWithType:UIButtonTypeCustom];
        _select.frame = CGRectMake(0, 0, 40, 30);
        [_select addTarget:self action:@selector(selectBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
        [_select setTitle:@"选择" forState:UIControlStateNormal];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_select];
    }
    
    if (!_selectAll) {
        _selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAll.frame = CGRectMake(0, 0, 60, 30);
        [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAll addTarget:self action:@selector(selectAllItemClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [self creactCamer];
    [self.view addSubview:[self initpersonTableView]];
    [self creacteBottomDelectBtn];

     [self creacteTableViewHeaderView];
    [self creactScanImage];//扫描框图片
    self.operationQueue = [[NSOperationQueue alloc] init];
       [self creactStartAndStopBtn];
    [self creactRightGesture];
    
    UILabel * labIntroudction = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    [labIntroudction setText:@"将收件人手机号置于扫描框内,即可自动识别！"];
    labIntroudction.numberOfLines=0;
    labIntroudction.font = [UIFont systemFontOfSize:15];
    [labIntroudction setTextColor:[UIColor whiteColor]];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
    [self.view bringSubviewToFront:labIntroudction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infor:) name:@"delegate" object:nil];
    _tempImg=[UIImageView new];
    _tempImg.frame=CGRectMake(40, 130, 300, 100);
    _tempImg.contentMode=UIViewContentModeScaleAspectFill;

}

-(void)infor:(NSNotification*)userInfo{
       NSMutableArray *array = userInfo.userInfo[@"chengGong"];
    for (NSInteger i = 0; i <array.count; i++) {
        for(NSInteger j = 0 ;j < self.dataArray.count; j++){
            if ([self.dataArray[j] [@"recipient_mobile"] isEqualToString:array[i]]) {
                [self.dataArray removeObjectAtIndex:j];
            }
        }
    }
    if(self.dataArray.count >0){
        
    }else{
        allSelected = NO;
        selected = NO;
        [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
        [_select setTitle:@"选择" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_back];
        ;
    }
    self.showdata = nil;
    [self.showArray removeAllObjects];
    [self.recordArray removeAllObjects];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets=true;
}

#pragma mark 输入手机号 textfile
-(void)creacteTableViewHeaderView{
    self.inputView = [[inputPhoneView alloc]initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 50)  ];
    self.inputView.backgroundColor=ViewBgColor;
    _inputView.delegate=self;
    _inputView.phone.delegate = self;
    [self.view addSubview:self.inputView];
}

#pragma mark 手机号码输入搜索
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.textColor = [UIColor blackColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

   if(textField == self.inputView.phone){
        if (textField.text.length == 11){
            if (![[communcat sharedInstance] checkTel:textField.text]) {
                [[KNToast shareToast] initWithText:@"请输入正确的手机号" duration:1 offSetY:0];
                return;
            }
            [self  getSearchInfor:textField.text];
        }
        
   }else{
       if (textField.text.length == 0) {
           [self.dataArray removeObjectAtIndex:textField.tag];
           [self.tableView reloadData];
           
       }else if (textField.text.length == 11){
      
           if ([[communcat sharedInstance] checkTel:textField.text]) {
               
               [self.dataArray removeObjectAtIndex:textField.tag];
               [self getSearchInfor:textField.text];
           }else{
               [[KNToast shareToast] initWithText:@"请输入正确的手机号!" duration:1 offSetY:0];
               NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
               [dict setObject:textField.text  forKey:@"recipient_mobile"];
               [dict setObject:@"无结果" forKey:@"building_no"];
               [self.dataArray replaceObjectAtIndex:textField.tag withObject:dict];
               [self.tableView reloadData];
           }
       }else{
           NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
           [dict setObject:textField.text  forKey:@"recipient_mobile"];
           [dict setObject:@"无结果" forKey:@"building_no"];
           [self.dataArray replaceObjectAtIndex:textField.tag withObject:dict];
           [self.tableView reloadData];
       }
   }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length > 10) {
        textField.text=[textField.text substringWithRange:NSMakeRange(0, 10)];
    }
    return YES;
}


#pragma mark 录音界面UI
-(void)voiceBtnClickWithBtn:(UIButton *)btn{
    _voice = [[VoiceVController alloc]init];
    _voice.delegate = self;
    [self addChildViewController:_voice];
  _voice.view.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2, 0, 0);
    [UIView animateWithDuration:0.5 animations:^{
        _voice.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:_voice.view];
    }];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)cancelVoiceBtnClick
{
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [_voice.view removeFromSuperview];
    [_voice removeFromParentViewController];

}

//返回录入代理
-(void)finishReginise:(NSString *)resultString{
    [self getSearchInfor:resultString];
//    self.navigationItem.leftBarButtonItem.enabled=YES;
//    self.navigationItem.rightBarButtonItem.enabled=YES;
//    [_voice.view removeFromSuperview];
//    [_voice removeFromParentViewController];
}

#pragma mark tableView 初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 175;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-175-64;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ViewBgColor;
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}


#pragma---------------------- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count >0) {
        return _dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *showCell;
    if (selected == YES) {
        static NSString *identifier = @"identifier1";
        telTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[telTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.isSelected = allSelected;
        //是否被选中
        if ([self.recordArray containsObject:self.dataArray[indexPath.row]]) {
            cell.isSelected  = YES;
        }
        cell.cartBlock = ^(BOOL isSelec){
           Out_sortModel  *model = [[Out_sortModel alloc] initWithDictionary:self.dataArray[indexPath.row] error:nil];
            if (isSelec) {
                [self.recordArray addObject:self.dataArray[indexPath.row]];
                [self.showArray addObject:model.recipient_mobile];
            }
            else
            {
                [self.showArray removeObject:model.recipient_mobile];
                [self.recordArray removeObject:self.dataArray[indexPath.row]];
            }
            
            if (self.showArray.count == self.dataArray.count) {
                allSelected = YES;
                [_selectAll setTitle:@"全不选" forState:UIControlStateNormal];
            }
            else
            {
                [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
                allSelected = NO;
            }
            
             self.showdata = [self.showArray componentsJoinedByString:@","];
            
        };
        if(self.dataArray.count >0){
            Out_sortModel *model = [[Out_sortModel alloc] initWithDictionary:self.dataArray[indexPath.row] error:nil];
            cell.model = model;
        }
        showCell = cell;
    }else{
        static NSString *identifier = @"identifier";
      phoneTViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[phoneTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(self.dataArray.count >0){
            Out_sortModel *model = [[Out_sortModel alloc] initWithDictionary:self.dataArray[indexPath.row] error:nil];
            cell.model = model;
        }
        cell.textfiled.tag = indexPath.row;
        cell.textfiled.delegate = self;
        if ([[communcat sharedInstance] checkTel:cell.textfiled.text]) {
            cell.textfiled.textColor = [UIColor blackColor];
        }else{
            cell.textfiled.textColor = [UIColor redColor];
        }
        showCell = cell;
    }
    showCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return showCell;
}

#pragma mark 导航栏按钮
-(void)leftItemClick{
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----右侧选择按钮点击
-(void)selectBtnItemClick{
    if(self.dataArray.count >0){
        if ([_select.titleLabel.text isEqualToString:@"选择"]) {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                Out_sortModel *model = [[Out_sortModel alloc] initWithDictionary:self.dataArray[i] error:nil];
                BOOL a =   [[communcat sharedInstance] checkTel:model.recipient_mobile];
                if (!a) {
                    [array addObject:model];
                }
            }
            if (array.count <= 0) {
                if([_recordSancn isEqualToString:@"Start"]){
                    [self  onStopBtnScanerClick];
                    _recordSancn = @"Start";
                }
                
                selected = YES;
                [_select setTitle:@"取消" forState:UIControlStateNormal];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_selectAll];
                _deleBtn.hidden    = NO;
                _sendMsgBtn.hidden = NO;
                
                CGRect rect = self.view.frame;
                rect.origin.x = 0.0;
                rect.origin.y = 175;
                rect.size.width = SCREEN_WIDTH;
                rect.size.height = SCREEN_HEIGHT-175-64-44;
                [UIView animateWithDuration:0.5 animations:^{
                    _tableView.frame = rect;
                }];
            }else{
                [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"有%ld个手机号码错误，请前去改正！",array.count] duration:1 offSetY:0];
            }
        }else{
            CGRect rect = self.view.frame;
            rect.origin.x = 0.0;
            rect.origin.y = 175;
            rect.size.width = SCREEN_WIDTH;
            rect.size.height = SCREEN_HEIGHT-175-64;
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.frame = rect;
            }];
            selected = NO;
          if([_recordSancn isEqualToString:@"Stop"]){
                [self onStartScanerBtnClick];
              _recordSancn =@"Stop";
          }
            
            [_select setTitle:@"选择" forState:UIControlStateNormal];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_back];
            _deleBtn.hidden=YES;
            _sendMsgBtn.hidden=YES;
            allSelected = NO;
            [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
            [self.showArray removeAllObjects];
            [self.recordArray removeAllObjects];
            self.showdata = nil;
        }
        [_tableView reloadData];
    }else{
        [[KNToast shareToast] initWithText:@"请先选择要查询手机号码!" duration:1 offSetY:0];
    }
}

#pragma mark ----------全选按钮点击
-(void)selectAllItemClick{
    allSelected = !allSelected;
    if(allSelected == YES){
        [_selectAll setTitle:@"全不选" forState:UIControlStateNormal];
        [self.showArray removeAllObjects];
        [self.recordArray removeAllObjects];
        for (NSInteger i = 0; i < self.dataArray.count;i++) {
             Out_sortModel *model = [[Out_sortModel alloc] initWithDictionary:self.dataArray[i] error:nil];
             [self.showArray addObject:model.recipient_mobile];
        }
        [self.recordArray addObjectsFromArray:self.dataArray];
    }else{
        [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
        [self.showArray removeAllObjects];
        [self.recordArray removeAllObjects];
    }
    self.showdata = [self.showArray componentsJoinedByString:@","];
    [_tableView reloadData];
 
}

-(void)creacteBottomDelectBtn{
    if(!_deleBtn){
        _deleBtn = [self getButtonWithTlitle:@"删除" frame:CGRectMake(0, SCREEN_HEIGHT-44-64, SCREEN_WIDTH/2, 44) textColor:[UIColor blackColor]  backgColor:[UIColor whiteColor]];
        [_deleBtn addTarget:self action:@selector(onBtnDelectClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleBtn];
    }
    if(!_sendMsgBtn){
        _sendMsgBtn = [self getButtonWithTlitle:@"发送短信" frame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-44-64, SCREEN_WIDTH/2, 44) textColor:TextMainCOLOR  backgColor:MAINCOLOR ];
        [_sendMsgBtn addTarget:self action:@selector(onBtnSendMsgClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendMsgBtn];
    }
    _deleBtn.hidden=YES;
    _sendMsgBtn.hidden=YES;
}

-(UIButton*)getButtonWithTlitle:(NSString*)tiltle frame:(CGRect)frame textColor:(UIColor*)textColor backgColor:(UIColor*)backgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:tiltle forState:UIControlStateNormal];
    btn.titleLabel.font = LargeFont;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.frame = frame;
    btn.backgroundColor = backgColor;
    return btn;
}

#pragma mark 删除手机号按钮事件
-(void)onBtnDelectClick{
    if (self.showArray.count >0) {
        for (NSDictionary *dict in self.recordArray) {
            if ([self.dataArray containsObject:dict]) {
                [self.dataArray removeObject:dict];
            }
        }
        [self.showArray removeAllObjects];
        self.showdata = nil;
        
        if (self.dataArray.count >0){
            
            
        }else{
            allSelected = NO;
            selected = NO;
            [_select setTitle:@"选择" forState:UIControlStateNormal];
            [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_back];
            
        }
         [self.tableView reloadData];
    }else{
        [[KNToast shareToast] initWithText:@"请先选择手机号码！" duration:1.0 offSetY:0];
    }
}

#pragma mark 发送短信
-(void)onBtnSendMsgClick{
    
    if (_showArray.count > 0) {
        MessageVController *msg=[[MessageVController alloc]init];
       msg.showArray= [NSMutableArray arrayWithCapacity:0];
        [msg.showArray  addObjectsFromArray: self.showArray];
        msg.phone = self.showdata;
         [self.navigationController pushViewController:msg animated:YES];
    }else{
        [[KNToast shareToast] initWithText:@"请先选择手机号！" duration:1 offSetY:0];
    }
}

#pragma mark 开始--停止 扫描按钮
-(void)creactStartAndStopBtn{
    _imageScane.hidden=YES;
    _line.hidden=YES;
    if(!_startScane){
        _startScane = [self getButtonWithTlitle:@"开始扫描" frame:CGRectMake(120,50, SCREEN_WIDTH-240, 30) textColor:[UIColor blackColor]  backgColor:OrderTextCOLOR];
        [_startScane addTarget:self action:@selector(onStartScanerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _startScane.titleLabel.font=[UIFont systemFontOfSize:15];
        [_startScane setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        _startScane.layer.cornerRadius=5;
        _startScane.layer.masksToBounds=YES;
        [self.view addSubview:_startScane];
    }
    
    if(!_stopScan){
        _stopScan = [self getButtonWithTlitle:@"" frame:CGRectMake(SCREEN_WIDTH-40,  90, 25, 25) textColor:TextMainCOLOR  backgColor:[UIColor clearColor] ];
        [_stopScan addTarget:self action:@selector(onStopBtnScanerClick) forControlEvents:UIControlEventTouchUpInside];
        [_stopScan setBackgroundImage:[UIImage imageNamed:@"btn_scansotp"] forState:UIControlStateNormal];
        _stopScan.hidden=YES;
        [self.view addSubview:_stopScan];
    }
    
}

-(void)onStartScanerBtnClick{
    _recordSancn = @"Start";
    [UIView animateWithDuration:0.5 animations:^{
        _startScane.frame=CGRectMake(SCREEN_WIDTH-40+13,  90+13, 0, 0) ;
    } completion:^(BOOL finished) {
        
        _startScane.hidden=YES;
        _stopScan.hidden=NO;
        [self startSession];
    }];
    _imageScane.hidden=NO;
    _line.hidden=NO;
}

-(void)onStopBtnScanerClick{
 
    _recordSancn = @"Stop";
    [UIView animateWithDuration:0.5 animations:^{
        _startScane.hidden=NO;
        _stopScan.hidden=YES;
        _startScane.frame=CGRectMake(120,50, SCREEN_WIDTH-240, 30)  ;
    } completion:^(BOOL finished) {
        [self stopSession];
    }];
    _imageScane.hidden=YES;
    _line.hidden=YES;
}

#pragma mark  扫描框图片
-(void)creactScanImage{
    _imageScane = [[UIImageView alloc]initWithFrame:CGRectMake(80,40,SCREEN_WIDTH-160,65)];
    _imageScane.image = [UIImage imageNamed:@"scanscanBg.png"];
    [self.view addSubview:_imageScane];
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-_imageScane.width)/2, CGRectGetMinY(_imageScane.frame)+5,_imageScane.width,1)];
    _line.image = [UIImage imageNamed:@"qr_scan_line.png"];
    [self.view addSubview:_line];
    
    _timer =[NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((SCREEN_WIDTH-_imageScane.width)/2, CGRectGetMinY(_imageScane.frame)+5+1 *num, _imageScane.width,1);
        if (num ==(int)(( _imageScane.height )/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake((SCREEN_WIDTH-_imageScane.width)/2, CGRectGetMinY(_imageScane.frame)+5+1 *num,_imageScane.width,1);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
#pragma mark  __________扫描手机号_----------------------
#pragma mark 初始化相机
-(void)creactCamer{
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];

      self.view.layer.contentsRect = CGRectMake(0.0, 0.0, 0.1, 0.05);

    if (SCREEN_WIDTH == 320) {
        layer.frame = CGRectMake(40,0,SCREEN_WIDTH-80,175);
    }else{
        layer.frame = CGRectMake(80,40,SCREEN_WIDTH-160,175);
    }

    self.view.layer.contentsScale = .1;

    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.affineTransform= CGAffineTransformMakeScale(2, 2);

    [self.view.layer addSublayer:layer];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
    
    output = [[AVCaptureStillImageOutput alloc] init];
    
    dispatch_queue_t captureQueue = dispatch_queue_create("com.kai.captureQueue", NULL);
    
    output2 = [[AVCaptureVideoDataOutput alloc] init];
    
    output2.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
    output2.alwaysDiscardsLateVideoFrames = YES;
    [output2 setSampleBufferDelegate:self queue:captureQueue];
    
    if ([_session canAddInput:input]){
        
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        [_session addOutput:output2];
    }
    [_device addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
}

//callback
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
//                NSLog(@"Is adjusting focus? %@", adjustingFocus ?@"YES":@"NO");
//                NSLog(@"Change dictionary: %@", change);
//        _getImg=YES;
//        
    }
}

#pragma mark 加速器
-(void)createJiaSuQi{
    /**
     *  获取到加速计的单利对象
     */
    UIAccelerometer * accelertometer = [UIAccelerometer sharedAccelerometer];
    /**
     *  设置加速计的代理
     */
    accelertometer.delegate = self;
    /**
     *  updateInterval  刷新频率，一秒更新30次
     */
    accelertometer.updateInterval = 1.0/1.0;

}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    //检测摇动 1.5 为轻摇 。2.0 为重摇
    if (fabs(acceleration.x)>0.1 || abs(acceleration.y>0.1)||abs(acceleration.z>0.1)) {
        //        NSLog(@"你摇动我了")
        //    [self focusAtPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        
        [self focusAtPoint];
        
    }
    
}
- (void)focusAtPoint{
  
    CGPoint point=CGPointMake((SCREEN_WIDTH-160)/2+80, (SCREEN_WIDTH-160)/2+40);
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        //对焦模式和对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
         //   _getImg=YES;
        }
        //曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        //设置对焦动画
        //        _focusView.center = point;
        //        _focusView.hidden = NO;
        
    }
}
#pragma mark 获取手机号码识别结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];//文字方向
    connection.videoMinFrameDuration = CMTimeMake(1, 14);


    [[setManger sharedInstanceTool] recognizeImageWithTesseract:[self imageFromSampleBuffer:sampleBuffer] finish:^(UIImage *img) {
   /*   dispatch_async(dispatch_get_main_queue(), ^{
          _tempImg.image=img;
        [self.view addSubview:_tempImg];
        
         });*/

    } text:^(NSString *text) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSLog(@"识别的结果 %@",text);
            if (text&&text.length == 11) {
                [_session stopRunning];
                [self performSelector:@selector(getResult:) withObject:text afterDelay:0.1];
            }
        });
        
    } ];
}

-(void)getResult:(NSString*)text{
    [self getSearchInfor:text];
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}
-(void)start{
    [_session startRunning];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer//从摄像头获取数据转化图片
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    
    CGImageRelease(quartzImage);
   
    return (image);
}

#pragma mark  剪切图片  111111
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


#pragma mark 开始扫描
-(void)startSession{
    
    [_session startRunning];

}

#pragma mark 停止扫描
-(void)stopSession
{
    [_session stopRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    [_session stopRunning];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark -------获取分拣信息
-(void)getSearchInfor:(NSString*)telePhoneNum{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSString *hmac = [[communcat sharedInstance ] hmac:telePhoneNum withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getSortInfoWithkey:userInfoModel.key  degist:hmac telephone:telePhoneNum resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                    
                }else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
                    
                    NSArray *array = dic[@"data"][@"building_nos"];
                    if (array.count >0) {
                        for (NSDictionary *dict in array) {
                            if ([self.dataArray containsObject:dict]) {
                                [self.dataArray removeObject:self.dataArray[[self.dataArray indexOfObject:dict]]];
                            }
                            if (allSelected == YES) {
                                [self.showArray addObject:dict[@"recipient_mobile"]];
                                self.showdata = [self.showArray componentsJoinedByString:@","];
                                 
                            }
                            [self.dataArray insertObject:dict atIndex:0];
                        }
                       
                    }else{
                        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                        [dict setObject:telePhoneNum forKey:@"recipient_mobile"];
                        [dict setObject:@"无结果" forKey:@"building_no"];

                        if ([self.dataArray containsObject:dict]) {
                            [self.dataArray removeObject:self.dataArray[[self.dataArray indexOfObject:dict]]];
                        }
                        if (allSelected == YES) {
                            [self.showArray addObject:dict[@"recipient_mobile"]];
                            self.showdata = [self.showArray componentsJoinedByString:@","];
                        }
                        [self.dataArray insertObject:dict atIndex:0];
                
                }
                    [self.tableView reloadData];
                }else{
                    [[iToast makeText:[dic objectForKey:@"message"]] show];
                }
            } );
        }];
    });
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

@end

