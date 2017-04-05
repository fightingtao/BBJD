//
//  summaryTViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/17.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "summaryTViewCell.h"

@implementation summaryTViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_imgBg){
            _imgBg=[[UIImageView alloc]init];
            _imgBg.image=[UIImage imageNamed: @"圆圈"];
            _imgBg.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
            [_imgBg addGestureRecognizer:tap];
            [self addSubview:_imgBg];
        }
        
        
        
        if (!self.willSend) {
            self.willSend=[[UILabel alloc]init];
            self.willSend.text=@"今日待配送";
            self.willSend.textColor=kTextWorkCOLOR;
            self.willSend.font=MiddleFont;
            
            self.willSend.textAlignment=NSTextAlignmentCenter;
            [self.imgBg addSubview:self.willSend];
        }
        
        if (!self.numb) {
            self.numb=[[UILabel alloc]init];
            self.numb.text=@"0";
            self.numb.font=[UIFont systemFontOfSize:90];
            self.numb.textColor=[UIColor colorWithRed:0.2275 green:0.1333 blue:0.3882 alpha:1.0];
            self.numb.textAlignment=NSTextAlignmentCenter;
            [self.imgBg addSubview:self.numb];
        }
        
        if (!self.dan) {
            self.dan=[[UILabel alloc]init];
            self.dan.text=@"单";
            self.dan.textColor=kTextWorkCOLOR;
            self.dan.font = LargeFont;
            self.dan.textAlignment=NSTextAlignmentCenter;
            [self.imgBg addSubview:self.dan];
        }
        
        if (!self.getMoney) {
            self.getMoney=[[UILabel alloc]init];
            self.getMoney.text=@"今日收益";
            self.getMoney.textColor= [UIColor colorWithRed:0.9843 green:0.9961 blue:0.9922 alpha:1.0];
                self.getMoney.font=MiddleFont;
            self.getMoney.textAlignment=NSTextAlignmentCenter;
            [self addSubview:self.getMoney];
        }
        
        if (!self.money) {
            self.money=[[UILabel alloc]init];
            self.money.text=@"35";
            self.money.textColor=[UIColor colorWithRed:0.9843 green:0.9961 blue:0.9922 alpha:1.0];
            self.money.font=[UIFont systemFontOfSize:45];

            self.money.textAlignment=NSTextAlignmentCenter;
            [self addSubview:self.money];
        }
        if (!self.y) {
            self.y=[[UILabel alloc]init];
            self.y.text=@"¥";
            self.y.textColor=[UIColor colorWithRed:0.9843 green:0.9961 blue:0.9922 alpha:1.0];
            self.y.font=[UIFont systemFontOfSize:25];

            self.y.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.y];
        }

        self.imgBg.sd_layout.centerXEqualToView(self)
        .widthIs(SCREEN_WIDTH-100)
        .heightIs(SCREEN_WIDTH-100)
        .topSpaceToView(self,20);
        
        self.willSend.sd_layout.centerXEqualToView( self.imgBg)
        .heightIs(10)
        .topSpaceToView(self.imgBg,60);
        [self.willSend setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
        self.numb.sd_layout.centerXEqualToView(self.imgBg)
        .heightIs(80)
        .centerYEqualToView(self.imgBg);
        [self.numb setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        self.dan.sd_layout.leftSpaceToView(self.numb,-5)
        .heightIs(30)
        .bottomEqualToView(self.numb);
        [self.dan setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
        self.money.sd_layout.centerXEqualToView(self)
        .heightIs(35)
        .bottomSpaceToView(self,10);
        [self.money setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        self.getMoney.sd_layout.centerXEqualToView(self)
        .heightIs(30)
        .topSpaceToView(self.imgBg,5);
        [self.getMoney setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        self.y.sd_layout.rightSpaceToView(self.money,5)
        .heightIs(20)
        .widthIs(20)
        .bottomEqualToView(self.money);
    }
    return self;
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(Out_myHomeWorkBody *)myHomeWorkBody;
{
    static NSString *cellName = @"cell";
    
    summaryTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[summaryTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.backgroundColor = MAINCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!myHomeWorkBody) {
        cell.numb.text = @"0";
        cell.money.text =@"0.00";
    }else{
        cell.numb.text = myHomeWorkBody.waiting_delivery_order_count;
        if (myHomeWorkBody.today_profit.length >= 4) {
            NSString *shou = [myHomeWorkBody.today_profit substringToIndex:4];
            cell.money.text = shou ;
        }else{
            cell.money.text = myHomeWorkBody.today_profit;
        }
    }
    return cell;
}

-(void)tapClick{
    if ([self.delegate respondsToSelector:@selector(GotoSendGoods)]) {
        
        [self.delegate GotoSendGoods];
    }
}

@end
