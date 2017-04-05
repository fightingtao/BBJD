//
//  myMsgChatTableViewCell.h
//  BBJD
//
//  Created by cbwl on 16/12/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetails.h"
#import "publicResource.h"
#import "chatDetail.h"
@interface myMsgChatTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIView *viewbg;

@property (nonatomic,strong)UILabel *MgMsg;
@property (nonatomic,strong)UIImageView *right;
+(instancetype)myMsgChatTableviewCellWithIndex:(NSIndexPath *)indexp tableview:(UITableView *)tableview listItem:(chatDetail *)list;
+(float)setRowHeightWhitString:(NSString *)text;

@end
