//
//  myMsgChatTableViewCell.m
//  BBJD
//
//  Created by cbwl on 16/12/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "myMsgChatTableViewCell.h"
#define indetifier @"myMsgChatTableViewCell"
@implementation myMsgChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_right) {
            _right=[[UIImageView alloc]init];
            _right.image=[UIImage imageNamed:@"ios_mesage.png"];
            
            [self addSubview:_right];
        }
        if ( !_viewbg) {
            _viewbg=[UIView new];
            _viewbg.backgroundColor=MAINCOLOR;
            _viewbg.layer.cornerRadius=10;
            _viewbg.layer.masksToBounds=YES;
            [self addSubview:_viewbg];
        }
        
        if ( !_MgMsg) {
            _MgMsg=[[UILabel alloc]init];
            _MgMsg.textColor=[UIColor whiteColor];
            _MgMsg.font=[UIFont systemFontOfSize:15];
            _MgMsg.backgroundColor=MAINCOLOR;
            _MgMsg.textAlignment=NSTextAlignmentLeft;
            _MgMsg.numberOfLines=0;
            
            _MgMsg.text=@"[邦办即达]嗨!美女,快递来了,关注\"邦办即达\"微信公众号,免费带去快递送到宿舍楼。校园公益项目。";
            [_viewbg addSubview:_MgMsg];
            
        }
        
        _MgMsg.sd_layout
        .topSpaceToView(_viewbg,10)
        .leftSpaceToView(_viewbg,10)
        .autoHeightRatio(0);
        //        .bottomSpaceToView(_viewbg,5);
        [_MgMsg setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-100];
        
        _viewbg.sd_layout.rightSpaceToView(self,25)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10);
        [_viewbg setupAutoWidthWithRightView:_MgMsg rightMargin:10];
        
        
        _right.sd_layout.leftSpaceToView(_viewbg,-10)
        .rightSpaceToView(self,17)
        .heightIs(20)
        .bottomSpaceToView(self,10);
        
    }
    return self;
}
+(instancetype)myMsgChatTableviewCellWithIndex:(NSIndexPath *)indexp tableview:(UITableView *)tableview  listItem:(chatDetail *)list{
    myMsgChatTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:indetifier];
    if (!cell) {
        cell=[[myMsgChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    cell.MgMsg.text=list.msgText;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark  设置行高
+(float)setRowHeightWhitString:(NSString *)text;{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
     return rect.size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
