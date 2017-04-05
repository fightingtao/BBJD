//
//  phoneTViewCell.h
//  BBJD
//
//  Created by cbwl on 16/12/20.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"



@interface phoneTViewCell : UITableViewCell

@property(nonatomic,strong) Out_sortModel*model;

@property(nonatomic,strong)UITextField *textfiled;
@property(nonatomic,strong)UILabel *adressLabel;

/**变化时回调后回调 */
//@property (nonatomic,copy) void(^deleteBlock)(NSString*text);

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setModel:(Out_sortModel *)model;

@end
