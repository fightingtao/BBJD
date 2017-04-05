//
//  personerTViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/16.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "personerTViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
@implementation personerTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.setting.hidden = YES;
}

+ (instancetype)personerTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(OutPersonerBody *)outModel

{
    personerTViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"personer"];
    
    if (!cell) {
        cell=[[personerTViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"personer"];
            }
    
    if (!outModel) {
        [cell.header setBackgroundImage:[UIImage imageNamed:@"out_login.png"] forState:UIControlStateNormal] ;
        cell.phone.text=@"***********";
        cell.live.text=@"Lv0";
        cell.today_monet.text=@"¥0.00";
        cell.get_money.text=@"¥0.00";
        cell.all_money.text=@"¥0.00";
    }else{
        [cell.header sd_setImageWithURL:[NSURL URLWithString:outModel.header] forState:UIControlStateNormal];
        cell.phone.text = outModel.mobile;
        cell.live.text= [NSString stringWithFormat:@"Lv%@ %@",outModel.level,outModel.title];
        if ([outModel.today_profit floatValue] <0) {
            cell.today_monet.text=@"¥0.00";
        }else{
            cell.today_monet.text=[NSString stringWithFormat:@"¥%.2f",[outModel.today_profit floatValue]];
        }
        if ([outModel.withdraw_profit floatValue] < 0) {
            cell.get_money.text=@"¥0.00";
        }else{
            cell.get_money.text=[NSString stringWithFormat:@"¥%.2f",[outModel.withdraw_profit floatValue]];
        }
        if ([outModel.total_profit floatValue] < 0) {
            cell.all_money.text=@"¥0.00";
        }else{
            cell.all_money.text=[NSString stringWithFormat:@"¥%.2f",[outModel.total_profit floatValue]];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 头像点击   登录状态
- (IBAction)onHeaderClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headerClickGoLogin)]) {
        [self.delegate headerClickGoLogin];
    }
}

#pragma mark  信用金认证状态
- (IBAction)feedBack:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goYaJinviewController)]) {
        [self.delegate goYaJinviewController];
    }
}

#pragma mark  设置
- (IBAction)setCLick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goSetViewController)]) {
        [self.delegate goSetViewController];
    }
}

#pragma mark  我的钱包
- (IBAction)myMoneyClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goMoneyViewController)]) {
        [self.delegate goMoneyViewController];
    }
}

#pragma mark  历史订单
- (IBAction)historyOrderLcick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goHistoryOrder)]) {
        [self.delegate goHistoryOrder];
    }
}

#pragma mark  认证状态
- (IBAction)renZhengClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goRenZhengStatus)]) {
        [self.delegate goRenZhengStatus];
    }
}

#pragma mark  意见反馈
- (IBAction)onYaJInClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goFeedbackVC)]) {
        [self.delegate goFeedbackVC];
    }
}

#pragma mark  培训学习
- (IBAction)onLeanerClcik:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goLearneViewc)]) {
        [self.delegate goLearneViewc];
    }
}

#pragma mark  分享好友
- (IBAction)shareFriend:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goShareFriend)]) {
        [self.delegate goShareFriend];
    }
}

#pragma mark  规则说明
- (IBAction)onRulleClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goRullViewContr)]) {
         [self.delegate goRullViewContr];
    }
}

#pragma mark  服务热线
- (IBAction)onPhoneClick:(id)sender {
    [self.delegate goPhoneClick];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
