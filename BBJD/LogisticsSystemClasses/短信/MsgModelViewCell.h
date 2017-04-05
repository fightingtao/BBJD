//
//  MsgModelViewCell.h
//  BBJD
//
//  Created by 李志明 on 17/2/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgModelViewCell : UITableViewCell
@property(nonatomic,assign)CGFloat cellHeight;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)cellAutoLayoutHeight:(NSString *)text;

@end
