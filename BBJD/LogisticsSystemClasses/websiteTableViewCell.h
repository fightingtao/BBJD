//
//  websiteTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/10/10.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communcat.h"
@protocol websiteTabelDelegate <NSObject>
-(void)problemBtnDelegate;
-(void)signBtnDelegate;
@end

@interface websiteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumLabel;

@property(nonatomic,weak)id <websiteTabelDelegate> delegate;

//cell2
@property (weak, nonatomic) IBOutlet UILabel *linghuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *dingdanhao;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shangjiaImg;
@property (weak, nonatomic) IBOutlet UILabel *dingdanlabel;
@property (weak, nonatomic) IBOutlet UILabel *yichang;
@property(nonatomic,assign)CGFloat cellHeight2;
+ (instancetype)webTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model;
@end
