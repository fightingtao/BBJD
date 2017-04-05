//
//  approveTViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol btnLCickDelegate <NSObject>
-(void )btnSelectKindWithType:(int)type;//1  可支配时间 2城市 3.区域  4.交通工具
@end
@interface approveTViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;


@property (weak, nonatomic) IBOutlet UILabel *btn;

@property (weak, nonatomic) IBOutlet UILabel *kind;
@property (weak, nonatomic) IBOutlet UITextField *textMsg;
@property (nonatomic,strong)id <btnLCickDelegate> delegate;
+(instancetype)textTableView:(UITableView *) tableView index:(NSIndexPath *)index dic:(NSDictionary *)dic;
@end
