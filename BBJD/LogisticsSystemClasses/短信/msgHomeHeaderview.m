//
//  msgHomeHeaderview.m
//  BBJD
//
//  Created by cbwl on 16/12/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "msgHomeHeaderview.h"
#import "publicResource.h"
@implementation msgHomeHeaderview
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    self.backgroundColor=[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1.0];
    if ( self) {
        if (!_viewBg ){
            _viewBg=[[UIView alloc]init];
            _viewBg.backgroundColor=[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1.0];
            [self addSubview:_viewBg];
        }
        
        if (!_searchBr) {
            _searchBr=[[UISearchBar alloc]init];
            _searchBr.placeholder=@"搜索";
            //_searchBr.backgroundColor=[UIColor cle];
            _searchBr.backgroundImage=[[communcat sharedInstance ]createImageWithColor:[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1.0]];
            _searchBr.showsCancelButton=NO;
            [_viewBg addSubview: _searchBr];
            
            
        }
        if (!_allBtn) {
            _allBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_allBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
            _allBtn.selected=YES;
            [_allBtn setTitle:@"全部短信" forState:UIControlStateNormal];
            _allBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [_allBtn addTarget:self action:@selector(getAllMagBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_allBtn];
        }
        if (!_failBtn) {
            _failBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_failBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_failBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
            
            [_failBtn setTitle:@"发送失败" forState:UIControlStateNormal];
            _failBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [_failBtn addTarget:self action:@selector(getfailMagBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_failBtn];
        }
        if (!_line ){
            _line=[[UILabel alloc]init];
            _line.backgroundColor=LineColor;
            [self addSubview:_line];
        }
        if (!_bottomLine ){
            _bottomLine=[[UILabel alloc]init];
            _bottomLine.backgroundColor=MAINCOLOR;
            [self addSubview:_bottomLine];
        }
        _viewBg.sd_layout.leftSpaceToView(self,0)
        .topSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(46);
        
        _searchBr.sd_layout.leftSpaceToView(_viewBg,20)
        .topSpaceToView(_viewBg,10)
        .rightSpaceToView(_viewBg,20)
        .bottomSpaceToView(_viewBg,10);
        
        _allBtn.sd_layout.leftSpaceToView(self,33)
        .topSpaceToView(_viewBg, 4)
        .bottomSpaceToView(self, 3)
        .widthIs((SCREEN_WIDTH-66-80)/2);
        _line.sd_layout.leftSpaceToView(_allBtn,40)
        .topSpaceToView(_viewBg,5)
        .bottomSpaceToView(self,5)
        .widthIs(1.5);
        
        _failBtn.sd_layout.leftSpaceToView(_line,40)
        .topSpaceToView(_viewBg, 4)
        .bottomSpaceToView(self, 3)
        .widthIs((SCREEN_WIDTH-66-80)/2);
        
        //_bottomLine.sd_layout.centerXEqualToView(_allBtn)
        //  .bottomSpaceToView(self,0)
        ///   .heightIs(2)
        // .widthIs((SCREEN_WIDTH-66-80)/2);
        _bottomLine.frame=CGRectMake(33, frame.size.height-2, (SCREEN_WIDTH-66-80)/2, 2);
        
    }
    return self;
}
-(void)getfailMagBtnCLick:(UIButton *)btn{
    
    if (_failBtn.isSelected==YES) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _bottomLine.frame=CGRectMake((SCREEN_WIDTH-66-80)/2+120, self.frame.size.height-2, (SCREEN_WIDTH-66-80)/2, 2);
    }];
    
    
    
    _failBtn.selected=YES;
    _allBtn.selected=NO;
    [self.delegate failBtnCLickWithBtn:btn];
}
-(void)getAllMagBtnCLick:(UIButton *)btn{
    if (_allBtn.isSelected==YES) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        
        _bottomLine.frame=CGRectMake(33, self.frame.size.height-2, (SCREEN_WIDTH-66-80)/2, 2);
        
        
        
    }];
    _failBtn.selected=NO;
    _allBtn.selected=YES;
    if ([self.delegate respondsToSelector:@selector(allBtnCLickWithBtn:)]) {
        [self.delegate allBtnCLickWithBtn:btn];
        
    }
}


@end
