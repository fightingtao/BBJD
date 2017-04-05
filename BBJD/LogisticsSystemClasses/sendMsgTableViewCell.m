//
//  sendMsgTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 17/3/29.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "sendMsgTableViewCell.h"

@implementation sendMsgTableViewCell

+ (instancetype)sendMsgTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model{
    static NSString *msgCell = @"msgCell";
    
    
    sendMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"sendMsgTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.orderLabel.text = model.order_original_id;
    cell.adressLabel.text = model.consignee_address;
    cell.receiveLabel.text = model.consignee_name;
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-140, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [cell.adressLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    cell.adressLabel.frame =CGRectMake(cell.dingwei.x+cell.dingwei.width,cell.dingwei.y,SCREEN_WIDTH-140,textH);
    [cell.adressLabel sizeToFit];
    
    cell.shoujianren.frame = CGRectMake(cell.dingwei.x,cell.adressLabel.y+cell.adressLabel.height+5, 80, 20);
    cell.receiveLabel.frame = CGRectMake(cell.shoujianren.x+80, cell.shoujianren.y, SCREEN_WIDTH, 20);
    cell.height = cell.receiveLabel.y+cell.receiveLabel.height+20;
    [[cell.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        cell.selectBtn.selected = !cell.selectBtn.selected;
        NSString *result;
        if (cell.selectBtn.selected) {
            result = @"1";
        }else{
             result = @"0";
        }
        [cell.subject sendNext:result];

    }];
  cell.selectBtn.selected = cell.isSelected;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)setModel:(Out_sendGoodsBody *)model{
    self.orderLabel.text = model.order_original_id;
    self.adressLabel.text = model.consignee_address;
    self.receiveLabel.text = model.consignee_name;
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-140, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [self.adressLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    self.adressLabel.frame =CGRectMake(self.dingwei.x+self.dingwei.width,self.dingwei.y,SCREEN_WIDTH-140,textH);
    [self.adressLabel sizeToFit];
    
    self.shoujianren.frame = CGRectMake(self.dingwei.x,self.adressLabel.y+self.adressLabel.height+5,80, 20);
    self.receiveLabel.frame = CGRectMake(self.shoujianren.x+80, self.shoujianren.y, SCREEN_WIDTH, 20);
    self.height = self.receiveLabel.y+self.receiveLabel.height+10;
      self.selectBtn.selected=self.isSelected;
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.selectBtn.selected = !self.selectBtn.selected;
        NSString *result;
        if (self.selectBtn.selected) {
            result = @"1";
        }else{
            result = @"0";
        }
        [self.subject sendNext:result];
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
