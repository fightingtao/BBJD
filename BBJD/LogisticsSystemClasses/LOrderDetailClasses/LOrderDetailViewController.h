//
//  LOrderDetailViewController.h
//  CYZhongBao
//
//  Created by xc on 16/1/26.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"


#import "UserInfoSaveModel.h"
@protocol backBtnClickDelegate <NSObject>

-(void)backBtnClick:(NSString*)status;
@end

@interface LOrderDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSString *order_id;//订单号

@property (nonatomic, assign)NSInteger  kindType;

@property(nonatomic,copy)NSString *status;

@property(nonatomic,weak)id <backBtnClickDelegate>delegate;
@end
