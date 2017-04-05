//
//  homeHeaderView.m
//  CYZhongBao
//  Copyright © 2016年 xc. All rights reserved.
//

#import "homeHeaderView.h"
#import "publicResource.h"
@interface homeHeaderView()
@property(nonatomic,strong)UIImageView *headView;

@end
@implementation homeHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        self.headView.image = [UIImage imageNamed:@"banner.png"];
        [self addSubview:self.headView];
    }
    return self;
}
@end
