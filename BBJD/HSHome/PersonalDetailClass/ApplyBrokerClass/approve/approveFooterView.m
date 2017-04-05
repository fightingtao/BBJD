//
//  approveFooterView.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "approveFooterView.h"
#import "publicResource.h"
@implementation approveFooterView

-(id)init{
    self=[super init ];
    if (self) {
        if (!_List) {
            _List=[[UILabel alloc]init];
            _List.text=@"说明:提交代表您已同意";
            _List.textColor=kTextMainCOLOR;
            _List.font=LittleFont;
            [self addSubview:_List];
            
        }
        
        if (!_godelegate) {
            _godelegate=[UIButton buttonWithType:UIButtonTypeCustom];
            [_godelegate setTitle:@"《邦办达人协议》" forState:UIControlStateNormal];
            [_godelegate setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
            _godelegate.titleLabel.font=LittleFont;
            [_godelegate addTarget:self action:@selector(onDoDelegateBtnCLick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_godelegate];
            
        }

        if (!_commit) {
            _commit=[UIButton buttonWithType:UIButtonTypeCustom];
          
            [_commit setBackgroundImage:[UIImage imageNamed:@"btn提交认证.png"] forState:UIControlStateNormal];
            [_commit addTarget:self action:@selector(onCommitBtnCLick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_commit];
            
        }
        
        _List.sd_layout.leftSpaceToView(self,40)
        .heightIs(20)
        .topSpaceToView(self,20);
        [_List setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _godelegate.sd_layout.leftSpaceToView(_List,0)
        .heightIs(20)
        .widthIs(120)
        .topSpaceToView(self,20);
      
        _commit.sd_layout.centerXEqualToView(self)
        .heightIs(40)
        .widthIs(280)
        .topSpaceToView(_godelegate,10);
        
    }
    return self;
}
-(void)onDoDelegateBtnCLick{
    [self.delegat checkDelegateClick];
}
-(void)onCommitBtnCLick{
    [self.delegat onCommitBtnClick];
}
@end
