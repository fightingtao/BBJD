//
//  emptyView.m
//  BBJD
//
//  Created by cbwl on 17/2/16.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "emptyView.h"

@implementation emptyView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        if (!_img) {
            _img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 81, 104.5)];
            _img.image=[UIImage imageNamed:@"empty"];
            [self addSubview:_img];
        }
        if (!_lbl) {
            _lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 104.5, 81, 50)];
            _lbl.text=@"暂无数据";
            _lbl.textAlignment=NSTextAlignmentCenter;
            _lbl.textColor=[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
            _lbl.font=[UIFont systemFontOfSize:15];
            [self addSubview:_lbl];
        }
    }
    return self;
}

@end
