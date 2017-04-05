//
//  sendMsgTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 17/3/29.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@interface sendMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dingwei;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoujianren;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@property(nonatomic,strong)RACSubject *subject;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,assign)BOOL isSelected;//是否选中

@property(nonatomic,strong)Out_sendGoodsBody *model;

-(void)setModel:(Out_sendGoodsBody *)model;

+ (instancetype)sendMsgTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model;

@end
