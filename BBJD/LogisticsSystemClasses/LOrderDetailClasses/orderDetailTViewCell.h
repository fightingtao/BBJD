//
//  orderDetailTViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/18.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communcat.h"
@protocol orderLocationDelegate <NSObject>
-(void)orderDetailLocation:(UIButton*)btn;
@end

@interface orderDetailTViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reasonLable;

@property (nonatomic,strong)id <orderLocationDelegate>delegate;
@property (nonatomic,assign)int status_type;//1正常 2异常件

@property(nonatomic,assign)CGFloat cellHeight1;

@property(nonatomic,assign)CGFloat cellHeight2;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_detialListBody *)model;
+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_sendGoodsBody *)model;


@end
