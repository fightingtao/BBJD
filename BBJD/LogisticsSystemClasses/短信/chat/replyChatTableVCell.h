//
//  replyChatTableVCell.h
//  BBJD
//
//  Created by cbwl on 16/12/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "chatDetail.h"

#import "ListDetails.h"
@interface replyChatTableVCell : UITableViewCell
@property (nonatomic ,strong)UIView *viewbg;
@property (nonatomic,strong)UILabel *replyMsg;
@property (nonatomic,strong)UIImageView *left;
+(instancetype)replyMsgChatTableviewCellWithIndex:(NSIndexPath *)indexp tableview:(UITableView *)tableview listItem:(chatDetail *)list;
+(float)setReplyRowHeightWhitString:(NSString *)text index:(NSIndexPath *)indexp tableView:(UITableView *)tableView;//设置行高

@end
