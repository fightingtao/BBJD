//
//  summaryTViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/17.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@protocol GotoSendGoodsDelegate <NSObject>
-(void)GotoSendGoods;
@end

@interface summaryTViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgBg;
@property (nonatomic,strong) UIImageView *presses;
@property (nonatomic,strong)UILabel *willSend;
@property (nonatomic,strong)UILabel *numb;
@property (nonatomic,strong)UILabel *dan;
@property (nonatomic,strong)UILabel *getMoney;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UILabel *y;
@property(nonatomic,weak)id<GotoSendGoodsDelegate>delegate;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_myHomeWorkBody *)myHomeWorkBody;

@end
