//
//  orderDetailTViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/18.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "orderDetailTViewCell.h"
#import "publicResource.h"
@interface orderDetailTViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dssnnameLable;//商家名称

@property (weak, nonatomic) IBOutlet UILabel *order_original_idLable;//订单号

@property (weak, nonatomic) IBOutlet UILabel *consignee_nameLable;//收件人姓名
@property (weak, nonatomic) IBOutlet UILabel *consignee_addressLable;//收件人地址
@property (weak, nonatomic) IBOutlet UILabel *show1;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shangjiaImg;
@property (weak, nonatomic) IBOutlet UILabel *dingdanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoujiandizhiLabel;

@property (weak, nonatomic) IBOutlet UILabel *yichang;

//cell2
@property (weak, nonatomic) IBOutlet UILabel *dssname;

@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *orderid;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (nonatomic,copy)NSString *adds;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end



@implementation orderDetailTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_detialListBody *)model
{
   static  NSString *identifier = @"cell";//对应xib中设置的identifier
        orderDetailTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
             cell = [[[NSBundle mainBundle]loadNibNamed:@"orderDetailTViewCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
            cell.dssname.text =@"哎呀!没找到商家";
        }
        else{
            cell.dssname.text =[NSString stringWithFormat:@"%@",model.dssnname];
        }
    cell.orderid.text = model.order_original_id;
    cell.name.text = model.consignee_name;
    cell.mobile.text = model.consignee_mobile;
    cell.address.text = model.consignee_address;
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    //        cell.adressLabel.text  = @"hhahahha";
    // 2.计算文字的高度
    CGFloat textH = [cell.address.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    cell.address.frame =CGRectMake(cell.mobile.x, cell.mobile.y+cell.mobile.height+19,SCREEN_WIDTH-130,textH);
    [ cell.address sizeToFit];
    
    cell.btn.frame = CGRectMake(SCREEN_WIDTH-35, cell.address.y+(cell.address.height-30)/2, 30, 30);
    
    cell.cellHeight1 = cell.address.y + cell.address.height +10;
    
        return cell;
}




+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model{
    static  NSString *identifier = @"tifier";
    orderDetailTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"orderDetailTViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    if(model.next_delivery_time.length>0){
        NSString *time = [model.next_delivery_time substringWithRange:NSMakeRange(5, 5)];
        cell.reasonLable.text = [NSString stringWithFormat:@"%@ %@再次配送",model.expt_msg,time];
        
    }else{
        NSString * responseString = [model.expt_msg stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        cell.reasonLable.text = [NSString stringWithFormat:@"%@",responseString];
     
    }

    
    if ([[NSString stringWithFormat:@"%@",model.dssnname] length]==0||!model.dssnname){
        cell.dssnnameLable.text =@"哎呀!没找到商家";
    }
    else{
        cell.dssnnameLable.text =[NSString stringWithFormat:@"%@",model.dssnname];
        
    }
    
    cell.timeLabel.text = model.linghuo_time;
    cell.yichang.frame = CGRectMake(20, cell.timeLabel.y+23, 80, 20);
    cell.order_original_idLable.text = model.order_original_id;
    
    cell.consignee_nameLable.text = model.consignee_name;

    cell.consignee_addressLable.text = [NSString stringWithFormat:@"%@",model.consignee_address];
    
    // 1.文字的最大尺寸
    CGSize maxSize0 = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH0 = [cell.reasonLable.text boundingRectWithSize:maxSize0 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    cell.reasonLable.frame = CGRectMake(cell.yichang.x+cell.yichang.width, cell.timeLabel.y+cell.timeLabel.height+5, SCREEN_WIDTH-110, textH0);
    [cell.reasonLable sizeToFit];
    
    cell.shangjiaImg.frame = CGRectMake(20, cell.reasonLable.y+cell.reasonLable.height+3, 20, 20);
    cell.dssnnameLable.frame = CGRectMake(cell.shangjiaImg.x+20+15,cell.reasonLable.y+cell.reasonLable.height+5 , SCREEN_WIDTH-100, 20);
    cell.dingdanLabel.frame = CGRectMake(20, cell.dssnnameLable.y+cell.dssnnameLable.height+5,65,20);
    cell.order_original_idLable.frame = CGRectMake(cell.dingdanLabel.x+cell.dingdanLabel.width+10, cell.dingdanLabel.y, SCREEN_WIDTH-100, 20);
    cell.shoujiandizhiLabel.frame = CGRectMake(20, cell.dingdanLabel.y+20+5, 80, 20);
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    //        cell.adressLabel.text  = @"hhahahha";
    // 2.计算文字的高度
    CGFloat textH = [cell.consignee_addressLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    cell.consignee_addressLable.frame =CGRectMake(cell.order_original_idLable.x, cell.order_original_idLable.y+cell.order_original_idLable.height+7,SCREEN_WIDTH-110,textH);
    [ cell.consignee_addressLable sizeToFit];
    
    cell.show1.frame = CGRectMake(20, cell.consignee_addressLable.y+cell.consignee_addressLable.height+5,80 ,20);
    cell.consignee_nameLable.frame = CGRectMake(cell.consignee_addressLable.x, cell.show1.y, 150, 20);
    cell.phoneButton.frame = CGRectMake(SCREEN_WIDTH-50, cell.show1.y-5, 30, 30);
        cell.phoneButton.tag = indexPath.section;
    cell.cellHeight2 = cell.consignee_nameLable.y+cell.consignee_nameLable.height +10;
    return cell;
}


- (IBAction)btnLocation:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderDetailLocation:)]) {
        [self.delegate orderDetailLocation:(UIButton*)sender];
    }
}

- (IBAction)btnlocationCell1:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderDetailLocation:)]) {
        [self.delegate orderDetailLocation:(UIButton*)sender];
    }
}

@end
