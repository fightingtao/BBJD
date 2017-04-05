//
//  MsgModelViewCell.m
//  BBJD
//
//  Created by 李志明 on 17/2/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "MsgModelViewCell.h"
#import "publicResource.h"
@interface MsgModelViewCell()

@property(nonatomic,strong)UILabel *label;

@end

@implementation MsgModelViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.font = MiddleFont;
        _label.numberOfLines = 0;
        _label.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label];
       
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)cellAutoLayoutHeight:(NSString *)text{
    
    self.label.text =  text;
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    self.label.frame = CGRectMake(20, 15, SCREEN_WIDTH-40, textH);
    [self.label sizeToFit];
    
    _cellHeight = self.label.height +30;

}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
