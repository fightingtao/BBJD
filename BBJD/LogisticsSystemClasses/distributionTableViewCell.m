//
//  distributionTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "distributionTableViewCell.h"

@implementation distributionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
    
}



+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model
{
    static  NSString *identifier1 = @"identifier1";
    static  NSString *identifier2 = @"identy2";
    if ([model.consignee_address isEqualToString:@""] || (model.consignee_address.length == 0)) {
        
        distributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"distributionTableViewCell" owner:self options:nil] objectAtIndex:1];;
        }
        cell.signButton.tag = indexPath.section+100;
        cell.reasonButton.tag = indexPath.section;
    
        if ([[NSString stringWithFormat:@"%@",model.dssnname] length] == 0||!model.dssnname){
            cell.nameLabel.text =@"哎呀!没找到商家";
        }
        else{
            cell.nameLabel.text =[NSString stringWithFormat:@"%@",model.dssnname];
        }
        cell.hourLabel.text =model.linghuo_time;
        cell.listNumLabel.text = model.order_original_id;
        return cell;
        
    }else{

       distributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
             cell = [[[NSBundle mainBundle]loadNibNamed:@"distributionTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
            cell.shangjiaLabel.text =@"哎呀!没找到商家";
        }
        else{
            cell.shangjiaLabel.text =[NSString stringWithFormat:@"%@",model.dssnname];
        }
        
        cell.timeLabel.text = model.linghuo_time;
        cell.orderListLabel.text = model.order_original_id;
        cell.adressLabel.text = model.consignee_address;
        cell.receiveLabel.text = model.consignee_name;
        cell.telBtn.tag = [model.consignee_mobile integerValue];
        cell.signBtn.tag = indexPath.section + 10;
        cell.reasonBtn.tag = indexPath.section;
        
        // 1.文字的最大尺寸
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
//        cell.adressLabel.text  = @"hhahahha";
        // 2.计算文字的高度
        CGFloat textH = [cell.adressLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        cell.adressLabel.frame =CGRectMake(cell.orderListLabel.x, cell.orderListLabel.y+cell.orderListLabel.height+6,SCREEN_WIDTH-110,textH);
        [ cell.adressLabel sizeToFit];
        
        cell.receiveLabel.frame = CGRectMake(cell.adressLabel.x, cell.adressLabel.y+cell.adressLabel.height+5, SCREEN_WIDTH-120, 20);
        cell.showLabel.frame = CGRectMake(20, cell.receiveLabel.y, 65, 20);
        cell.telBtn.frame = CGRectMake(SCREEN_WIDTH-50, cell.receiveLabel.y-5, 30, 30);
        
        cell.reasonBtn.frame = CGRectMake(20, cell.receiveLabel.y+cell.receiveLabel.height+15,120, 35);
        cell.signBtn.frame = CGRectMake(cell.reasonBtn.x+cell.reasonBtn.width+20, cell.reasonBtn.y, SCREEN_WIDTH-60-120, 35);
        
        cell.cellHeight1 = cell.signBtn.y+35 +13;
        
        return cell;
    }
}




#pragma mark  原需求
//电话按钮点击
- (IBAction)telBtnClick:(UIButton *)sender {
    NSString *tel = [NSString stringWithFormat:@"%ld",sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(telphoneBtnClick:)]) {
        [self.delegate telphoneBtnClick:tel];
    }
}

//异常按钮点击
- (IBAction)reasonBtnClick:(UIButton *)sender {
   
    if ([self.delegate respondsToSelector:@selector(reasonBtnClick:)]) {
        [self.delegate reasonBtnClick:sender];
    }
}

//签收按钮点击
- (IBAction)siginBtnClick:(UIButton *)sender {
   
    if ([self.delegate respondsToSelector:@selector(signBtnClick:)]) {
        [self.delegate signBtnClick:sender];
    }
}



#pragma mark  --------网格发单------------
//异常按钮
- (IBAction)reasonButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reasonBtn2Click:)]) {
        [self.delegate reasonBtn2Click:(UIButton*)sender];
    }
}

//签收按钮点击
- (IBAction)signButtonClick:(UIButton *)sender {
  
    if ([self.delegate respondsToSelector:@selector(signBtn2Click:)]) {
        
        [self.delegate signBtn2Click:sender];
    }
}



+ (instancetype)alreadyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model{
    
    static NSString *identifier3 = @"identif3";
    static NSString *identifier4 = @"identif4";
    
    if ([model.consignee_address isEqualToString:@""] || (model.consignee_address.length == 0)) {
        distributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"distributionTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
            cell.shangjiaLabel4.text =@"哎呀!没找到商家";
        }
        else{
            cell.shangjiaLabel4.text =[NSString stringWithFormat:@"%@",model.dssnname];
        }
        cell.timeLabel4.text = [NSString stringWithFormat:@"%@",model.linghuo_time];
        cell.orderLabel4.text = [NSString stringWithFormat:@"%@",model.order_original_id];
        return cell;
        
    }else{
        
        distributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"distributionTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
            cell.adress3Label.text =@"哎呀!没找到商家";
        }
        else{
            cell.adress3Label.text =[NSString stringWithFormat:@"%@",model.dssnname];
        }
        
        cell.time3Label.text = [NSString stringWithFormat:@"%@",model.linghuo_time];
        cell.orderNumber3Label.text = [NSString stringWithFormat:@"%@",model.order_original_id];
        cell.shoujian3Label.text = [NSString stringWithFormat:@"%@",model.consignee_address];
        cell.shoujianLabel3.text = [NSString stringWithFormat:@"%@",model.consignee_name];
        cell.phone3Label.tag = [model.consignee_mobile integerValue];
        // 1.文字的最大尺寸
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
        // 2.计算文字的高度
        CGFloat textH = [cell.shoujian3Label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        cell.shoujian3Label.frame = CGRectMake(cell.orderNumber3Label.x, cell.orderNumber3Label.y+cell.orderNumber3Label.height+6, SCREEN_WIDTH-110, textH);
        [cell.shoujian3Label sizeToFit];
        
        cell.shoujianLabel3.frame = CGRectMake(cell.shoujian3Label.x, cell.shoujian3Label.y+cell.shoujian3Label.height+2, 150, 20);
        cell.show3.frame = CGRectMake(20, cell.shoujianLabel3.y, 80, 20);
        
        cell.phone3Label.frame = CGRectMake(SCREEN_WIDTH-50,cell.show3.y-5, 30, 30);
        
        cell.cellHeight2 = cell.phone3Label.y+30+10;
        return cell;
     }
}

+ (instancetype)alreadyTableViewDetialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_detialListBody *)model{
    static NSString *identifier5 = @"identif5";
    distributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier5];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"distributionTableViewCell" owner:self options:nil] objectAtIndex:4];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
        cell.adressLabel5.text =@"哎呀!没找到商家";
    }
    else{
        cell.adressLabel5.text =[NSString stringWithFormat:@"%@",model.dssnname];
    }
    cell.timeLabel5.text = [NSString stringWithFormat:@"%@",model.linghuo_time];
    cell.orderLabel5.text = [NSString stringWithFormat:@"%@",model.order_original_id];
    return cell;
    
}

- (IBAction)phone3BtnClick:(UIButton *)sender {
    NSString *tel = [NSString stringWithFormat:@"%ld",sender.tag];
    if ([self.delegate respondsToSelector:@selector(telphoneBtnClick3:)]) {
        [self.delegate telphoneBtnClick3:tel];
    }
}

@end
