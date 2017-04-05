//
//  HomeSecTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communcat.h"
@protocol  orderReceivingBtnDelegate <NSObject>

-(void)orderReceivingBtn:(int)re_id;//抢单
-(void)cancellBtn1Click:(int)num;//取消
-(void)workBtnClick:(UIButton *)btn;//去工作
-(void)locationBtnClick:(UIButton *)btn;//定位按钮

@end

@interface HomeSecTableViewCell : UITableViewCell

//预计收入
@property (weak, nonatomic) IBOutlet UILabel *inComeLabel;
//接单量
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
//送货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//送货详细地址
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
//商家
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;
//类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//接单按钮
@property (weak, nonatomic) IBOutlet UIButton *orderReceivingBtn;
//定位按钮
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancellBtn;
@property (weak, nonatomic) IBOutlet UIButton *WorkBtn;
@property (weak, nonatomic) IBOutlet UILabel *song;

@property (weak, nonatomic) IBOutlet UILabel *jia;

@property (weak, nonatomic) IBOutlet UILabel *leixing;
@property(nonatomic,strong)Out_GrapOrderBody *model;

@property(nonatomic,assign)CGFloat cellHeight;

//接单按钮点击
@property(nonatomic,weak)id<orderReceivingBtnDelegate>delegate;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapOrderBody *)GrapOrderBody;

-(void)setModel:(Out_GrapOrderBody *)model;

@end
