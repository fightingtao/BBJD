//
//  phoneTViewCell.m
//  BBJD
//
//  Created by cbwl on 16/12/20.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "phoneTViewCell.h"
#import "publicResource.h"

@implementation phoneTViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        self.textfiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
        self.textfiled.text = @"18118282879";
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.textfiled];
    
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-180,10, 160, 20)];
        self.adressLabel.textAlignment = 2;
        self.adressLabel.text = @"楼栋号 15 号";
        [self addSubview:self.adressLabel];
    }
    return self;
}

-(void)setModel:(Out_sortModel *)model{
    _model = model;
    self.textfiled.text = model.recipient_mobile;
    self.adressLabel.text = model.building_no;
    
}

//-(void)valueChanged:(UITextField*)field{
//      !_deleteBlock ? : _deleteBlock(field.text);
//}
@end
