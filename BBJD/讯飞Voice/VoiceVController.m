//
//  VoiceVController.m
//  BBZhongBao
//
//  Created by cbwl on 16/12/21.
//  Copyright © 2016年 CYT. All rights reserved.
//
#import "UIView+SDAutoLayout.h"
#import "VoiceVController.h"
//#import "publicResource.h"
#import "UIImage+GIF.h"
//不带界面的语音识别控件
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"

#import "iflyMSC/IFlySpeechUnderstander.h"
#import "IATConfig.h"
#import "iflyMSC/iFlySpeechRecognizer.h"

#import "iflyMSC/IFlyPcmRecorder.h"
#import "ISRDataHelper.h"

//屏幕宽度和高度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//worktextcolor
#define kTextWorkCOLOR [UIColor colorWithRed:0.5843 green:0.4824 blue:0.7176 alpha:1.0]

//主色调(紫色）
#define MAINCOLOR [UIColor colorWithRed:0.2471 green:0.1137 blue:0.3922 alpha:1.0]

//textmaincolor(白色)
#define TextMainCOLOR [UIColor colorWithRed:0.9647 green:0.9608 blue:0.9725 alpha:1.0]
#define kTextMainCOLOR [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.8]
//textmaincolor(红色)
#define kTextRedCOLOR [UIColor redColor]
//textmaincolor(黑色）
#define kTextBlackCOLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
//占位文字颜色
#define TextPlaceholderCOLOR [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0]


//textdetailcolor
#define TextDetailCOLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]

//textdetailcolor
#define OrderTextCOLOR [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]

#define ButtonBGCOLOR [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]

//view背景色
#define ViewBgColor   [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]
#define WHITECOLOR  [UIColor whiteColor]
#define LineColor   [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]

#define WhiteBgColor  [UIColor whiteColor]

#define DaiSongColor  [UIColor colorWithRed:255.0/255.0 green:157.0/255.0 blue:44.0/255.0 alpha:1]
#define DaiGouColor  [UIColor colorWithRed:57.0/255.0 green:173.0/255.0 blue:54.0/255.0 alpha:1]
#define DaiBanColor  [UIColor colorWithRed:27.0/255.0 green:107.0/255.0 blue:165.0/255.0 alpha:1]


//字体
#define LargeFont   [UIFont systemFontOfSize:18.0]
#define kTextFont16   [UIFont systemFontOfSize:16.0]
#define MiddleFont   [UIFont systemFontOfSize:15.0]
#define LittleFont   [UIFont systemFontOfSize:14.0]
#define WideFont [UIFont fontWithName:@"Helvetica-Bold" size:15.0]
@interface VoiceVController ()<IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
    IFlyPcmRecorder *_pcmRecorder;
    
}
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic,strong)IFlySpeechRecognizer  *iFlySpeechRecognizer;
@property (nonatomic,strong)UILabel *titileMsg;//
@property (nonatomic,strong)UIView *bg;//
@property (nonatomic,strong)UIImageView *imgGif;//
@property (nonatomic,strong)UIButton *cancel;//
@property (nonatomic,strong)UIButton *sure;//
@property (nonatomic,strong)UIView *line1;//
@property (nonatomic,strong)UIView *line2;//
@end

@implementation VoiceVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:76/255 green:76/255 blue:76/255 alpha:0.5];
    [self creactView];
    [self creacteIfly];
}
-(void)creactView{
    if ( !_bg) {
        _bg=[UIView new];
        _bg.backgroundColor=[UIColor whiteColor];
        _bg.layer.cornerRadius=5;
        _bg.layer.masksToBounds=YES;
        _bg.frame=CGRectMake(20, 125, SCREEN_WIDTH-40, 220);
        [self.view addSubview:_bg];
    }
    
    if (!_titileMsg) {
        _titileMsg=[UILabel new];
        _titileMsg.textColor=[UIColor blackColor];
        _titileMsg.text=@"语音录入手机号";
        _titileMsg.font=[UIFont systemFontOfSize:18];
               [_bg addSubview:_titileMsg];
    }
    if (!_line1) {
        _line1=[UIView new];
        _line1.backgroundColor=LineColor;
        [_bg addSubview:_line1];
        _line1.sd_layout.leftSpaceToView(_bg,25)
        .topSpaceToView(_bg,50)
        .rightSpaceToView(_bg,25)
        .heightIs(1);
        
    }
    if (!_line2) {
        _line2=[UIView new];
        _line2.backgroundColor=LineColor;
        [_bg addSubview:_line2];
        _line1.sd_layout.leftSpaceToView(_bg,25)
        .topSpaceToView(_bg,130)
        .rightSpaceToView(_bg,25)
        .heightIs(1);
        
    }
    if (!_imgGif) {
        self.imgGif = [[UIImageView alloc]init];
        
        
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"yinpin.gif" ofType:nil];
        
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        
        //self.imgGif.backgroundColor = [UIColor blueColor];
       // //第一种方法使用imageData加载
         self.imgGif.image = [UIImage sd_animatedGIFWithData:imageData];
        //第二种方法使用图片名字加载
       // self.imgGif.image = [UIImage sd_animatedGIFNamed:@"yinpin"];
        
        [self.bg addSubview:self.imgGif];

    }
   
    if (!_cancel) {
        _cancel=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.layer.cornerRadius=5;
        _cancel.layer.masksToBounds=YES;
        _cancel.layer.borderWidth=2;
        _cancel.layer.borderColor=MAINCOLOR.CGColor;
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_cancel];
       
        
    }
    if (!_sure) {
        _sure=[UIButton buttonWithType:UIButtonTypeCustom];
        _sure.layer.cornerRadius=5;
        _sure.layer.masksToBounds=YES;
        _sure.layer.borderWidth=2;
        _sure.layer.borderColor=MAINCOLOR.CGColor;
        [_sure setTitle:@"确认" forState:UIControlStateNormal];
        [_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sure setBackgroundColor:MAINCOLOR];
        [_sure addTarget:self action:@selector(onSureClick) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_sure];
        
    }
    _titileMsg.sd_layout.centerXEqualToView(_bg)
    .topSpaceToView(_bg,10);
    [_titileMsg setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-40];

    self.imgGif.sd_layout.centerXEqualToView(_bg)
    .topSpaceToView(_titileMsg,20)
    .heightIs(70)
    .widthIs(100);

    _cancel.sd_layout.leftSpaceToView(_bg,25)
    .bottomSpaceToView(_bg,24)
    .heightIs(40)
    .widthIs((SCREEN_WIDTH-110)/2);

    _sure.sd_layout.leftSpaceToView(_cancel,20)
    .bottomSpaceToView(_bg,24)
    .heightIs(40)
    .widthIs((SCREEN_WIDTH-110)/2);
}
-(void)onCancelClick{
    if([self.delegate respondsToSelector:@selector(cancelVoiceBtnClick)]){
        [self.delegate cancelVoiceBtnClick];
    }
        
}
-(void)onSureClick{
    if([self.delegate respondsToSelector:@selector(makeSureVoiceBtnClick)]){
        [self.delegate makeSureVoiceBtnClick];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creacteIfly{
    //将“12345678”替换成您申请的APPID。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"57ca97bf"];
    [IFlySpeechUtility createUtility:initString];
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
    [_iflyRecognizerView start];
    [self startVoiceRecoginse];
}
-(void)startVoiceRecoginse{
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        _iFlySpeechRecognizer.delegate=self;
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            //            [_audioStreamBtn setEnabled:NO];
            //            [_upWordListBtn setEnabled:NO];
            //            [_upContactBtn setEnabled:NO];
            
        }else{
            //            [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        }
        
    }else {
        
        if(_iflyRecognizerView == nil)
        {
            [self initRecognizer ];
        }
        
        //        [_textView setText:@""];
        //        [_textView resignFirstResponder];
        
        //设置音频来源为麦克风
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        BOOL ret = [_iflyRecognizerView start];
        if (ret) {
            //            [_startRecBtn setEnabled:NO];
            //            [_audioStreamBtn setEnabled:NO];
            //            [_upWordListBtn setEnabled:NO];
            //            [_upContactBtn setEnabled:NO];
        }
    }
}
-(void)stopVoiceRecg{
    [_iFlySpeechUnderstander stopListening];
    [_iFlySpeechRecognizer stopListening];
    
}
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    NSLog(@"是不是结果 %@",resultArray);
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    //   NSString * text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    
    NSLog(@"出错了么 %@",error);
    
}
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results [0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:result];
    
    NSLog(@"听写结果：%@   %@",result,resultFromJson);
  //  [[iToast makeText:resultFromJson]show];

}

/////////
//-(void)creactiFlySpeechUnderstander{
////    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
////    _iFlySpeechUnderstander.delegate = self;
////
//    //语义理解单例
//    if (_iFlySpeechUnderstander == nil) {
//        _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
//    }
//
//    _iFlySpeechUnderstander.delegate = self;
//
//    if (_iFlySpeechUnderstander != nil) {
//        IATConfig *instance = [IATConfig sharedInstance];
//
//        //参数意义与IATViewController保持一致，详情可以参照其解释
//        [_iFlySpeechUnderstander setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//        [_iFlySpeechUnderstander setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
//        [_iFlySpeechUnderstander setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
//        [_iFlySpeechUnderstander setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
//
//        if ([instance.language isEqualToString:[IATConfig chinese]]) {
//            [_iFlySpeechUnderstander setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//            [_iFlySpeechUnderstander setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
//        }else if ([instance.language isEqualToString:[IATConfig english]]) {
//            [_iFlySpeechUnderstander setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//        }
//        [_iFlySpeechUnderstander setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
//    }
//
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechUnderstander cancel];//终止语义
    [_iFlySpeechUnderstander setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [super viewWillDisappear:animated];
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
        
        //初始化录音器
        if (_pcmRecorder == nil)
        {
            _pcmRecorder = [IFlyPcmRecorder sharedInstance];
        }
        
        _pcmRecorder.delegate = self;
        
        [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
        
        [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
        
    }else  {//有界面
        
        //单例模式，UI的实例
        if (_iflyRecognizerView == nil) {
            //UI显示剧中
            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
            
            [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
            
        }
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //设置最长录音时间
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
}

@end
