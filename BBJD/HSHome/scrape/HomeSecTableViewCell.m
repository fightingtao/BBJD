//
//  HomeSecTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "HomeSecTableViewCell.h"
#import "publicResource.h"
@implementation HomeSecTableViewCell

-(void)awakeFromNib{
      [super awakeFromNib];

}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapOrderBody *)GrapOrderBody{
    
    static NSString * cellName = @"secondCell";
    HomeSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeSecTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressLabel.text = GrapOrderBody.grid_name;
    cell.detailAddressLabel.text = GrapOrderBody.grid_address;
    cell.merchantLabel.text = GrapOrderBody.seller_name;
    cell.inComeLabel.text=[NSString stringWithFormat:@"%.2f元",[GrapOrderBody.delivery_count intValue] *[GrapOrderBody.per_oder_commission floatValue] ];
    cell.merchantLabel.text= GrapOrderBody.seller_name;
    cell.orderNumLabel.text = [NSString stringWithFormat:@"%.@单",GrapOrderBody.delivery_count];
    
    if([GrapOrderBody.requirment_type isEqualToString:@"1"]){
        cell.typeLabel.text = @"网点发单";
    }else{
        cell.typeLabel.text = @"网格发单";
    }
 
    cell.locationBtn.tag = (int)indexPath.section+100;
    cell.cancellBtn.tag = (int)indexPath.section+1000;
    cell.orderReceivingBtn.tag = [GrapOrderBody.requirment_id intValue];
    cell.WorkBtn.tag = indexPath.section;
    
    if ([GrapOrderBody.grab_status isEqualToString:@"0"]){//根据抢单状态判断按钮状态
        cell.orderReceivingBtn.hidden = NO;
        cell.cancellBtn.hidden = YES;
        cell.WorkBtn.hidden = YES;
        
    }else{
        cell.orderReceivingBtn.hidden = YES;
        cell.cancellBtn.hidden = NO;
        cell.WorkBtn.hidden = NO;
    }
    
   
    return cell;
}


- (IBAction)orderReceivingBtnClick:(UIButton *)sender {
    int num = (int)sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(orderReceivingBtn:)]) {
        
        [self.delegate  orderReceivingBtn:num] ;
    }
}

//取消按钮点击
- (IBAction)cancellBtnClick:(UIButton *)sender {
    int num = (int)sender.tag -1000;
    
    if ([self.cancellBtn.titleLabel.text isEqualToString:@"取消"]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(cancellBtn1Click:)]) {
        
        [self.delegate  cancellBtn1Click:num] ;
    }
}

//工作按钮点击
- (IBAction)workBtnclick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(workBtnClick:)]) {
        
        [self.delegate  workBtnClick:sender] ;
    }
}


//定位按钮点击
- (IBAction)locationBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(locationBtnClick:)]) {
        
        [self.delegate  locationBtnClick:sender] ;
    }
}

-(void)setModel:(Out_GrapOrderBody *)model{
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-105, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [model.grid_name boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
   self.addressLabel.frame = CGRectMake(20+self.song.width+10,self.song.y,SCREEN_WIDTH-105, textH+30);

    [self.addressLabel sizeToFit];
    CGFloat textH1 = [model.grid_address boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.detailAddressLabel.frame = CGRectMake(self.addressLabel.x, self.addressLabel.y+self.addressLabel.height+10, SCREEN_WIDTH-105, textH1);
    [self.detailAddressLabel sizeToFit];
   self.locationBtn.frame = CGRectMake(SCREEN_WIDTH-35,self.detailAddressLabel.y+self.detailAddressLabel.height-35+10,30,30);
    
   self.jia.frame = CGRectMake(20, self.detailAddressLabel.y+self.detailAddressLabel.height+10, 50, 20);
    self.merchantLabel.frame = CGRectMake(self.jia.x+self.jia.width+10, self.jia.y, SCREEN_WIDTH-105, 20);
    self.leixing.frame = CGRectMake(20, self.jia.y+30,50, 20);
    self.typeLabel.frame = CGRectMake(80, self.leixing.y, SCREEN_WIDTH-105, 20);
     self.cellHeight = 41+60+40+ textH +textH1+60;
}

@end
