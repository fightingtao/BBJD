//
//  telTableViewCell.m
//  BBJD
//
//  Created by 李志明 on 16/12/30.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "telTableViewCell.h"
#import "publicResource.h"
@implementation telTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
        self.phoneLabel.text = @"18118282879";
        [self.contentView addSubview:self.phoneLabel];
        
        self.seletedBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -45,7.5, 25, 25)];
        [self.seletedBtn setImage:[UIImage imageNamed:@"sec_empty.png"] forState:UIControlStateNormal];
        [self.seletedBtn setImage:[UIImage imageNamed:@"sec_yes.pmg" ] forState:UIControlStateSelected];
        [self.seletedBtn addTarget:self action:@selector(seletedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
        [self.contentView addSubview:self.seletedBtn];
        
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_seletedBtn.x-180,10, 160, 20)];
        self.adressLabel.textAlignment = 2;
        self.adressLabel.text = @"楼栋号 15 号";
        [self.contentView addSubview:self.adressLabel];
    }
    return self;
}

-(void)setModel:(Out_sortModel *)model{
    _model = model;
    self.phoneLabel.text = model.recipient_mobile;
    self.adressLabel.text = model.building_no;
     self.seletedBtn.selected = self.isSelected;
}


-(void)seletedBtnClick:(UIButton*)btn{
    
    self.seletedBtn.selected = !self.seletedBtn.selected;
    if (self.cartBlock) {
        self.cartBlock(self.seletedBtn.selected);
    }
    
}

@end
