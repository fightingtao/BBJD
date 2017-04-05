//
//  HomeTableViewCell.m
//  CYZhongBao
//
//  Created by 李志明 on 16/8/24.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "HomeTableViewCell.h"
@implementation HomeTableViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapOrderBody *)GrapOrderBody{
    static NSString * cellName = @"cell1";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:nil options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
 
        cell.adressLabel.text=[NSString stringWithFormat:@"%@",GrapOrderBody.seller_name];
    if ([cell.adressLabel.text isEqualToString:@"(null)"]) {
        cell.adressLabel.text = @"";
    }
    cell.detailAdressLabel.text=GrapOrderBody.seller_address;
    cell.incomeLabel.text=[NSString stringWithFormat:@"%.2f元",[GrapOrderBody.delivery_count intValue] *[GrapOrderBody.per_oder_commission floatValue] ];
    
    if (GrapOrderBody.arrived_time.length > 0) {
        NSString *time = [GrapOrderBody.arrived_time  substringWithRange:NSMakeRange(11,5)];
        cell.arriveLabel.text = [NSString stringWithFormat:@"%@之前",time];
    }
    if([GrapOrderBody.vehicle isEqualToString:@""]){
        cell.gongJvLabel.text = @"不限";
    }else{
        cell.gongJvLabel.text = GrapOrderBody.vehicle;
    }
    cell.orderNumLabel.text = [NSString stringWithFormat:@"%@单", GrapOrderBody.delivery_count];
    
    cell.distanceLabel.text=[NSString stringWithFormat:@"%@公里",GrapOrderBody.delivery_distance ];
    cell.telBtn.tag = [GrapOrderBody.seller_mobile integerValue];
 
    cell.locationBtn.tag = (int)indexPath.section + 100;
    cell.receivingBtn.tag = (int)[GrapOrderBody.requirment_id intValue] ;
    cell.cancellBtn.tag = indexPath.section + 1000;
    cell.workBtn.tag = indexPath.section + 10000;
    
    if ([GrapOrderBody.grab_status isEqualToString:@"0"]){
        
        cell.receivingBtn.hidden = NO;
        cell.cancellBtn.hidden = YES;
        cell.workBtn.hidden = YES;
    }else{
        cell.receivingBtn.hidden = YES;
        cell.cancellBtn.hidden = NO;
        cell.workBtn.hidden = NO;
    }

    return cell;
}



//接单按钮点击
- (IBAction)RecrivingBtnClick:(UIButton *)sender {
    int num = (int)sender.tag;
    if ([self.delegate respondsToSelector:@selector(GrabAsingle:)]) {
        [self.delegate GrabAsingle:num];
    }
}

//取消按钮点击
- (IBAction)cancellBtnClickDelegate:(UIButton *)sender {
    
    if ([self.cancellBtn.titleLabel.text isEqualToString:@"取消"]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(cancellBtnDlegate:)]) {
        [self.delegate cancellBtnDlegate:sender];
    }
}

//去工作按钮点击
- (IBAction)workBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(workBtnDlegate:)]) {
        [self.delegate workBtnDlegate:sender];
    }
}

//定位按钮点击
- (IBAction)locationBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(locationDlegate:)]) {
        [self.delegate locationDlegate:sender];
    }
}

#pragma mark -----------订单详情--------------------
+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapDetialListBody *)GrapOrderBody{
    static NSString * cellName = @"cell2";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    cell.danLiangLabel.text = [NSString stringWithFormat:@"%@单", GrapOrderBody.order_amount];
    
     cell.shouRuLabel.text=[NSString stringWithFormat:@"%@元",GrapOrderBody.estimate_income];
    
    cell.dizhiLabel.text = [NSString stringWithFormat:@"%@",GrapOrderBody.seller_name];
    
    cell.xiangXiLabel.text = [ NSString stringWithFormat:@"%@", GrapOrderBody.seller_address];
    
    NSString *time = [GrapOrderBody.arrived_time  substringWithRange:NSMakeRange(11,5)];
    cell.shiJianLabel.text = [NSString stringWithFormat:@"%@之前",time];
    cell.fanWeiLabel.text = [NSString stringWithFormat:@"%@公里",GrapOrderBody.delivery_distance];
    if ([GrapOrderBody.vehicle isEqualToString:@""]|| (GrapOrderBody.vehicle.length == 0)){
        cell.gongJvLabel.text = @"不限";
    }else{
    cell.gongJvLabel.text = [NSString stringWithFormat:@"%@",GrapOrderBody.vehicle];
    }
    
    cell.telBtn.tag = [GrapOrderBody.seller_mobile integerValue];
 
    return cell;
}

- (IBAction)telBtnClick:(UIButton *)sender {
    NSString *tel = [NSString stringWithFormat:@"%ld",sender.tag];
    if ([self.OrderDelegate respondsToSelector:@selector(telephoneButtonDlegate:)]) {
        [self.OrderDelegate telephoneButtonDlegate:tel];
    }
}

- (IBAction)adressBtnclick:(UIButton *)sender{
    
    if ([self.OrderDelegate respondsToSelector:@selector (locationButtonDlegate)]) {
        [self.OrderDelegate locationButtonDlegate];
    }
}

@end
