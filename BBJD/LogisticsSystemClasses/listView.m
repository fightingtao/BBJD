//
//  listView.m
//  BBJD
//
//  Created by cbwl on 17/1/4.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "listView.h"
#import "publicResource.h"
@implementation listView
-(id)init{
    self=[super init];
    if (self) {
        self.backgroundColor = WHITECOLOR;
        if ( !_titleL) {
            _titleL=[[UILabel alloc]init];
            _titleL.textAlignment=NSTextAlignmentCenter;
            _titleL.font=[UIFont systemFontOfSize:18];
            _titleL.textColor=[UIColor blackColor];
            _titleL.text=@"资费说明:";
            [self addSubview:_titleL];
        }
        
        if (!_detail) {
            _detail=[[UILabel alloc]init];
            _detail.textAlignment=NSTextAlignmentLeft;
            _detail.font=[UIFont systemFontOfSize:15];
            _detail.textColor=[UIColor blackColor];
            [self addSubview:_detail];
        }
        if (!_close){
            _close=[UIButton buttonWithType:UIButtonTypeCustom];
            [_close setTitle:@"关闭" forState:UIControlStateNormal];
            _close.titleLabel.font=[UIFont systemFontOfSize:15];
            [_close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_close addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_close];
        }
        _close.sd_layout
        .topSpaceToView(self,10)
        .rightSpaceToView(self,0)
        .widthIs(55)
        .heightIs(20);

        
        _titleL.sd_layout.leftSpaceToView(self,0  )
        .topSpaceToView(self,15)
        .rightSpaceToView(self,0)
        .heightIs(23);
        
       
        _detail.sd_layout.leftSpaceToView(self,20  )
        .topSpaceToView(_titleL,10)
        .rightSpaceToView(self,20)
        //.bottomSpaceToView(self,20)
        .autoHeightRatio(0);

    }
    return self;
}

-(void)closeBtnClick{
    if ([self.delegate respondsToSelector:@selector(closeListBtnClick)]) {
        [self. delegate closeListBtnClick];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
