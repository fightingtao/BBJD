//
//  NotificationTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@class Out_informBody;
@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)Out_informBody *model;
@property(nonatomic,assign)CGFloat cellHeight;
-(void)setModel:(Out_informBody *)model;
@end
