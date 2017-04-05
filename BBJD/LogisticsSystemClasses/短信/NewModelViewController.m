//
//  NewModelViewController.m
//  BBJD
//
//  Created by 李志明 on 17/2/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "NewModelViewController.h"
#import "publicResource.h"
#import "NewModelViewModel.h"
@interface NewModelViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UITextView *modelTextView;
@property(nonatomic,strong)NewModelViewModel *newModel;
@property(nonatomic,strong)UILabel *label;
@end

@implementation NewModelViewController

-(UILabel*)label{
    return HT_LAZY(_label, ({
        UILabel *remainderLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH-60, 80)];
        remainderLabel.text = @"发送短信时包含签名和个人手机号，无需重复填写。禁止包含广告、有害违法、淫秽色情或人身攻击等信息。";
        remainderLabel.numberOfLines = 0;
        remainderLabel.font = [UIFont systemFontOfSize:14];
        remainderLabel.textColor = TextPlaceholderCOLOR;
        remainderLabel;
    }));
}

-(NewModelViewModel*)newModel{
    return HT_LAZY(_newModel, ({
        NewModelViewModel *model = [[NewModelViewModel alloc] init];
        model;
    }));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"新增模板"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back.png" target:self action:@selector(newPopLeftBtnClick)];
    
    [self.modelTextView addSubview:self.label];
    self.modelTextView.delegate=self;
    [self setSendMsgNub];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark textViewDelegate  协议方法

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _label.hidden = YES;
    self.modelTextView.textColor= [UIColor blackColor];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>560){
        textView.text=[textView.text substringWithRange:NSMakeRange(0, 560)];
        [[KNToast shareToast] initWithText:@"短信字数不能超过560个字!" duration:1 offSetY:0];
    }
    int zheng ;
    int yu;
  
    if (textView.text.length<=70-25) {
        zheng=1;
    }else{
        zheng =((int)textView.text.length+25)/67 ;//取整
        yu =(textView.text.length+25)%67;//取余
        if (yu>0){
            zheng=zheng+1;
        }
    }
//    //已选择
    NSMutableAttributedString *stringSelect=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信长度 %ld 字，%d条",textView.text.length,zheng]];
    
    NSString *str1  = [NSString stringWithFormat:@"短信长度 %ld 字，%d条",textView.text.length,zheng];
    NSString *str2 = [NSString stringWithFormat:@"%ld",textView.text.length];
    NSRange range1 = [str1 rangeOfString:str2];
    [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,range1.length)];
    NSString *str3 = [NSString stringWithFormat:@"%d",zheng];
    NSRange range2 = [str1 rangeOfString:str3];
    [stringSelect addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range1.length+8,range2.length)];
    _wordLabel.attributedText = stringSelect;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_modelTextView.text.length==0) {
        _label.hidden = NO;
    }
}

-(void)setSendMsgNub{
    NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信长度 0 字，0条"]];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,1)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9,1)];
    _wordLabel.attributedText = string2;
}

- (IBAction)clearData:(id)sender {
    _modelTextView.text = nil;
    _label.hidden = NO;
    [self setSendMsgNub];
    [_modelTextView resignFirstResponder];
}

#pragma-----返回上一级---
-(void)newPopLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backTopClass:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma-----提交审核----
- (IBAction)goToAudit:(id)sender {
    if (_modelTextView.text.length == 0) {
        [[KNToast shareToast] initWithText:@"请先输入模板内容！"];
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",2],[NSString stringWithFormat:@"%@",_modelTextView.text],nil];
    [ZJCustomHud showWithStatus:@"加载中..."];
    RACSignal *signal=[self.newModel.checkCommand execute:array];
    [signal subscribeNext:^(id x) {
        if (![x isKindOfClass:[NSError class]]) {
            _modelTextView.text = nil;
            _label.hidden = NO;
            [self setSendMsgNub];
        }
        
    }];
}

@end
