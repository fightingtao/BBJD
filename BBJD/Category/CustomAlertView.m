//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 李志明 on 16/9/20.
//  Copyright © 2016年 李志明. All rights reserved.
//

#import "CustomAlertView.h"
#import "publicResource.h"
#define MainScreenRect [UIScreen mainScreen].bounds
@interface CustomAlertView()
@property (nonatomic,strong)UIWindow *alertWindow;
@property (nonatomic,strong)UIView *alertView;

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *otherBtn;
@property (nonatomic,strong)UIButton *otherBtn1;
@end

@implementation CustomAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(LXAlertClickIndexBlock)block{
    self = [super init];
    if (self) {
        self.frame = MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        _alertView = [[UIView alloc] init];
        if (![title isEqualToString:@""]) {
            _alertView.frame = CGRectMake(30, (SCREEN_HEIGHT-300)/2, self.frame.size.width-60, 200);
        }else{
            _alertView.frame = CGRectMake(30,(SCREEN_HEIGHT-250)/2, self.frame.size.width-60, 120);
        }
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius = 6.0;
        _alertView.layer.masksToBounds = YES;
        _alertView.userInteractionEnabled = YES;

        [self addSubview:_alertView];
        
        if (title) {
            _titleLab =[[UILabel alloc] init];
            _titleLab.text = title;
            _titleLab.textColor=[UIColor blackColor];
            _titleLab.font = [UIFont systemFontOfSize:15];
            _titleLab.textAlignment = 1;
            _titleLab.numberOfLines = 0;
             [_titleLab sizeToFit];
            //计算titl的高度
            _titleLab.frame = CGRectMake(30, 30, _alertView.frame.size.width-60, 80);
            [_alertView addSubview:_titleLab];
        }
        
        if (cancelTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0]forState:UIControlStateNormal];
            _cancelBtn.backgroundColor = [UIColor whiteColor];
            _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            _cancelBtn.layer.cornerRadius = 5;
            _cancelBtn.layer.masksToBounds=YES;
            _cancelBtn.layer.borderWidth = 1;
            _cancelBtn.layer.borderColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0].CGColor;
            
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_cancelBtn];
        }
        
        if (otherBtnTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            _otherBtn.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            _otherBtn.layer.cornerRadius = 5;
            _otherBtn.layer.masksToBounds=YES;
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }
        
        if (cancelTitle && !otherBtnTitle) {
            _cancelBtn.tag = 100;
           _cancelBtn.frame = CGRectMake((_alertView.width-100)/2,_titleLab.y+_titleLab.height+10 , 100, 44);
            
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag = 100;
            _otherBtn.frame = CGRectMake((_alertView.width-100)/2,_titleLab.y+_titleLab.height+10 , 100, 44);
            
        }else if (cancelTitle && otherBtnTitle){
            _cancelBtn.tag = 100;
            _otherBtn.tag = 200;
            if (![_titleLab.text isEqualToString:@""] || _titleLab.text.length != 0) {
                _cancelBtn.frame = CGRectMake(20, _titleLab.y+_titleLab.height+10, (_alertView.width-60)/2, 40);
                
                _otherBtn.frame = CGRectMake(_cancelBtn.x +_cancelBtn.width +20, _titleLab.y+_titleLab.height+10, (_alertView.width-60)/2, 40);
            }
            else
            {
                _cancelBtn.frame = CGRectMake(20, (_alertView.height-40)/2, (_alertView.width-60)/2, 40);
                
                _otherBtn.frame = CGRectMake(_cancelBtn.x +_cancelBtn.width +20, (_alertView.height-40)/2, (_alertView.width-60)/2, 40);
            }
        }
        self.clickBlock = block;
    }
    return self;
}

//三个按钮
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle
              otherBtn1Title:(NSString *)otherBtn1Title         clickIndexBlock:(LXAlertClickIndexBlock)block{
    self = [super init];
    if (self) {
        self.frame = MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        _alertView = [[UIView alloc] init];
        if (![title isEqualToString:@""]) {
            _alertView.frame = CGRectMake(30, (SCREEN_HEIGHT-200)/2, self.frame.size.width-60, 200);
        }else{
            _alertView.frame = CGRectMake(30,(SCREEN_HEIGHT-120)/2, self.frame.size.width-60, 120);
        }
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius = 6.0;
        _alertView.layer.masksToBounds = YES;
        _alertView.userInteractionEnabled = YES;
        
        [self addSubview:_alertView];
        
        if (title) {
            _titleLab =[[UILabel alloc] init];
            _titleLab.text = title;
            _titleLab.textColor=[UIColor blackColor];
            _titleLab.font = [UIFont systemFontOfSize:15];
            _titleLab.textAlignment = 1;
            _titleLab.numberOfLines = 0;
            [_titleLab sizeToFit];
            //计算titl的高度
            _titleLab.frame = CGRectMake(30, 30, _alertView.frame.size.width-60, 80);
            [_alertView addSubview:_titleLab];
        }
        
        if (cancelTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0]forState:UIControlStateNormal];
            _cancelBtn.backgroundColor = [UIColor whiteColor];
            _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            _cancelBtn.layer.cornerRadius = 5;
            _cancelBtn.layer.masksToBounds=YES;
            _cancelBtn.layer.borderWidth = 1;
            _cancelBtn.layer.borderColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0].CGColor;
            
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            _cancelBtn.tag = 100;
            [_alertView addSubview:_cancelBtn];
        }
        
        if (otherBtnTitle) {
            _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0]forState:UIControlStateNormal];
            _otherBtn.backgroundColor = [UIColor whiteColor];
            _otherBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            _otherBtn.layer.cornerRadius = 5;
            _otherBtn.layer.masksToBounds=YES;
            _otherBtn.layer.borderWidth = 1;
            _otherBtn.layer.borderColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0].CGColor;
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            _otherBtn.tag = 200;
            [_alertView addSubview:_otherBtn];
        }
        
        if (otherBtn1Title) {
            _otherBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
            _otherBtn1.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
            [_otherBtn1 setTitle:otherBtn1Title forState:UIControlStateNormal];
            [_otherBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn1.titleLabel.font =[UIFont systemFontOfSize:15];
            _otherBtn1.layer.cornerRadius = 5;
            _otherBtn1.layer.masksToBounds=YES;
            [_otherBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            _otherBtn1.tag = 300;
            [_alertView addSubview:_otherBtn1];
        }
        
        if (cancelTitle && !otherBtnTitle) {
            _cancelBtn.tag = 100;
            _cancelBtn.frame = CGRectMake((_alertView.width-100)/2,_titleLab.y+_titleLab.height+10 , 100, 44);
            
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag = 100;
            _otherBtn.frame = CGRectMake((_alertView.width-100)/2,_titleLab.y+_titleLab.height+10 , 100, 44);
            
        }else if (cancelTitle && otherBtnTitle && otherBtn1Title){
            _cancelBtn.tag = 100;
            _otherBtn.tag = 200;
            if (![_titleLab.text isEqualToString:@""] || _titleLab.text.length != 0) {
                _cancelBtn.frame = CGRectMake(20, _titleLab.y+_titleLab.height+10, (_alertView.width-60)/2, 40);
                
                _otherBtn.frame = CGRectMake(_cancelBtn.x +_cancelBtn.width +20, _titleLab.y+_titleLab.height+10, (_alertView.width-60)/2, 40);
            }else{
                _cancelBtn.frame = CGRectMake(20, (_alertView.height-40)/2, (_alertView.width-80)/3, 40);
                
                _otherBtn.frame = CGRectMake(_cancelBtn.x +_cancelBtn.width +20, (_alertView.height-40)/2, (_alertView.width-80)/3, 40);
                
                _otherBtn1.frame = CGRectMake(_otherBtn.width+_otherBtn.x+20, (_alertView.height-40)/2,  (_alertView.width-80)/3, 40);
            }
        }
        self.clickBlock = block;
    }
    return self;
}

//按钮点击事件
-(void)btnClick:(UIButton *)btn{
    
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
}

-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss = dontDissmiss;
}

-(void)dismissAlertView{
    [self removeFromSuperview];
    [_alertWindow resignKeyWindow];
}

//显示View
-(void)showLXAlertView{
    
    _alertWindow =[[UIWindow alloc] initWithFrame:MainScreenRect];
    _alertWindow.windowLevel = UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    [_alertWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_alertWindow addGestureRecognizer:tap];
    
    [self setShowAnimation];
}
-(void)showLXAlertViewWhitViewController:(UIView *)viewC ;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [viewC addGestureRecognizer:tap];
//    viewC.backgroundColor=[UIColor redColor];
    [viewC addSubview:self];
    [self setShowAnimation];
}
-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self dismissAlertView];
}

//添加动画效果
-(void)setShowAnimation{
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_alertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_alertView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

@end
