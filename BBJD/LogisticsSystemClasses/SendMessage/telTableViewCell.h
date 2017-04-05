//
//  telTableViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/12/30.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"

typedef void(^ZQTCartBlock)(BOOL select);

@interface telTableViewCell : UITableViewCell

@property(nonatomic,strong) Out_sortModel*model;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *adressLabel;
@property(nonatomic,strong)UIButton *seletedBtn;

@property (nonatomic,assign)BOOL isSelected;//是否选中

@property (nonatomic,copy)ZQTCartBlock cartBlock;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setModel:(Out_sortModel *)model;
@end
