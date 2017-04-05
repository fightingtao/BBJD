//
//  MsgTableView.h
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgViewModel.h"
@interface MsgTableView : UIView
@property(nonatomic,strong)MsgViewModel *model;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)UILabel *showLabel;
@property(nonatomic,strong)UIButton *bottomBtn;
@property(nonatomic,strong)RACSubject *subject;
@end
