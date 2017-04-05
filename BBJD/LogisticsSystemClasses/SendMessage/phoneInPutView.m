//
//  phoneInPutView.m
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "phoneInPutView.h"
#import "publicResource.h"
@implementation phoneInPutView
-(id)init{
    self=[super init];
    if (self) {
        if ( !_phone) {
            _phone=[UITextField new];
            _phone.frame=CGRectMake(20, 10, SCREEN_WIDTH-100, 30);
            _phone.layer.cornerRadius=5;
            _phone.layer.masksToBounds=YES;
            _phone.borderStyle=UITextBorderStyleNone;
            _phone.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
            _phone.placeholder=@"请输入手机号";
            [self addSubview:_phone];
        }
        if (!_voicebtn){
            _voicebtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_voicebtn setBackgroundImage:[UIImage imageNamed:@"btn_yuyin"] forState:UIControlStateNormal];
            [_voicebtn addTarget:self action:@selector(voicebtnclick:) forControlEvents:UIControlEventTouchUpInside];
            _voicebtn.frame=CGRectMake(SCREEN_WIDTH-60, 8, 35,30);
            [self addSubview:_voicebtn];
        }
        
        
    }
    return self;
}

-(void)voicebtnclick:(UIButton *)btn{
        if ([self.delegate respondsToSelector:@selector(voiceBtnClickWithBtn:)]) {
            [self.delegate voiceBtnClickWithBtn:btn] ;
        }
    }
    
    @end
