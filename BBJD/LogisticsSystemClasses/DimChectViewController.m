//
//  DimChectViewController.m
//  BBJD
//
//  Created by 李志明 on 16/8/31.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "DimChectViewController.h"
#import "ScannerListTableViewCell.h"
#import "communcat.h"
#import "NetModel.h"

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)

#define SHeight 20

@interface DimChectViewController()
{
    BOOL _on;//闪光灯是否打开
    NSString *_order_id;
    UIImageView * imageView;
}
@property (nonatomic, strong) UIView *scannerView;
@property(nonatomic,strong)UIButton * flashButton;
@end

@implementation DimChectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewBgColor;
    self.view.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.automaticallyAdjustsScrollViewInsets=false;
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色    //添加头部菜单栏
    
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"扫描查询"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30,100,SCREEN_WIDTH-60,SWidth-80)];
    imageView.image = [UIImage imageNamed:@"saomiao.png"];
    [self.view addSubview:imageView];
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.x+5,imageView.y+5, imageView.width-10,1)];
    _line.image = [UIImage imageNamed:@"saomiao1.png"];
    [self.view addSubview:_line];
    
    
    timer = [NSTimer timerWithTimeInterval:.03 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self setupCamera];
    
    UILabel * labIntroudction = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 20)];
    [labIntroudction setText:@"将二维码/条形码放入取景框中即可自动扫描"];
    labIntroudction.font = [UIFont systemFontOfSize:14];
    [labIntroudction setTextColor:[UIColor whiteColor]];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
   
    //闪光灯
    _flashButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -65,SCREEN_HEIGHT-124, 40, 40)];
    [_flashButton setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(flashButtonClick) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:_flashButton];
    
}
-(void)flashButtonClick{
AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
if (![device hasTorch]) {
    
}else{
    [device lockForConfiguration:nil];
    if (!_on) {
        [device setTorchMode: AVCaptureTorchModeOn];
        _on = YES;
        [_flashButton setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
    }
    else
    {
        [device setTorchMode: AVCaptureTorchModeOff];
        [_flashButton setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
        _on = NO;
    }
    [device unlockForConfiguration];
}
}
//获取摄像头位置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [_session startRunning];
}


-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [_session stopRunning];
    self.tabBarController.tabBar.hidden = NO;
}

//导航栏左右侧按钮点击
- (void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    CGRect viewRect = self.view.bounds;
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
        if ([self.delegate respondsToSelector:@selector(getOrder_id:)]) {
            [self.delegate getOrder_id:stringValue];
        }

        UIViewController *viewco = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:viewco animated:YES];
        
    }
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = SCREEN_HEIGHT-64;
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = SCREEN_HEIGHT-64;
    
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
    CGFloat alpha = 0.8;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

@end
