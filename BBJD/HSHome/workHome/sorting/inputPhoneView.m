//
//  inputPhoneView.m
//  BBJD
//
//  Created by cbwl on 17/2/16.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "inputPhoneView.h"
#import "publicResource.h"
@implementation inputPhoneView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        if (!_phone) {
            _phone=[[UITextField alloc]initWithFrame:CGRectMake( 20, 10, SCREEN_WIDTH-120,30)];
            _phone.placeholder=@"请输入手机号";
            _phone.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
            _phone.keyboardType=UIKeyboardTypeNumberPad;
            _phone.layer.cornerRadius=5;
            _phone.layer.masksToBounds=YES;
            _phone.clearButtonMode=UITextFieldViewModeAlways;
            _phone.clearsOnBeginEditing=YES;
            [self addSubview:_phone];
        }
        
        if (!_voiceBtn) {
            _voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"btn_yuyin"] forState:UIControlStateNormal];
            _voiceBtn.frame=CGRectMake( SCREEN_WIDTH-60, 8, 32, 32);
            [_voiceBtn addTarget:self action:@selector(voicebtnclick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_voiceBtn];
        }
    }
    return self;
}

-(void)voicebtnclick:(UIButton *)btn{
    [self.delegate voiceBtnClickWithBtn:btn];
}
@end
