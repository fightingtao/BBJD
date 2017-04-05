//
//  LGoodsListTableViewCell.h
//  CYZhongBao
//
//  Created by xc on 16/1/25.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "communcat.h"


@protocol LOrderListDelegate <NSObject>

- (void)callPhoneWithModel:(NSString *)phone;

@end

@interface LGoodsListTableViewCell : UITableViewCell

@property (nonatomic, strong) id<LOrderListDelegate>delegate;


@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *shopImgview;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *orderAddressLabel;
@property (nonatomic, strong) UILabel *receiverNameLabel;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UILabel *sign_name;
@property(nonatomic,strong)Out_sendGoodsBody *model;

//@property (nonatomic, strong) UIView *line;
//@property (nonatomic, strong) UILabel *PayStatusLabel;
//@property (nonatomic, strong) UILabel *orderStatusLabel;
//@property (nonatomic, strong) UIImageView *phoneImgview;
@property NSInteger KindType;

-(void)setModel:(Out_sendGoodsBody*)model;

@end
