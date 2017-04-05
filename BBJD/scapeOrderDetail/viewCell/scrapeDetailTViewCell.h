//
//  scrapeDetailTViewCell.h
//  BBJD
//
//  Created by 李志明 on 16/10/14.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communcat.h"
@protocol orderDetialDelegate <NSObject>

-(void)phoneButton1Click:(NSString*)tel;
-(void)locationButton1Click:(UIButton*)btn;

-(void)songBtnClick:(UIButton*)btn;
-(void)shangjiaBtnClick:(UIButton*)btn;
-(void)phoneButton2Click:(NSString*)tel;

@end

@interface scrapeDetailTViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//收入
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;//单量
@property (weak, nonatomic) IBOutlet UILabel *gridLabel;

@property (weak, nonatomic) IBOutlet UILabel *girdDetialLabel;

@property (weak, nonatomic) IBOutlet UILabel *gridType;

@property (weak, nonatomic) IBOutlet UIButton *telLabel1;

@property (weak, nonatomic) IBOutlet UIButton *location1Btn;


//cell2

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber2;
@property (weak, nonatomic) IBOutlet UILabel *gridLabel1;

@property (weak, nonatomic) IBOutlet UILabel *gridDetail2;
@property (weak, nonatomic) IBOutlet UILabel *sellerName2;
@property (weak, nonatomic) IBOutlet UILabel *sellerAdress;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;

@property (weak, nonatomic) IBOutlet UILabel *gridType2;

@property (weak, nonatomic) IBOutlet UIButton *songBtn;

@property (weak, nonatomic) IBOutlet UIButton *telPhone;

@property (weak, nonatomic) IBOutlet UIButton *shangjiaBtn;
//@property (nonatomic,assign)float cellHeight;
+(instancetype)detialTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_GrapDetialListBody *)GrapOrderBody;
@property(nonatomic,weak)id<orderDetialDelegate>delegate;
//-(void)setHeighModel:(Out_GrapDetialListBody *)model;
@end
