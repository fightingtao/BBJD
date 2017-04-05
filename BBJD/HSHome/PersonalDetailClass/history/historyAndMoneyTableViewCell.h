//
//  historyAndMoneyTableViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@interface historyAndMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *billMoney;

@property (weak, nonatomic) IBOutlet UILabel *billStatus;

//___________流水cell_____
@property (weak, nonatomic) IBOutlet UILabel *Byear;

@property (weak, nonatomic) IBOutlet UILabel *BorderId;

@property (weak, nonatomic) IBOutlet UILabel *Bstatus;
@property (weak, nonatomic) IBOutlet UILabel *Bmoney;


-(void)historySetModel:(Out_historyOrderBody *)model;
-(void)billSetModel:(Out_billStreamBody *)model;

+ (instancetype)historyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;//1 历史订单 2账单

+ (instancetype)billTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
-(void)balanceSheetSetModel:(Out_billStreamBody *)model;//流水

@end
