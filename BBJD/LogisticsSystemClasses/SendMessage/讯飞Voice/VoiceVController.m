//
//  VoiceVController.m
//  BBJD
//
//  Created by cbwl on 16/12/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "VoiceVController.h"
#import "publicResource.h"
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

@interface VoiceVController ()<IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate>
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
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic,strong)NSString *result ;//识别结果
@property (nonatomic,strong)UILabel *resultLbl;//识别结果展示
@property(nonatomic,strong)UILabel *showLabel;//讯飞
@end

@implementation VoiceVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor clearColor];
  //  [self creacteIfly];
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    [self creactView];

    [self initRecognizer2];//初始化识别对象

    [self startvoice];


}
-(void)viewWillDisappear:(BOOL)animated
{
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        [_iFlySpeechRecognizer cancel]; //取消识别
        [_iFlySpeechRecognizer setDelegate:nil];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        [_pcmRecorder stop];
        _pcmRecorder.delegate = nil;
    }
    else
    {
        [_iflyRecognizerView cancel]; //取消识别
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }

    
    [super viewWillDisappear:animated];
}

-(void)creactView{
    if ( !_bg) {
        _bg=[UIView new];
        UIColor *color = [UIColor blackColor];
        _bg.backgroundColor = [color colorWithAlphaComponent:0.4];//保证子控件不透明
        _bg.layer.cornerRadius=5;
        _bg.layer.masksToBounds=YES;
        _bg.frame=CGRectMake(60,(SCREEN_HEIGHT-220-64)/2, SCREEN_WIDTH-120, 180);
        [self.view addSubview:_bg];
    }
    
    if (!_titileMsg) {
        _titileMsg=[UILabel new];
        _titileMsg.textColor=[UIColor whiteColor];
        _titileMsg.text=@"语音录入手机号";
        _titileMsg.font=[UIFont systemFontOfSize:18];
        [_bg addSubview:_titileMsg];
    }
    if (!_line1) {
        _line1=[UIView new];
        _line1.backgroundColor=LineColor;
        [_bg addSubview:_line1];
        _line1.sd_layout.leftSpaceToView(_bg,25)
        .topSpaceToView(_bg,35)
        .rightSpaceToView(_bg,25)
        .heightIs(1);
    }
    
    if (!_line2) {
        _line2=[UIView new];
        _line2.backgroundColor=LineColor;
        [_bg addSubview:_line2];
        _line2.sd_layout.leftSpaceToView(_bg,25)
        .topSpaceToView(_bg,100)
        .rightSpaceToView(_bg,25)
        .heightIs(1);
        
    }
    if (!_imgGif) {
        self.imgGif = [[UIImageView alloc]init];
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"yinpin.gif" ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        
       // //第一种方法使用imageData加载
         self.imgGif.image = [UIImage sd_animatedGIFWithData:imageData];

        [self.bg addSubview:self.imgGif];

    }

    if (!_cancel) {
        _cancel=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.layer.cornerRadius = 5;
        _cancel.layer.masksToBounds=YES;
        _cancel.layer.borderWidth = 1;
        _cancel.layer.borderColor=[UIColor whiteColor].CGColor;
        [_cancel setTitle:@"关闭" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_cancel];
    }
    
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.text = @"语音技术由科大讯飞提供";
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.textAlignment = 1;
        _showLabel.alpha = 0.5;
        _showLabel.font = [UIFont systemFontOfSize:12];
        [_bg addSubview:_showLabel];
    }
    _titileMsg.sd_layout.centerXEqualToView(_bg)
    .topSpaceToView(_bg,10);
    [_titileMsg setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-40];

    self.imgGif.sd_layout.centerXEqualToView(_bg)
    .topSpaceToView(_titileMsg,15)
    .heightIs(60)
    .widthIs(100);
  
    _cancel.sd_layout.leftSpaceToView(_bg,60)
    .topSpaceToView(_line2,15)
    .heightIs(40)
    .widthIs(_bg.width-120);
    
    _showLabel.sd_layout.leftSpaceToView(_bg,20)
    .topSpaceToView(_cancel,5)
    .rightSpaceToView(_bg,20)
    .heightIs(15);

}

#pragma mark 反回按钮事件

-(void)onCancelClick{
    if([self.delegate respondsToSelector:@selector(cancelVoiceBtnClick)]){
        [self.delegate cancelVoiceBtnClick];
    }
        
}


/**
设置识别参数
****/
-(void)initRecognizer2
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"585b2e39"];
   [IFlySpeechUtility createUtility:initString];
 

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
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"10000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
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
        
//        _pcmRecorder.delegate = self;
        
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

-(void)startvoice{
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
 
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer2];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
       
//        //设置最长录音时间
//        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        
        //
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置多少ms后断开录音
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
//            [_audioStreamBtn setEnabled:NO];
//            [_upWordListBtn setEnabled:NO];
//            [_upContactBtn setEnabled:NO];
            
        }else{
          //  [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        }
    }else {
        
        if(_iflyRecognizerView == nil)
        {
            [self initRecognizer2 ];
        }
  
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

-(void)stopVoice{
    
    [_pcmRecorder stop];
    
    [_iFlySpeechRecognizer cancel];
    
}

/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{

//    if (self.isStreamRec == NO)
//    {
//        self.isBeginOfSpeech = YES;
//        [_popUpView showText: @"正在录音"];
//    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    DLog(@"onEndOfSpeech");
    
   // [_pcmRecorder stop];
//    [_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    
//    if ([IATConfig sharedInstance].haveView == NO ) {
//        
//    
//      }else {
//     }
    [self startvoice];

}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/

#pragma mark 识别手机号结果处理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];

    NSString * responseString = [resultFromJson stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
    
    responseString = [responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"   " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"|" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"i" withString:@"1"];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"k" withString:@""];
     responseString = [responseString stringByReplacingOccurrencesOfString:@"," withString:@""];
     responseString = [responseString stringByReplacingOccurrencesOfString:@"，" withString:@""];
    _result = [self checkPhoneValue:responseString];
    if (_result.length>0) {
        if([self.delegate respondsToSelector:@selector(finishReginise:)]){
            [self.delegate finishReginise:_result];
        }
    }else{
        if ([self isPureInt:responseString]) {
            [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"手机号码有误:%@",responseString] duration:1 offSetY:SCREEN_HEIGHT-100];
        }
    }
}

//判断是否全是数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}

/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    DLog(@"shibie you结果了  %@",result);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)checkPhoneValue:(NSString *)text{
    //从字符串中获取数字
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *shuzi =[text stringByTrimmingCharactersInSet:nonDigits];
    
    NSString * responseString = [shuzi stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
    
    responseString = [responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"   " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"|" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"i" withString:@"1"];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"k" withString:@""];
    
    ///正则判断手机号
    NSString *regex =  @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSUInteger len = [responseString length];
     NSString *str3;
    for (int i=0;i<len;i++){
        NSString *str=  [NSString stringWithFormat:@"%@",[responseString substringWithRange:NSMakeRange(i, 1)]];
        if ([str isEqualToString:@"1"] ) {
            
            NSString *str2=[responseString substringWithRange:NSMakeRange(i, len-i)];
            if (str2.length>=11) {
                
                str3=[str2 substringWithRange:NSMakeRange(0, 11)];
                BOOL isMatch = [pred evaluateWithObject:str3];
                if (isMatch){
 
                    return str3;
                    
                }
            }
        }
    }
    
    return nil;
}

@end
