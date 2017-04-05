//
//  historyAndMoneyTableViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "historyAndMoneyTableViewCell.h"

@implementation historyAndMoneyTableViewCell
//历史订单
+ (instancetype)historyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
{
    
    NSString *identifier = @"history";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell

    
       historyAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"historyAndMoneyTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(void)historySetModel:(Out_historyOrderBody *)model;
{
    self.money.text=[NSString stringWithFormat:@"%@元",model.income];
    self.orderId.text=model.order_id;
   
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"配送成功";
        self.status.textColor=[UIColor grayColor];
        
    }else if([model.status isEqualToString:@"2"]){
        self.status.text = @"配送异常";
        self.status.textColor=[UIColor redColor];
    }
}

//账单
+ (instancetype)billTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
{
    NSString *identifier = @"bill";//对应xib中设置的identifier
    NSInteger index = 1; //xib中第几个Cell
    
    historyAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"historyAndMoneyTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)billSetModel:(Out_billStreamBody *)model;
{
    self.year.text=[model.trade_time substringWithRange:NSMakeRange(0, 10)];
    
    self.hour.text=[model.trade_time substringWithRange:NSMakeRange(11, 5)];
  
    if ([[model.trade_amount substringToIndex:2] isEqualToString:@"--"]) {
       self.billMoney.text=[NSString stringWithFormat:@"%@元",[model.trade_amount substringFromIndex:1]];
    }else{
    self.billMoney.text=[NSString stringWithFormat:@"%@元",model.trade_amount];
    }
    self.billStatus.text = model.trade_desc;
}

-(void)balanceSheetSetModel:(Out_billStreamBody *)model;
{
    self.Byear.text= model.trade_time ;
    
    self.BorderId.text= model.trade_no ;
    
    if ([[model.trade_amount substringToIndex:2] isEqualToString:@"--"]) {
        self.Bmoney.text=[NSString stringWithFormat:@"¥%@元",[model.trade_amount substringFromIndex:1]];
    }else{
        self.Bmoney.text=[NSString stringWithFormat:@"¥%@元",model.trade_amount];
    }
    if ([model.status containsString:@"1"]){
        self.Bstatus.textColor=[UIColor greenColor];
        self.Bstatus.text=@"成功";
    }
    else{
        self.Bstatus.text=@"失败";
        self.Bstatus.textColor=[UIColor redColor];

    }
    self.billStatus.text = model.trade_desc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
