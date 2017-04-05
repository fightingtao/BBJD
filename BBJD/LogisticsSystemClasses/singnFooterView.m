//
//  singnFooterView.m
//  BBJD
//
//  Created by 李志明 on 16/10/18.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "singnFooterView.h"
#import "publicResource.h"
@implementation singnFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, 1)];
        _topView.backgroundColor = [UIColor grayColor];
        _topView.alpha = 0.1;
        [self addSubview:_topView];
        
        
        _signLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 35)];
        _signLable.textAlignment = NSTextAlignmentLeft ;
        _signLable.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_signLable];
        
        
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0,_signLable.y +_signLable.height +5 , SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.1;
        [self addSubview:_lineView];
        
        
        
        _signTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, _signLable.y +_signLable.height +10, SCREEN_WIDTH-40, 35)];
        _signTimeLable.textAlignment = NSTextAlignmentLeft ;
        _signTimeLable.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_signTimeLable];
        
        
    }
    
    return self;
}



@end
