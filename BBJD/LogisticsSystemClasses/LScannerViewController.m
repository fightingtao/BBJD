//
//  LScannerViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ScannerListTableViewCell.h"
#import "communcat.h"
#import "NetModel.h"

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20
#define SWidth (XCenter+30)

@interface LScannerViewController ()<UITableViewDataSource,UITableViewDelegate,ScannerGoodsDelegate>
{
   
    NSString *_order_id;
     UIImageView * imageView;
    NSInteger _index; //记录哪个按钮被点击

}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *scannerView;
@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,copy) NSMutableArray *goodsArray;
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;
@property(nonatomic,copy) NSString *  path;//声音名字
@property(nonatomic,copy) NSString *  type;//声音格式
/*2.0增加输入订单号功能*/
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *inputButton;
@end

@implementation LScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色    //添加头部菜单栏
    //添加头部菜单栏
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
         _titleLabel.text = [NSString stringWithFormat:@"已扫描%ld单",_goodsArray.count];
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
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30,50,SCREEN_WIDTH-60,SWidth-80)];
    imageView.image = [UIImage imageNamed:@"saomiao.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.x+5,imageView.y+5, imageView.width-10,1)];
    _line.image = [UIImage imageNamed:@"saomiao1.png"];
    [self.view addSubview:_line];
    

  timer = [NSTimer timerWithTimeInterval:.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self setupCamera];

    [self.view addSubview:self.goodsTableview];
    _path=@"success";
    _type=@"wav";
    //tabHeaderView
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,imageView.y+imageView.height+15, SCREEN_WIDTH, 60)];
        _headerView.backgroundColor = ViewBgColor;
    }
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,SCREEN_WIDTH-80-10-20-20, 40)];
        _textField.clipsToBounds = YES;
        _textField.layer.cornerRadius = 10;
        _textField.placeholder = @"   请输入订单号";
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.borderColor = MAINCOLOR.CGColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
       _textField.keyboardType = UIKeyboardTypeASCIICapable;
        [_headerView addSubview:_textField];
    }
    
    if (!_inputButton) {
        _inputButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10,80, 40)];
        [_inputButton setTitle:@"输入" forState:UIControlStateNormal];
        [_inputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inputButton.backgroundColor = MAINCOLOR;
        _inputButton.clipsToBounds = YES;
        _inputButton.layer.cornerRadius = 10;
        [_inputButton addTarget:self action:@selector(inputButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_inputButton];
    }
    [self.view addSubview:_headerView];
    [self.view addSubview: [self inithomeTableView]];
    //监听键盘的升起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset =   SCREEN_HEIGHT-320-60 -kbHeight;

    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (offset < 0 ) {
    //将视图上移计算好的偏移
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f,offset, SCREEN_WIDTH, 60);
        }];
    }
}

/////键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    // 获取订单信息
    [self getScannerListInfor];
    [_session startRunning];

}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

#pragma mark------------- 获取订单列表----------------
-(void)getScannerListInfor{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *userData = [userDefault objectForKey:UserKey];
    
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSString *hamcString = [[communcat sharedInstance] hmac:self.requirment_id withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]
         
         getOrderScanListInfoWithkey:userInfoModel.key degist:hamcString requirment_id:self.requirment_id resultDic:^(NSDictionary *dic) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             int code=[[dic objectForKey:@"code"] intValue];
             
             if (!dic)
             {
                 [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                 
             }else if (code == 1000){
                 NSDictionary * data =[dic objectForKey:@"data"];
                 NSArray *array = [data objectForKey:@"order_ids"];
                 for(NSDictionary *result in array){
                     NSString *order_original_id = [result objectForKey:@"order_original_id"];
                     
                     [_goodsArray addObject:order_original_id];
                     _titleLabel.text = [NSString stringWithFormat:@"已扫描%ld单",_goodsArray.count];
                     [self.goodsTableview reloadData];
                 }
             }else{
                 [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                 
             }
         }];
    });
}

#pragma mark 语音播放
-(void)playAudio{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    //    self.avAudioPlayer.delegate = self;
    
    //设置初始音量大小
    self.avAudioPlayer.volume = 1;
    
    //设置音乐播放次数  -1为一直循环
    self.avAudioPlayer.numberOfLoops = 0;
    
    //预播放
    [self.avAudioPlayer prepareToPlay];
    
    [self.avAudioPlayer play];
}

//初始化table
-(UITableView *)inithomeTableView
{
    _goodsArray = [NSMutableArray array];
    
    if (_goodsTableview != nil) {
        return _goodsTableview;
    }

    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = _headerView.y+_headerView.height;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height - rect.origin.y -64;
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _goodsTableview.delegate = self;
    _goodsTableview.dataSource = self;
    _goodsTableview.backgroundColor = ViewBgColor;
    _goodsTableview.showsVerticalScrollIndicator = NO;
   _goodsTableview .separatorStyle = UITableViewCellSeparatorStyleNone;

    self.goodsTableview.rowHeight = 50;
    return _goodsTableview;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_goodsArray count];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor grayColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScannerListTableViewCell *cell= [ScannerListTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_goodsArray];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    cell.cancelOrderBtn.tag = indexPath.row;
    
    return cell;
}

//导航栏左右侧按钮点击
- (void)leftItemClick

{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-------------取消订单-----------------------

//取消单号
- (void)cancelOrderWithIndex:(NSInteger)index
{
    _index = index;
    
    UIAlertView *alerltView=[[UIAlertView alloc]initWithTitle:@"用户提示:" message:@"是否删除已扫描账单？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    [alerltView show];
    
}

//取消按钮弹框提醒
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        _order_id = _goodsArray[_index];//获取点击的单号

        [self cancelOrderList];
        
    }
}

-(void)cancelOrderList{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *userData = [userDefault objectForKey:UserKey];
    
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hamcString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",_order_id] withKey:userInfoModel.primary_key];
    
    In_orderScanModel *InModel = [[ In_orderScanModel alloc]init];
    InModel.key = userInfoModel.key;
    InModel.digest = hamcString;
    
    InModel.order_id = [NSString stringWithFormat:@"%@",_order_id];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]cancelOrderWithMsg:InModel resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic)
            {
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                
            }
            else if (code ==1000)
            {
                [self.goodsArray removeObjectAtIndex:_index];
                _titleLabel.text = [NSString stringWithFormat:@"已扫描%ld单",_goodsArray.count];


                 [_goodsTableview reloadData];
                [[iToast makeText:@"取消成功"] show];
            }else{
                 [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
            }
        }];
    });
}


-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(imageView.x+5,imageView.y+5+2*num, imageView.width-10,1);
        
        if (num ==(int)((imageView.height-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(imageView.x+5,imageView.y+5+2*num, imageView.width-10,1);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 1.获取屏幕的frame
    CGRect viewRect = self.view.frame;
    // 2.获取扫描容器的frame
    CGRect containerRect = imageView.frame;
    
    CGFloat x = containerRect.origin.y / viewRect.size.height;
    CGFloat y = containerRect.origin.x / viewRect.size.width;
    
    CGFloat width = containerRect.size.height / viewRect.size.height;
    
    CGFloat height = containerRect.size.width / viewRect.size.width;
    
    _output.rectOfInterest = CGRectMake(x, y, width, height);
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];
    
    [self setOverView];
    
    UILabel * labIntroudction = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    [labIntroudction setText:@"将二维码/条形码放入取景框中即可自动扫描"];
    labIntroudction.font = [UIFont systemFontOfSize:15];
    [labIntroudction setTextColor:[UIColor whiteColor]];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
    [self.view bringSubviewToFront:labIntroudction];
    
    // 7.添加容器图层
    [self.view.layer addSublayer:self.layer];
    self.layer.frame = self.view.bounds;

    // Start
    [_session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate返回数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;//获取扫描结果
        [_session stopRunning];
        [self.layer removeFromSuperlayer];
    }
    
    if (!stringValue || [stringValue isEqualToString:@""]) {
        return;
    }
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    BOOL isHaving = NO;
    for (int i = 0; i < [_goodsArray count]; i++) {
        NSString *temp = [_goodsArray objectAtIndex:i];
        if (!isHaving) {
            if ([temp isEqualToString:stringValue]) {
                isHaving = YES;
                
            }else{
                isHaving = NO;
                
            }
        }
    }
    if (isHaving) {
         [[KNToast shareToast] initWithText:@"该单已扫入成功,不可重复扫描!"  duration:1.5 offSetY:0];
         [_session startRunning];
    }else
    {
        _order_id = stringValue;
        [self scanOrderList];//上传数据到服务器
    }
}

#pragma mark  输入订单号上传到服务器
-(void)inputButtonClick{
    if (_textField.text.length > 50) {
        [[iToast makeText:@"订单号不能超过50位"] show];
        return;
    }
    if (_textField.text.length == 0) {
        [[iToast makeText:@"请输入订单号!"] show];
        return;
    }
    if ([_textField.text containsString:@"/"] || [_textField.text containsString:@"@"] || [_textField.text containsString:@"&"] || [_textField.text containsString:@"!"] || [_textField.text containsString:@"?"] || [_textField.text containsString:@"."] || [_textField.text containsString:@"("] || [_textField.text containsString:@")"] || [_textField.text containsString:@"="] || [_textField.text containsString:@":"] || [_textField.text containsString:@";"] || [_textField.text containsString:@"$"] || [_textField.text containsString:@","] || [_textField.text containsString:@"'"] ) {
        [[iToast makeText:@"订单不存在"] show];
        return;
    }
    if ([_goodsArray containsObject:_textField.text]) {//订单不能重复
        [[iToast makeText:@"该单已扫入成功,不可重复扫描!"] show];
        return;
    }else{
        _order_id = _textField.text;
        [self scanOrderList];
        _textField.text = @"";
        [_textField resignFirstResponder];
    }
}

#pragma mark--------------------订单扫描---------------------
-(void)scanOrderList{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",self.requirment_id],[NSString stringWithFormat:@"%@",_order_id],[NSString stringWithFormat:@"%@",self.seller_type],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_orderScanModel *InModel = [[ In_orderScanModel alloc]init];
    InModel.key = userInfoModel.key;
    InModel.digest = hmacString;
    InModel.order_id = [NSString stringWithFormat:@"%@",_order_id];
    InModel.requirment_id = self.requirment_id;
    InModel.type = self.seller_type;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] orderScanWithMsg:InModel resultDic:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int code =[[dic objectForKey:@"code"] intValue];
            
            if (!dic){
                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                [_session startRunning];
            }else if (code == 1000){
                [self playAudio];
                [[iToast makeText:@"领货成功"] show];
                if(![_goodsArray containsObject:_order_id]){
                    [_goodsArray insertObject:_order_id atIndex:_goodsArray.count];
                }
                _titleLabel.text = [NSString stringWithFormat:@"已扫描%ld单",_goodsArray.count];
                [self.goodsTableview reloadData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.goodsArray.count -1 inSection:0];
                [self.goodsTableview scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
                [_session startRunning];
                
            }else{
                [[KNToast shareToast] initWithText:[dic objectForKey:@"message"]  duration:1.5 offSetY:0];
                [_session startRunning];
            }
        }];
    });
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = 320;
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

@end
