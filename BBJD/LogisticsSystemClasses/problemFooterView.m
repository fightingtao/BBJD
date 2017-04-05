//
//  problemFooterView.m
//  BBJD
//
//  Created by 李志明 on 16/10/17.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "problemFooterView.h"

@implementation problemFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _proLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
        _proLabel.textColor = [UIColor redColor];
        _proLabel.font = [UIFont systemFontOfSize:15];
        _proLabel.text = @"异常原因:";
        [self addSubview:_proLabel];
        _proInforLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
        _proInforLabel.textColor = [UIColor redColor];
        _proInforLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_proInforLabel];
    }
    
    return self;
}

@end
