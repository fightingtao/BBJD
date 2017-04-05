//
//  NotificationTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

-(void)setModel:(Out_informBody *)model{
    
    self.timeLabel.text = model.create_time;
    self.characterLabel.text = model.msg;
    self.timeLabel.frame = CGRectMake(20, 10,SCREEN_WIDTH-40 , 20);
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    
    // 2.计算文字的高度
    CGFloat textH = [self.characterLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.characterLabel.frame = CGRectMake(20,self.timeLabel.y+20+5, SCREEN_WIDTH-30, textH);
    [self.characterLabel sizeToFit];
    
    self.cellHeight = self.characterLabel.y +self.characterLabel.height +15;

}

@end
