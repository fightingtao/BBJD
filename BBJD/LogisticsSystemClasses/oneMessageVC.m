//
//  oneMessageVC.m
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.

#import "oneMessageVC.h"
#import "msgHomeViewController.h"
#import "listView.h"//资费说明
#import "VoiceVController.h"
#import "ListDetails.h"
#import "coreDataManger.h"
#import "MsgModelController.h"
#import "publicResource.h"
@interface oneMessageVC ()<UITextViewDelegate,ListCloseDelegate,VoiceViewCDelegate>
{
    float _balance;//钱包余额
    int _sm_amount;//短信额度
    int _free_amount;//剩余短信
    UIView *_listBg;
    listView *_list ;//资费说明
    NSInteger _numOfMsg;
    NSMutableArray *_phoneAry;
    int _msg_count;//短信条数
}

@property (nonatomic, strong)UIView *titleView;//标题view
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic,strong)VoiceVController *voice;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *msgLabel;
@end

@implementation oneMessageVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"短信群发"];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 80, 30);
    
    [rightItem setTitle:@"短信历史" forState:UIControlStateNormal];
    rightItem.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightItem addTarget:self action:@selector(rightItemItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    _phoneTextView.delegate=self;
    _phoneTextView.textColor=TextPlaceholderCOLOR;
    _phoneTextView.keyboardType =    UIKeyboardAppearanceAlert;
    _phoneTextView.textColor = [UIColor blackColor];
   
    _msgTextView.delegate=self;
    _msgTextView.textColor=TextPlaceholderCOLOR;
    [self setSendMsgNub ];
    [self createMoneyList];
    _list.hidden=YES;
    _listBg.hidden=YES;
    _list.alpha=0;

    [self getMsgMoneyToNumble];
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,5, _phoneTextView.width-20, 20)];
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.text = @"多个手机号请用英文,区分。";
        _phoneLabel.textColor = TextPlaceholderCOLOR;
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        [_phoneTextView addSubview:_phoneLabel];
    }
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -70, 40)];
        _msgLabel.numberOfLines = 0;
        _msgLabel.text = @"请编辑短信内容,默认包含签名【邦办即达】和您的手机号码。";
        _msgLabel.textColor = TextPlaceholderCOLOR;
        _msgLabel.font = [UIFont systemFontOfSize:14];
        [_msgTextView addSubview:_msgLabel];
    }
    _phoneAry=[[NSMutableArray alloc]init];


     _smstemplateId=@"0";

 }




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self calculateTextViewLength:_msgTextView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark 资费说明
- (IBAction)listMoney:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _list.alpha=1;
        _list.hidden=NO;
        _listBg.hidden=NO;
    }];
}

-(void)createMoneyList{
    if (!_listBg){
        _listBg=[UIView new];
        _listBg.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _listBg.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self.view addSubview:_listBg];
    }
    if ( !_list) {
        
        _list=[[listView alloc]init];
        _list.delegate=self;
        _list.layer.cornerRadius=3;
        _list.layer.masksToBounds=YES;
        _list.detail.text = @"1、达人首次认证成功后，可免费获得20条短信（仅限前3570名认证达人享受该项活动);\n2、本平台收取短信统一价0.04元/条;\n3、可支持短信群发及历史短信回顾内容功能;\n4、发送完成后费用将从您的达人可提现金额中扣款，请保证余额充足;\n5、活动最终解释权归<邦办即达>所有。";
        // 1.文字的最大尺寸
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
        //        cell.adressLabel.text  = @"hhahahha";
        // 2.计算文字的高度
        CGFloat textH = [_list.detail.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _list.frame=CGRectMake(20,(SCREEN_HEIGHT-textH-80)/2-64,SCREEN_WIDTH-40 ,textH + 80 );
        [_list sizeToFit];
        [self.view addSubview:_list];
    }
}

-(void)closeListBtnClick;//close资费声明
{
    [UIView animateWithDuration:1.0 animations:^{
        _list.alpha=0;
        _list.hidden=YES;
        _listBg.hidden=YES;
    }];
}

-(void)leftItemClick{
    self.backBtn.enabled=YES;
    self.sendBtn.enabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 短信历史
-(void)rightItemItemClick{
    
    msgHomeViewController *history=[[msgHomeViewController alloc]init];
    history.frome=1;
    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark - 语音按钮
- (IBAction)voicebtnLCick:(id)sender {
    _voice=[[VoiceVController alloc]init];
    _voice.delegate=self;
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

#pragma mark -------语音录入回调代理
-(void)finishReginise:(NSString *)resultString{
    [_phoneTextView becomeFirstResponder];
    if (![self isPureInt:_phoneTextView.text]) {
        _phoneTextView.text = nil;
        _phoneTextView.text = resultString;
        
    }else{
        if (_phoneTextView.text.length >0) {
            NSArray *a = [_phoneTextView.text componentsSeparatedByString:@","];
            if ([a containsObject:resultString]) {
                [[KNToast shareToast] initWithText:@"手机号码已存在！" duration:1 offSetY:0];
            }else{
                _phoneTextView.text = [ _phoneTextView.text stringByAppendingString:[NSString stringWithFormat:@",%@",resultString]];
            }
        }else{
            _phoneTextView.text = resultString;
        }
    }
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [_voice.view removeFromSuperview];
    [_voice removeFromParentViewController];
}

//判断是否全是数字
- (BOOL)isPureInt:(NSString *)string{
    NSString *str1 = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSScanner* scan = [NSScanner scannerWithString:str1];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark -  手机号  清空
- (IBAction)clearPhonebtn:(id)sender {
    _phoneTextView.text = nil;
    _phoneLabel.hidden = NO;
    [_phoneTextView resignFirstResponder];
    _selectNub.text=@"已选择 0 个手机号, 0 条";

}

#pragma mark - 清空短信内容
- (IBAction)clearMsgClick:(id)sender {
    [_msgTextView resignFirstResponder];
    _msgTextView.text = nil;
    _msgLabel.hidden = NO;
    [self calculateTextViewLength:_msgTextView];
}

#pragma mark - 返回按钮
- (IBAction)backbtnClick:(id)sender {
    if (_phoneTextView.hasText || _msgTextView.hasText) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"返回所编辑的内容将不会被保存,是否继续？" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 200) {
                [self leftItemClick];
            }
        }];
        [alert showLXAlertView];
    }else{
        [self leftItemClick];
    }
}

#pragma mark - 发送短信
- (IBAction)sendMsgClick:(id)sender {
    if (!_phoneTextView.hasText && !_phoneTextView.hasText) {
        [[KNToast shareToast] initWithText:@"请输入手机号码！" duration:1 offSetY:0];
        return;
    }
    NSArray *array = [_phoneTextView.text componentsSeparatedByString:@","];
    if (array.count >1) {
        for (int i = 0; i < array.count; i++) {
            NSString *string = array[i];
            for (int j = i+1; j < array.count; j++) {
                
                NSString *jstring = array[j];
                
                if([string isEqualToString:jstring]){
                    
                    [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"相同手机号:%@",string] duration:1 offSetY:0];
                    return;
                }
            }
        }
    }
    
    if (!_msgTextView.hasText && !_msgTextView.hasText) {
        [[KNToast shareToast] initWithText:@"请输入短信内容！" duration:1 offSetY:0];
        return;
    }
    //发送短信条数、短信额度
    if (_msg_count > (_sm_amount + _free_amount)){
        [[KNToast shareToast] initWithText:@"您的短信额度不足!" duration:1 offSetY:0];
        return;
    }
    [self sendMsgRegistWithPhone];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView==_phoneTextView) {
        _phoneLabel.hidden = YES;
        _phoneTextView.textColor = [UIColor blackColor];
        
    }
    else if (textView==_msgTextView){
        _msgLabel.hidden = YES;
        _msgTextView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView==_phoneTextView) {
        
        if (_phoneTextView.text.length==0) {
            _phoneLabel.hidden = NO;
            [_phoneTextView resignFirstResponder];
        }else{
            NSString *a = _phoneTextView.text;
            NSArray *b = [a componentsSeparatedByString:@","];
            
            for (NSString *phone in b) {
                if (![[communcat sharedInstance] checkTel:phone]&&phone.length>0) {
                    [[KNToast alloc]initWithText:@"请检查您输入的手机号是否正确" offSetY:0];
                    // break;
                }else{
                    if (phone.length>0) {
                        
                        [_phoneAry addObject:phone];
                        
                    }
                }
            }
        }
    }else if (textView==_msgTextView){
        if (_msgTextView.text.length == 0) {
             _msgLabel.hidden = NO;
            [_msgTextView resignFirstResponder];
        }
       
        [self calculateTextViewLength:_msgTextView];
    }
}

//计算文字长度
-(void)calculateTextViewLength:(UITextView *)textView{
    if (_msgTextView.text.length==0) {
        //_msgLength.text=@"短信长度 0 个字";
       // _selectNub.text=@"已选择 0 个手机号, 0 条";
        NSString *a=@"";
        NSArray *b=[NSArray array];
        _msg_count=0;
        [self textColorA:a B:b];
       
    }else{
         int zheng;
        int yu;
        if (_msgTextView.text.length <= 70-25){
            zheng=1;
        }
        else if (_msgTextView.text.length>70-25){
            zheng =((int)_msgTextView.text.length+25)/67;//取整
            yu =(_msgTextView.text.length+25)%67;//取余
            if (yu>0){
                zheng=zheng+1;
            }
        }
        
        //已选择
        NSString *a = _phoneTextView.text;
        
        NSArray *b = [a componentsSeparatedByString:@","];
        
        _numOfMsg = b.count;
        _msg_count =  zheng*((int)b.count);//短信条数
        [self textColorA:a B:b];
     
    }
    NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信长度 %ld 个字",_msgTextView.text.length]];
    NSString *str1= [NSString stringWithFormat:@"短信长度 %ld 个字",_msgTextView.text.length];
    NSString *str2= [NSString stringWithFormat:@"%ld",_msgTextView.text.length];
    NSRange range = [str1 rangeOfString:str2];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, range.length)];
    _msgLength.attributedText = string1;
}

-(void)textColorA:(NSString *)a B:(NSArray *)b{
    
    NSMutableAttributedString *string2;
    if (_phoneTextView.text.length == 0) {
   string2 =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %d 个手机号, %d 条",0,_msg_count]];
    }else{
        string2 =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",b.count,_msg_count]];
    }
    NSString *str1= [NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",b.count,_msg_count];
    NSString *str2= [NSString stringWithFormat:@"%d",_msg_count];
    NSString *str3 = [NSString stringWithFormat:@"%ld",b.count];
    NSRange range = [str1 rangeOfString:str2];
    NSRange range1 = [str1 rangeOfString:str3];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, range1.length)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range1.length+11, range.length)];
    _selectNub.attributedText = string2;
}

-(void)textViewDidChange:(UITextView *)textView{
    int zheng;
    int yu;
    [textView setContentInset:UIEdgeInsetsZero];
    [textView setTextAlignment:NSTextAlignmentLeft];
    if (textView==_msgTextView){
        [self calculateTextViewLength:_msgTextView];

        if (_msgTextView.text.length>560){
            _msgTextView.text=[textView.text substringWithRange:NSMakeRange(0, 560)];
            //return;
        }
    }
    if (_msgTextView.text.length <= 70-25){
        zheng=1;
    }
    else if (_msgTextView.text.length>70-25){
        zheng =((int)_msgTextView.text.length+25)/67;//取整
        yu =(_msgTextView.text.length+25)%67;//取余
        if (yu>0){
            zheng=zheng+1;
        }
    }
    //已选择
    NSString *a = _phoneTextView.text;
    NSArray *b = [a componentsSeparatedByString:@","];
    _numOfMsg = b.count;
    _msg_count =  zheng*((int)b.count);//短信条数
    [self textColorA:a B:b];
}

#pragma mark 数值设置
-(void)setSendMsgNub{
    //短信长度
    NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:@"短信长度 0 个字"];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 1)];
    _msgLength.attributedText=string1;
    //已选择
    NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:@"已选择 0 个手机号, 0 条"];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, 1)];
    _selectNub.attributedText=string2;
    
    //账号余额
    NSMutableAttributedString *string3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"钱包余额: ¥ %.2f",_balance]];
    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, string3.length-6)];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(6, string3.length-6)];
    _money.attributedText=string3;
    
    NSMutableAttributedString *string4 = nil;
    //短信额度
    
    if (_sm_amount >=300) {
        string4 = nil;
        _list_msgheight.constant=120;
        
        _msgnub.hidden=YES;
    }else{
        if (_free_amount > 0) {
            if (_sm_amount == 0) {
                string4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信额度: %d条(免费短信)",  _free_amount]];
            }else{
                string4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信额度: %d+%d条(免费短信)", _sm_amount , _free_amount ]];
            }
        }else{
            string4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信额度: %d条", _sm_amount]];
        }
    }
    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, string4.length-6)];
    [string4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(6,string4.length-6)];
    _msgnub.attributedText=string4;
    
}

#pragma mark 获取度短信余额
-(void)getMsgMoneyToNumble{
    NSData *msg=[[NSUserDefaults standardUserDefaults] objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:msg];
    if (userInfoModel.key.length==0|| [userInfoModel.key isEqualToString:@""]) {
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getMsgMoneyWithKey:userInfoModel.key digest:hmacString resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                 int code=[[dic objectForKey:@"code"] intValue];
                if (!dic){
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if(code == 1000){
                     NSDictionary *data=[dic objectForKey:@"data" ];
                    _balance = [data[@"balance"] floatValue];
                    _sm_amount = [data[@"sm_amount"] intValue];
                    _free_amount = [data[@"free_amount"] intValue];
                    [self setSendMsgNub];
                }
            });
        }];
    });
}

#pragma mark ----------发送短信接口----------
-(void)sendMsgRegistWithPhone{
    
    NSString *a = _phoneTextView.text;
    NSArray *b = [a componentsSeparatedByString:@","];
    for (NSString *phone in b) {
        if (![[communcat sharedInstance] checkTel:phone]&&phone.length>0) {
            [[KNToast alloc]initWithText:@"请检查您输入的手机号是否正确" offSetY:0];
            return;
        }
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",_phoneTextView.text],[NSString stringWithFormat:@"%@",_msgTextView.text],[NSString stringWithFormat:@"%d",_msg_count],[NSString stringWithFormat:@"%@",_smstemplateId],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    in_sendMsgModel *inModel=[[in_sendMsgModel alloc]init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.recipientMobile = [NSString stringWithFormat:@"%@",_phoneTextView.text];
    inModel.messagetext = [NSString stringWithFormat:@"%@",_msgTextView.text];
    inModel.countNum = [NSString stringWithFormat:@"%d",_msg_count];
    inModel.smstemplateId = [NSString stringWithFormat:@"%@",_smstemplateId];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] sendMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                 int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code == 1000){
                    self.backBtn.enabled=NO;
                    self.sendBtn.enabled=NO;
                    [self  getMsgMoneyToNumble];
                
                    //1.数组清空   2.textView要清空 3.成功是跳转到短信历史界面
                    NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
                    NSArray *data = dic[@"data"][@"result"];
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                 
                    for(NSDictionary *phoneDicTmp in data){
                        NSString *send;
                        
                        if ([phoneDicTmp[@"code"] intValue] == 0){
                            [array addObject:phoneDicTmp];
                            send=@"1";
                        }else{
                            send=@"0";
                        }
                        [self saveMsgToCoreDate:phoneDicTmp[@"mobile"] userPhone:userPhone status:send];
                        [self saveChatDetailMsgToCoreDate:phoneDicTmp[@"mobile"] userPhone:userPhone status:send];
                    }
                    
                    NSString *count = dic[@"data"][@"remaind_sms_count"];
                    NSString *money = dic[@"data"][@"take_money"];
                    if (array.count > _free_amount &&_free_amount
                        != 0) {
                        [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"短信发送成功，免费额度已为0，并另扣费%.2f元",[money floatValue]] duration:3 offSetY:0];
                        
                    }else if(_free_amount == 0){
                        [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"短信发送成功，本次费用%.2f元",[money floatValue]] duration:3 offSetY:0];
                        
                    }else if (array.count < _free_amount){
                        
                        [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"短信发送成功，还有%d条免费短信",[count intValue]] duration:3 offSetY:0];
                        
                    }else if (array.count == _free_amount){
                        [[KNToast shareToast] initWithText:[NSString stringWithFormat:@"短信发送成功，免费短信额度为0条"] duration:3 offSetY:0];
                    }
                    
                    [self performSelector:@selector(jump) withObject:nil afterDelay:3];
                }else{
                     [[KNToast alloc] initWithText:[dic objectForKey:@"message"] offSetY:0];
                }
            });
        }];
    });
}
#pragma mark =======界面跳转=====
-(void)jump{

    //[self leftItemClick];
}

#pragma mark 短信列表的数据库更新
-(void)saveMsgToCoreDate:(NSString *)phone userPhone:(NSString *)userPhone status:(NSString *)isSend{
    ListDetails *chat=[[ListDetails alloc]init];
    chat.recipient_mobile=userPhone;
    chat.phone=phone;
    chat.isSend=isSend;
    //  chat.recipient_mobile=phone;
    chat.msgText=self.msgTextView.text;
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000.0;
    chat.time=[NSString stringWithFormat:@"%f",interval];
    NSArray *coreDataTmp = [[coreDataManger shareinstance]lookCoreData];
    NSMutableArray *coredataAry=[NSMutableArray arrayWithCapacity:0];
    [coredataAry addObjectsFromArray:coreDataTmp];
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *timeAry=[NSMutableArray arrayWithCapacity:0];
    if (coredataAry.count==0) {
        [[coreDataManger shareinstance]insertCoreDataObjectWithOrder:chat];
        [tmpAry addObject:chat];
    }else{
        
        for (ListDetails *chatTmp in coredataAry) {
            if ([chatTmp.recipient_mobile isEqualToString:userPhone]) {
                [timeAry addObject:[NSString stringWithFormat:@"%@",chatTmp.phone]];
            }
        }
        if (![timeAry containsObject:[NSString stringWithFormat:@"%@",chat.phone]]) {
            [[coreDataManger shareinstance]insertCoreDataObjectWithOrder:chat];
            [tmpAry addObject:chat];
        }
        else{
            if ([userPhone isEqualToString:chat.recipient_mobile]){
                [[coreDataManger shareinstance]changeCoreDataMsg:chat.phone kind:@"msgText" changeText:self.msgTextView.text isSend:isSend];
                [[coreDataManger shareinstance]changeCoreDataMsg:chat.phone kind:@"time" changeText:chat.time isSend:isSend];
                
            }
            else
            {
                
            }
            
        }
    }
}

#pragma mark 短信详情的数据库更新
-(void)saveChatDetailMsgToCoreDate:(NSString *)phone userPhone:(NSString *)userPhone status:(NSString *)isSend{
    chatDetail *chat=[[chatDetail alloc]init];
    chat.recipient_mobile=userPhone;
    chat.moble=phone;
    chat.phoneID=userPhone;
    chat.isSend=isSend;
    chat.msgText=self.msgTextView.text;
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000.0;
    chat.time=[NSString stringWithFormat:@"%f",interval];
    NSArray *coreDataTmp = [[coreDataManger shareinstance]lookChatDetailCoreData];
    NSMutableArray *coredataAry=[NSMutableArray arrayWithCapacity:0];
    [coredataAry addObjectsFromArray:coreDataTmp];
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *timeAry=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *phoneAry=[NSMutableArray arrayWithCapacity:0];
    if (coredataAry.count==0) {
        [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
        [tmpAry addObject:chat];
    }else{
        for (chatDetail *chatTmp in coredataAry) {
            [timeAry addObject:[NSString stringWithFormat:@"%@",chatTmp.time]];
            [phoneAry addObject:chatTmp.phoneID];
        }
        
        if ( [timeAry containsObject:[NSString stringWithFormat:@"%@",chat.time]] && [phoneAry containsObject:chat.phoneID])
        {
            
        }
        else{
            [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
            [tmpAry addObject:chat];
        }
    }
}

#pragma mark----------选择短信模板
- (IBAction)selectMsgModel:(id)sender {
    MsgModelController *msgVc = [[MsgModelController alloc] init];
    msgVc.selectSubject = [RACSubject subject];
    [msgVc.selectSubject subscribeNext:^(id x) {
        _msgTextView.text = x[@"content"];
         _smstemplateId=x[@"smstemplateId"];
        _msgLabel.hidden = YES;
        _msgTextView.textColor = [UIColor blackColor];
    }];
   
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:msgVc animated:YES];
}


@end
