//
//  websiteTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/10/10.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "websiteTableViewCell.h"
#import "publicResource.h"
@implementation websiteTableViewCell


- (IBAction)reasonBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(problemBtnDelegate)]) {
        [self.delegate problemBtnDelegate];
    }
}


- (IBAction)siginBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(signBtnDelegate)]) {
        [self.delegate signBtnDelegate];
    }
}


+ (instancetype)webTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model{
    
    static NSString *identify2 = @"identify2";
    websiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
    if (!cell) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"websiteTableViewCell" owner:self options:nil] lastObject];
    }
    if(model.next_delivery_time.length>0){
        NSString *time=[model.next_delivery_time substringWithRange:NSMakeRange(5, 5)];
        cell.problemLabel.text = [NSString stringWithFormat:@"%@ %@再次配送",model.expt_msg,time];
    }else{
        cell.problemLabel.text = [NSString stringWithFormat:@"%@",model.expt_msg];
    }
    cell.linghuoLabel.text = model.linghuo_time;
    if (model.consignee_address.length != 0 ) {
        cell.dizhiLabel.text = model.consignee_address;
    }else{
       cell.dizhiLabel.text = @"哎呀，未找到商家";
    }
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [cell.problemLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    cell.problemLabel.frame = CGRectMake(cell.yichang.x+cell.yichang.width,cell.yichang.y,SCREEN_WIDTH-130,textH);
    [cell.problemLabel sizeToFit];
    
    cell.shangjiaImg.frame = CGRectMake(20,cell.yichang.y+cell.problemLabel.height,20, 20);
    cell.dingdanhao.text = model.order_original_id;
    cell.dizhiLabel.frame = CGRectMake(55,cell.shangjiaImg.y +2,SCREEN_WIDTH-130, 20);
    cell.dingdanlabel.frame = CGRectMake(20, cell.shangjiaImg.y+25, 80, 20);
    cell.dingdanhao.frame = CGRectMake(cell.problemLabel.x, cell.dingdanlabel.y, SCREEN_WIDTH-130, 20);
    
    cell.cellHeight2 = cell.dingdanhao.y +30;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
