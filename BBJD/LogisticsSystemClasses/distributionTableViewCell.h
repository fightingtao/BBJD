//
//  distributionTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@protocol distributionDelagate <NSObject>
//cell2:
-(void)telphoneBtnClick:(NSString*)tel;
-(void)reasonBtnClick:(UIButton*)btn;
-(void)signBtnClick:(UIButton*)btn;

//cell1
-(void)reasonBtn2Click:(UIButton*)btn;
-(void)signBtn2Click:(UIButton*)sign;

//cell3
-(void)telphoneBtnClick3:(NSString*)tel;
@end

@interface distributionTableViewCell : UITableViewCell
/*cell1*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *shangjiaLabel;//商家
@property (weak, nonatomic) IBOutlet UILabel *orderListLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;//收件人
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;//电话
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property(nonatomic,assign)CGFloat cellHeight1;//第一个

@property(nonatomic,weak)id<distributionDelagate>delegate;

/*cell2*/

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//地址

@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;//订单号
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;//异常按钮
@property (weak, nonatomic) IBOutlet UIButton *signButton;//签收按钮

//cell3
@property (weak, nonatomic) IBOutlet UILabel *time3Label;
@property (weak, nonatomic) IBOutlet UILabel *adress3Label;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber3Label;

@property (weak, nonatomic) IBOutlet UILabel *shoujian3Label;
@property (weak, nonatomic) IBOutlet UILabel *shoujianLabel3;

@property (weak, nonatomic) IBOutlet UILabel *show3;

@property(nonatomic,assign)CGFloat cellHeight2;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model;


@property (weak, nonatomic) IBOutlet UIButton *phone3Label;

+ (instancetype)alreadyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model;

//cell4
@property (weak, nonatomic) IBOutlet UILabel *timeLabel4;
@property (weak, nonatomic) IBOutlet UILabel *shangjiaLabel4;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel4;

//cell5
@property (weak, nonatomic) IBOutlet UILabel *timeLabel5;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel5;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel5;

+ (instancetype)alreadyTableViewDetialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_detialListBody *)model
;


@end
