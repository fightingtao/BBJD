//
//  navLabel.m
//  chuYan
//
//  Created by 李志明 on 16/12/17.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "navLabel.h"

@implementation navLabel

-(instancetype)initWithFrame:(CGRect)frame titile:(NSString*)title{
    self = [super init];
    self.frame = frame;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = title;
    [self addSubview:label];
    return self;
}
@end
