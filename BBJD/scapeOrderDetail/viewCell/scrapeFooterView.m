//
//  scrapeFooterView.m
//  BBJD
//
//  Created by cbwl on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "scrapeFooterView.h"
#import "publicResource.h"

@implementation scrapeFooterView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
    
        if (!_cancel) {
            _cancel=[UIButton buttonWithType:UIButtonTypeCustom ];
            _cancel.layer.cornerRadius=10;
            [_cancel.layer setMasksToBounds:YES];
            _cancel.titleLabel.font = MiddleFont ;

            [_cancel setBackgroundColor:MAINCOLOR];
            [_cancel addTarget:self action:@selector(onCanvleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancel];
        }
        if (!_goWork) {
            _goWork=[UIButton buttonWithType:UIButtonTypeCustom ];
            [_goWork setTitle:@"去扫描" forState:UIControlStateNormal];
            _goWork.layer.cornerRadius=10;
            [_goWork.layer setMasksToBounds:YES];
             _goWork.titleLabel.font = MiddleFont ;
            [_goWork setBackgroundColor:MAINCOLOR];
            [_goWork addTarget:self action:@selector(ongoWorkClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_goWork];
        }
        if (!_getOrder) {
            _getOrder=[UIButton buttonWithType:UIButtonTypeCustom ];
            [_getOrder setTitle:@"接单" forState:UIControlStateNormal];
            _getOrder.titleLabel.font = MiddleFont ;
            _getOrder.layer.cornerRadius=10;
            [_getOrder.layer setMasksToBounds:YES];
            
            [_getOrder setBackgroundColor:MAINCOLOR];
            [_getOrder addTarget:self action:@selector(ongetOrderClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_getOrder];
        }
        _cancel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(self,40)
        .widthIs(120)
        .heightIs(40)
        ;
        
        _goWork.sd_layout.leftSpaceToView(_cancel,15)
        .topSpaceToView(self,40)
        .heightIs(40)
        .rightSpaceToView(self,20);
        
        _getOrder.sd_layout.leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,40)
        .heightIs(40);
    }
    return self;
}

-(void)onCanvleClick:(UIButton *)btn
{
    if ([self.cancel.titleLabel.text isEqualToString:@"取消"]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(onCancelClick:)]) {
        [self.delegate onCancelClick:btn];
    }
}

-(void)ongoWorkClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(onGoWorkClick:)]) {
        [self.delegate onGoWorkClick:btn];
    }
}

-(void)ongetOrderClick:(UIButton *)btn
{
    [self.delegate onGetOrderClick:btn];
}

@end
