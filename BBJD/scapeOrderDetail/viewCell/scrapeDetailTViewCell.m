//
//  scrapeDetailTViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/10/14.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "scrapeDetailTViewCell.h"
#import "publicResource.h"
@implementation scrapeDetailTViewCell

+(instancetype)detialTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapDetialListBody *)GrapOrderBody{//2.网点发单
    if ([GrapOrderBody.requirment_type isEqualToString:@"1"]) {
        scrapeDetailTViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"scrapeDetailTViewCell" owner:self options:nil] lastObject];
        cell.incomeLabel2.text = [NSString stringWithFormat:@"%.2f元",[GrapOrderBody.estimate_income doubleValue]];
        
        cell.orderNumber2.text = [NSString stringWithFormat:@"%.@单",GrapOrderBody.order_amount];
        cell.gridDetail2.text = [NSString stringWithFormat:@"%@",GrapOrderBody.grid_address];
        cell.gridLabel1.text = [NSString stringWithFormat:@"%@",GrapOrderBody.grid_name];
        cell.sellerName.text = [NSString stringWithFormat:@"%@",GrapOrderBody.seller_name];
        cell.sellerAdress.text = [NSString stringWithFormat:@"%@",GrapOrderBody.seller_address];
        cell.gridType2.text = @"网点发单";
        cell.songBtn.tag = 100;
        cell.telPhone.tag = [GrapOrderBody.seller_mobile integerValue];
        cell.shangjiaBtn.tag = 101;

        return cell;
    }
    //1.网格发单
     scrapeDetailTViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"scrapeDetailTViewCell" owner:self options:nil] firstObject];
    cell.incomeLabel.text = [NSString stringWithFormat:@"%.2f元",[GrapOrderBody.estimate_income doubleValue]];
    cell.orderNumber.text = [NSString stringWithFormat:@"%.@单",GrapOrderBody.order_amount];
    cell.gridLabel.text = [NSString stringWithFormat:@"%@",GrapOrderBody.grid_name];
    cell.girdDetialLabel.text = [NSString stringWithFormat:@"%@",GrapOrderBody.grid_address];
    cell.sellerName.text = [NSString stringWithFormat:@"%@",GrapOrderBody.seller_name];
    cell.gridType.text = @"网格发单";
    cell.telLabel1.tag = [GrapOrderBody.seller_mobile integerValue];
    cell.location1Btn.tag = 100;
    return cell;
}

//cell1
- (IBAction)phoneButton1Click:(UIButton *)sender {
    NSString *tel = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([self.delegate respondsToSelector:@selector(phoneButton1Click:)]) {
        [self.delegate phoneButton1Click:tel];
    }
}


- (IBAction)locationButton1Click:(id)sender {
    if ([self.delegate respondsToSelector:@selector(locationButton1Click:)]) {
        [self.delegate locationButton1Click:(UIButton*)sender];
    }
}


//cell2
- (IBAction)songhuobtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(songBtnClick:)]) {
        [self.delegate songBtnClick:(sender)];
    }
}

- (IBAction)phoneBtn:(UIButton *)sender {
    
    NSString *tel = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([self.delegate respondsToSelector:@selector(phoneButton2Click:)]) {
        [self.delegate phoneButton2Click:tel];
    }
}


- (IBAction)shangjiaBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shangjiaBtnClick:)]) {
        [self.delegate shangjiaBtnClick:sender];
    }
}

//-(void)setHeighModel:(Out_GrapDetialListBody *)model{
//    // 1.文字的最大尺寸
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT);
//    // 2.计算文字的高度
//    CGFloat textH = [model.grid_address boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
//    
//    self.cellHeight=textH+170;
//}



@end
