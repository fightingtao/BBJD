//
//  replyChatTableVCell.m
//  BBJD
//
//  Created by cbwl on 16/12/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "replyChatTableVCell.h"
#import "chatDetail.h"
#define indetifier @"replyCell"
@implementation replyChatTableVCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_left) {
            _left=[[UIImageView alloc]init];
            _left.image=[UIImage imageNamed:@"ios_mesage_hui.png"];
            
            [self addSubview:_left];
        }

        if ( !_viewbg) {
            _viewbg=[UIView new];
            _viewbg.backgroundColor=[UIColor colorWithRed:0.8667 green:0.8667 blue:0.8667 alpha:1];
            _viewbg.layer.cornerRadius=10;
            _viewbg.layer.masksToBounds=YES;
            [self addSubview:_viewbg];
        }
       
        if ( !_replyMsg) {
            _replyMsg=[[UILabel alloc]init];
            _replyMsg.textColor=[UIColor blackColor];
            _replyMsg.font=[UIFont systemFontOfSize:15];
        
            _replyMsg.backgroundColor=[UIColor colorWithRed:0.8667 green:0.8667 blue:0.8667 alpha:1];
            _replyMsg.textAlignment=NSTextAlignmentLeft;
            _replyMsg.text=@"嗯,知道了,你给我送到宿舍楼下,如果你要是不送到的话,直接拒收,还投诉你-_-";
            //文字居中显示
            _replyMsg.sd_maxWidth=@(SCREEN_WIDTH-200);
            _replyMsg.textAlignment = NSTextAlignmentCenter;
            //自动折行设置
            _replyMsg.numberOfLines = 0;
            [_viewbg addSubview:_replyMsg];
        }
        _replyMsg.sd_layout.leftSpaceToView(_viewbg,10)
        .topSpaceToView(_viewbg,10)
        .autoHeightRatio(0);
//        .bottomSpaceToView(_viewbg,5);
        [_replyMsg setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-100];
        
              _viewbg.sd_layout.leftSpaceToView(self,25)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10);
        [_viewbg setupAutoWidthWithRightView:_replyMsg rightMargin:10];
        
        _left.sd_layout.rightSpaceToView(_viewbg,-15)
        .leftSpaceToView(self,17)
        .heightIs(20)
        .bottomSpaceToView(self,10);
        

     
        
    }
    return self;
}


+(instancetype)replyMsgChatTableviewCellWithIndex:(NSIndexPath *)indexp tableview:(UITableView *)tableview listItem:(chatDetail *)list{

    replyChatTableVCell *cell=[tableview dequeueReusableCellWithIdentifier:indetifier];
    if (!cell) {
        cell=[[replyChatTableVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        
    }
    cell.replyMsg.text=list.msgText;
       cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
#pragma mark  设置行高
+(float)setReplyRowHeightWhitString:(NSString *)text index:(NSIndexPath *)indexp tableView:(UITableView *)tableView;{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    //cell.viewbg.frame=CGRectMake(40, 10, rect.size.width,  rect.size.height+20);

    return rect.size.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
