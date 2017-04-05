//
//  approveTViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "approveTViewCell.h"

@implementation approveTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)textTableView:(UITableView *) tableView index:(NSIndexPath *)index dic:(NSDictionary *)dic;
{
    if (index.section==1 ) {
        static NSString *cellName = @"button";
        approveTViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell1) {
            cell1=[[[NSBundle mainBundle] loadNibNamed:@"approveTViewCell" owner:self options:nil]objectAtIndex:1];
        }
//        cell.btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
        cell1.btn.tag=index.row;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if (index.row==0 &&index.section==1){
            cell1.type.text=@"可支配时间:";
            if ([[dic objectForKey:@"time"] isEqualToString:@""]) {
                [cell1.btn setText:@"请选择支配时间"];

            }
            else{
                cell1.btn.text=[dic objectForKey:@"time"];
            }
            
        }
        else if (index.row==1&&index.section==1){
            cell1.type.text=@"工作城市:";
            [cell1.btn setText:@"请选择城市"];

            
        }
        else if (index.row==2&&index.section==1){
            cell1.type.text=@"意向配送区域:";
            [cell1.btn setText:@"请选择意向区域" ];

        }
        else if (index.row==3&&index.section==1){
            cell1.type.text=@"交通工具:";
            if ([[dic objectForKey:@"traffic"] isEqualToString:@""]) {
                [cell1.btn setText:@"请选择交通工具"];
                
            }
            else{
                cell1.btn.text=   [dic objectForKey:@"traffic"];
            }


        }
        return cell1;

    }
    else {
        static NSString *cellName = @"text";
        approveTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"approveTViewCell" owner:self options:nil]objectAtIndex:0];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (index.row==0&&index.section==0)
        {
            cell.kind.text=@"支付宝账号";
            cell.textMsg.placeholder=@"请输入支付宝账号";
            
            
        }
        else if(index.row==0 &&index.section==2){
            cell.kind.text=@"紧急联系人姓名:";
            cell.textMsg.placeholder=@"请输入姓名";

        }
        
        else if(index.row==1 &&index.section==2){
            cell.kind.text=@"紧急联系人电话:";
            cell.textMsg.placeholder=@"请输入手机号码";

        }
        else if(index.row==0 &&index.section==3){
            cell.kind.text=@"邀请码:";
            cell.textMsg.placeholder=@"非必填";

        }
        
        return cell;

    }
    return nil;
    
}

- (IBAction)btnClick:(UIButton *)sender {
    [self.delegate  btnSelectKindWithType:(int)sender.tag];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
