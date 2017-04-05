//
//  msgHomeCell.h
//  BBJD
//
//  Created by cbwl on 16/12/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface msgHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *msg;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *noRead;
@property (weak, nonatomic) IBOutlet UIImageView *failSend;

@end
