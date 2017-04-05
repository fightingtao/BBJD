//
//  HomeTableViewCell.h
//  CYZhongBao
//
//  Created by 李志明 on 16/8/24.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communcat.h"
#import "publicResource.h"
@protocol  GrabAsingleDelegate <NSObject>

-(void)GrabAsingle:(int)re_id;//接单
-(void)cancellBtnDlegate:(UIButton *)btn;//取消
-(void)workBtnDlegate:(UIButton *)btn;//工作
-(void)locationDlegate:(UIButton *)btn;//定位

@end

@protocol orderDetialDelegate <NSObject>
//订单详情
-(void)workButtonDlegate;//动作
-(void)locationButtonDlegate;//定位
-(void)telephoneButtonDlegate:(NSString*)tel;

@end

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//预计收入
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单量
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;//地址

@property (weak, nonatomic) IBOutlet UILabel *detailAdressLabel;//详细地址
@property (weak, nonatomic) IBOutlet UILabel *arriveLabel;//到站
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//配送距离
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *receivingBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancellBtn;
@property (weak, nonatomic) IBOutlet UIButton *workBtn;

@property(nonatomic,weak)id<GrabAsingleDelegate>delegate;
@property(nonatomic,weak)id<orderDetialDelegate>OrderDelegate;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapOrderBody *)GrapOrderBody;

//订单详情
@property (weak, nonatomic) IBOutlet UILabel *shouRuLabel;
@property (weak, nonatomic) IBOutlet UILabel *danLiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLabel;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (weak, nonatomic) IBOutlet UILabel *xiangXiLabel;

@property (weak, nonatomic) IBOutlet UIButton *weiZhiBtn;
@property (weak, nonatomic) IBOutlet UILabel *shiJianLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanWeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongJvLabel;

//@property (weak, nonatomic) IBOutlet UIButton *jieDanBtn;
//@property (weak, nonatomic) IBOutlet UIButton *quXiaoBtn;
//@property (weak, nonatomic) IBOutlet UIButton *gongZuoBtn;

+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapDetialListBody *)GrapOrderBody;

@end
