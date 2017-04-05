//
//  UIBarButtonItem+CBELExtension.m
//  CYZhongBao
//

//  Copyright © 2016年 xc. All rights reserved.
//

#import "UIBarButtonItem+CBELExtension.h"
#import "UIView+extension.h"
@implementation UIBarButtonItem (CBELExtension)
//+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
//{
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
//    [button setTitle:image forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:18];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    return [[self alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    
//}

+ (instancetype)itemWithImage:(NSString *)image  target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [button setTitle:image forState:UIControlStateNormal];

    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


@end
