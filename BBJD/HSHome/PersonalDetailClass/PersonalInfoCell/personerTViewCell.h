//
//  personerTViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/16.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@protocol  personerCellDelegate <NSObject>

-(void)headerClickGoLogin;//dengl登录
-(void)goMoneyViewController;
-(void)goFeedbackVC;
-(void)goSetViewController;
-(void)goHistoryOrder;
-(void)goShareFriend;
-(void)goLearneViewc;
-(void)goRenZhengStatus;
-(void)goYaJinviewController;
-(void)goRullViewContr;
-(void)goPhoneClick;
@end

@interface personerTViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *header;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *live;
@property (weak, nonatomic) IBOutlet UILabel *today_monet;
@property (weak, nonatomic) IBOutlet UILabel *get_money;
@property (weak, nonatomic) IBOutlet UILabel *all_money;
@property (weak, nonatomic) IBOutlet UILabel *brokerInforLabel;
@property (nonatomic,strong) id <personerCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *payInforLabel;

+ (instancetype)personerTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(OutPersonerBody *)outModel;

@end
