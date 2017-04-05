//
//  MessageVController.m
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "MessageVController.h"
#import "msgHomeViewController.h"
#import "listView.h"//资费说明
#import "LoginViewController.h"
#import "ListDetails.h"//
#import "MsgModelController.h"
@interface MessageVController ()<UITextViewDelegate,ListCloseDelegate>
{
    float _balance;//钱包余额
    int _sm_amount;//短信额度
    int _free_amount;//免费短信
    UIView *_listBg;
    listView *_list ;
    int _msg_count;//已编辑短信条数

}
@property(nonatomic,strong)UILabel *label;
@end

@implementation MessageVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewBgColor;
    self.navigationItem.title = @"短信群发";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(leftItemClick)];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"短信历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 20);
    btn.titleLabel.font = kTextFont16;
    [btn addTarget:self action:@selector(rightItemItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH-60, 40)];
        _label.text = @"请编辑短信内容,默认包含签名【邦办即达】和您的手机号码。";
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = TextPlaceholderCOLOR;
        [self.textView addSubview:_label];
    }

    _textView.delegate=self;
    [self getMsgMoneyToNumble];
    [self createMoneyList];
    _smstemplateId=@"0";

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self calculateTextLength:_textView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)leftItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 短信历史
-(void)rightItemItemClick{
    if (self.status == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    msgHomeViewController *history=[[msgHomeViewController alloc]init];
    history.frome = 2;
    [self.navigationController pushViewController:history animated:YES];
    }
}

#pragma mark textViewDelegate  协议方法

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _label.hidden = YES;
    _textView.textColor= [UIColor blackColor];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>560){
        textView.text=[textView.text substringWithRange:NSMakeRange(0, 560)];

    }
    [self calculateTextLength:textView];
}

-(void)calculateTextLength:(UITextView *)textView{
  
    
    if (self.status == 1) {
        int zheng ;
        int yu;
        NSArray *array = [self.phoneList componentsSeparatedByString:@","];
        
        NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信长度 %ld 个字",textView.text.length]];
        NSString *str1= [NSString stringWithFormat:@"短信长度 %ld 个字",textView.text.length];
        NSString *str2= [NSString stringWithFormat:@"%ld",textView.text.length];
        NSRange range = [str1 rangeOfString:str2];
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, range.length)];
        _msgLength.attributedText = string1;
        
        if (textView.text.length<=70-25) {
            zheng=1;
        }
        else{
            zheng =((int)textView.text.length+25)/67 ;//取整
            yu =(textView.text.length+25)%67;//取余
            
            if (yu>0){
                zheng=zheng+1;
                
            }
            
        }
        _msg_count=zheng*((int)array.count );
        //已选择
        NSMutableAttributedString *stringSelect=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",array.count, _msg_count ]];
        NSString *strselect1  = [NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",array.count,_msg_count];
        int lengthstrSelect1=(int)[[NSString stringWithFormat:@"%lu",(unsigned long)self.showArray.count] length];
        lengthstrSelect1=2;
        [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, lengthstrSelect1)];
        int lengthstrSelect2=(int)[[NSString stringWithFormat:@"%d",_msg_count] length];
        
        [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(strselect1.length-2-lengthstrSelect2,lengthstrSelect2*2)];
        _select.attributedText = stringSelect;
        
    }else{
        int zheng ;
        int yu;
        NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信长度 %ld 个字",textView.text.length]];
        NSString *str1= [NSString stringWithFormat:@"短信长度 %ld 个字",textView.text.length];
        NSString *str2= [NSString stringWithFormat:@"%ld",textView.text.length];
        NSRange range = [str1 rangeOfString:str2];
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, range.length)];
        _msgLength.attributedText = string1;
        
        if (textView.text.length<=70-25) {
            zheng=1;
        }
        else{
            zheng =((int)textView.text.length+25)/67 ;//取整
            yu =(textView.text.length+25)%67;//取余
            
            if (yu>0){
                zheng=zheng+1;
                
            }
        }
        _msg_count=zheng*((int)self.showArray.count );
    //已选择
    NSMutableAttributedString *stringSelect=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",self.showArray.count, _msg_count ]];
    
    NSString *strselect1  = [NSString stringWithFormat:@"已选择 %ld 个手机号, %d 条",self.showArray.count,_msg_count];
    
    int lengthstrSelect1=(int)[[NSString stringWithFormat:@"%lu",(unsigned long)self.showArray.count] length];
   
    lengthstrSelect1=2;
    [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, lengthstrSelect1)];
    int lengthstrSelect2=(int)[[NSString stringWithFormat:@"%d",_msg_count] length];
    
    [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(strselect1.length-2-lengthstrSelect2,lengthstrSelect2*2)];
    _select.attributedText = stringSelect;
         }
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_textView.text.length==0) {
        _label.hidden = NO;
    }
}

#pragma mark  发送短信
- (IBAction)sengMsgClick:(id)sender {
    
    if (_textView.text.length >0) {
        if([_textView.text isEqualToString:@"请编辑短信内容,默认包含签名【邦办即达】和您的手机号码。"]){
            [[KNToast shareToast] initWithText:@"请输入短信内容!" duration:1 offSetY:0];
            return;
        }
        //发送短信条数、短信额度
        if (_msg_count > (_sm_amount + _free_amount)){
            [[KNToast shareToast] initWithText:@"您的短信额度不足,请进行充值!" duration:1 offSetY:0];
            return;
        }
       
        if (self.status == 1) {
            [self sendMsgRegistWithPhone:self.phoneList];
        }else{
            [self sendMsgRegistWithPhone:self.phone];
        }
        
    }else{
        [[KNToast shareToast] initWithText:@"请输入短信内容!" duration:1 offSetY:0];
    }
}

#pragma mark ----------发送短信接口-----
-(void)sendMsgRegistWithPhone:(NSString *)phone{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",phone],[NSString stringWithFormat:@"%@",_textView.text],[NSString stringWithFormat:@"%d",_msg_count],[NSString stringWithFormat:@"%@",_smstemplateId],nil];
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    in_sendMsgModel *inModel=[[in_sendMsgModel alloc]init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.recipientMobile = [NSString stringWithFormat:@"%@",phone];
    inModel.messagetext = [NSString stringWithFormat:@"%@",_textView.text];
    inModel.countNum = [NSString stringWithFormat:@"%d",_msg_count];
    inModel.smstemplateId = [NSString stringWithFormat:@"%@",_smstemplateId];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] sendMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }
                else if (code == 1000){
                    self.backBtn.enabled=NO;
                    self.sendBtn.enabled=NO;

                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.showArray,@"chengGong", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"delegate" object:nil userInfo:dict];
                    //1.数组清空   2.textView要清空 3.成功是跳转到短信历史界面
                    [self  getMsgMoneyToNumble];
                    
                    NSString *userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumble"];
                    NSArray *data=dic[@"data"][@"result"];
                    NSMutableArray *array = [[NSMutableArray alloc] init];

                    for(NSDictionary *phoneDicTmp in data){
                        NSString *send;
                        if ([phoneDicTmp[@"code"] intValue] == 0){
                            [array addObject:phoneDicTmp];
                            send=@"1";
                        }
                        else{
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
            
                    [self setSendMsgNub];
                    [self performSelector:@selector(jump) withObject:nil afterDelay:3];
                    
                }else{
                    
                    [[KNToast alloc]initWithText:[dic objectForKey:@"message"] offSetY:0];
                }
            });
        }];
    });
}

-(void)jump{
    [self.msgSubject sendNext:@1];
    self.backBtn.enabled=YES;
    self.sendBtn.enabled=YES;
    [self rightItemItemClick];
}

-(void)saveMsgToCoreDate:(NSString *)phone userPhone:(NSString *)userPhone status:(NSString *)isSend{
    ListDetails *chat=[[ListDetails alloc]init];
    chat.recipient_mobile=userPhone;
    chat.phone=phone;
    chat.isSend=isSend;
    chat.msgText=self.textView.text;
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
        }else{
            if ([chat.recipient_mobile isEqualToString:userPhone]) {

            [[coreDataManger shareinstance]changeCoreDataMsg:chat.phone kind:@"msgText" changeText:self.textView.text isSend:isSend];
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
    chat.msgText=self.textView.text;
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
    }
    else{
        for (chatDetail *chatTmp in coredataAry) {
            
            [timeAry addObject:[NSString stringWithFormat:@"%@",chatTmp.time]];
            [phoneAry addObject:chatTmp.phoneID];
        }
        
        if ( [timeAry containsObject:[NSString stringWithFormat:@"%@",chat.time]] && [phoneAry containsObject:chat.phoneID]) {
            
        }
        else{
            [[coreDataManger shareinstance]insertChatDetailCoreDataObjectWithOrder:chat];
            [tmpAry addObject:chat];
        }
    }
}


#pragma mark 取消发送  返回
- (IBAction)backBtnClick:(id)sender {
    if (_textView.text.length >0 ) {
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"返回所编辑的内容将不会被保存,是否继续？" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
            [self dismiss];
        }
    }];
    [alert showLXAlertView];
    }else{
        [self dismiss];
    }
}

-(void)dismiss{
    [self leftItemClick];
}

#pragma mark 资费说明
- (IBAction)moneyListBtnClick:(id)sender {
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
        _list.layer.cornerRadius = 3;
        _list.layer.masksToBounds = YES;
        
        _list.detail.text=@"1、达人首次认证成功后，可免费获得20条短信（仅限前3570名认证达人享受该项活动);\n2、本平台收取短信统一价0.04元/条;\n3、可支持短信群发及历史短信回顾内容功能;\n4、发送完成后费用将从您的达人可提现金额中扣款，请保证余额充足;\n5、活动最终解释权归<邦办即达>所有。";
        // 1.文字的最大尺寸
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
        //        cell.adressLabel.text  = @"hhahahha";
        // 2.计算文字的高度
        CGFloat textH = [_list.detail.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _list.frame=CGRectMake(20,(SCREEN_HEIGHT-textH-80)/2-64,SCREEN_WIDTH-40 ,textH + 80 );
        
        [_list sizeToFit];
        [self closeListBtnClick];
        [self.view addSubview:_list];
        
    }
}
#pragma mark  资费说明
-(void)closeListBtnClick;//close资费声明
{
    [UIView animateWithDuration:1.0 animations:^{
        _list.alpha=0;
        _list.hidden=YES;
        _listBg.hidden=YES;
    }];
    
}
#pragma mark 清空--按钮点击
- (IBAction)clearbtn:(id)sender {
    _textView.text = nil;
    _label.hidden = NO;
    [_textView resignFirstResponder];
    [self calculateTextLength:_textView];

}

#pragma mark 短信内容统计
-(void)setSendMsgNub{
    if (self.status == 1) {
        NSArray *array = [self.phoneList componentsSeparatedByString:@","];
        //短信长度
        NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:@"短信长度 0 个字"];
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 1)];
        _msgLength.attributedText=string1;
        
        //已选择
        NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %ld 个手机号, %ld 条",array.count,array.count]];
        NSString *str1= [NSString stringWithFormat:@"已选择 %ld 个手机号, %ld 条",array.count,array.count];
        NSString *str2= [NSString stringWithFormat:@"%ld",array.count];
        
        NSRange range = [str1 rangeOfString:str2];
        
        [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, range.length)];
        
        [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.length+11,range.length)];
        _select.attributedText = string2;
        
        //账号余额
        NSMutableAttributedString *string3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"账号余额: ¥%.2f ",_balance]];
        NSString *str3= [NSString stringWithFormat:@"账号余额: ¥%.2f",_balance];
        NSString *str4= [NSString stringWithFormat:@"%.2f",_balance];
        
        NSRange range3 = [str3 rangeOfString:str4];
        
        [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, range3.length+1)];
        [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(6, range3.length+1)];
        _money.attributedText = string3;
        
        //短信额度
        NSMutableAttributedString *string4 = nil;
        if (_sm_amount >=300) {
            string4 = nil;
            _msgNub.hidden=YES;
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
        _msgNub.attributedText=string4;
    }else{
    //短信长度
    NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:@"短信长度 0 个字"];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 1)];
    _msgLength.attributedText=string1;
    
    //已选择
    NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选择 %ld 个手机号, %ld 条",self.showArray.count,self.showArray.count]];
    NSString *str1= [NSString stringWithFormat:@"已选择 %ld 个手机号, %ld 条",self.showArray.count,self.showArray.count];
    NSString *str2= [NSString stringWithFormat:@"%ld",self.showArray.count];
    
    NSRange range = [str1 rangeOfString:str2];
    
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, range.length)];
    
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.length+11,range.length)];
    _select.attributedText = string2;
    
    //账号余额
    NSMutableAttributedString *string3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"账号余额: ¥%.2f ",_balance]];
    NSString *str3= [NSString stringWithFormat:@"账号余额: ¥%.2f",_balance];
    NSString *str4= [NSString stringWithFormat:@"%.2f",_balance];
    
    NSRange range3 = [str3 rangeOfString:str4];
    
    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, range3.length+1)];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(6, range3.length+1)];
    _money.attributedText = string3;
    
    //短信额度
    NSMutableAttributedString *string4 = nil;
    if (_sm_amount >=300) {
        string4 = nil;
        _msgNub.hidden=YES;
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
    _msgNub.attributedText=string4;
    }
    
}

#pragma mark 获取度短信余额
-(void)getMsgMoneyToNumble{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSString *hmac=[[communcat sharedInstance ] hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getMsgMoneyWithKey:userInfoModel.key digest:hmac resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                DLog(@"剩余短信和金钱%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[iToast makeText:@"网络不给力,请稍后重试!"] show];
                }else if (code == 1000){
                    NSDictionary *data=[dic objectForKey:@"data" ];
                    _balance = [data[@"balance"] floatValue];
                    _sm_amount = [data[@"sm_amount"] intValue];
                    _free_amount = [data[@"free_amount"] intValue];
                    [self setSendMsgNub];
                }else{
                    [[KNToast shareToast] initWithText:[dic objectForKey:@"message"] duration:1 offSetY:0];
                    if ([[dic objectForKey:@"message"] isEqualToString:@"请登陆"]){
                        LoginViewController *login = [[LoginViewController alloc] init];
                        self.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:login animated:YES];
                    }
                }
            });
        }];
    });
}
#pragma mark ---------选择短信模板--------
- (IBAction)selectMsgModel:(id)sender {
    MsgModelController *msgVc = [[MsgModelController alloc] init];
    msgVc.selectSubject = [RACSubject subject];
    [msgVc.selectSubject subscribeNext:^(id x) {
        _textView.text = x[@"content"];
        _smstemplateId=[NSString stringWithFormat:@"%d",[x[@"smstemplateId"] intValue]];
        _label.hidden = YES;
        _textView.textColor = [UIColor blackColor];
    }];
    

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
