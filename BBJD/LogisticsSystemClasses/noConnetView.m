//
//  noConnetView.m
//  BBJD
//
//  Created by cbwl on 16/8/31.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "noConnetView.h"
#import "publicResource.h"
@implementation noConnetView
-(id)initWithName:(NSString *)name{
    self=[super init];
    if (self) {
        
        if (!_imgbg) {
            _imgbg=[[UIImageView alloc]init];
            _imgbg.image=[UIImage imageNamed:name];
            _imgbg.frame=CGRectMake((SCREEN_WIDTH-120)/2, 40,120 , 100);
            [self addSubview:_imgbg];
        }
        if (!_label) {
            _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _imgbg.y+_imgbg.height, SCREEN_WIDTH, 30)];
            _label.textAlignment = 1;
            _label.textColor = [UIColor grayColor];
            _label.text = @"当前无订单，请稍候再来";
            [self addSubview:_label];
        }
    }
    return self;
}

@end
