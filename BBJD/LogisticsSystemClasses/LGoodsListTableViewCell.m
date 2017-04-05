//
//  LGoodsListTableViewCell.m
//  CYZhongBao
//
//  Created by xc on 16/1/25.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LGoodsListTableViewCell.h"
#define  TextCOLOR [UIColor colorWithRed:0.3804 green:0.3804 blue:(0.3765) alpha:1.0]

@implementation LGoodsListTableViewCell
@synthesize delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if (!_timeLabel) {
            _timeLabel = [[UILabel alloc] init];
            _timeLabel.backgroundColor = [UIColor clearColor];
            _timeLabel.font = LittleFont;
            _timeLabel.textColor = TextDetailCOLOR;
            _timeLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _timeLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_timeLabel];
        }
        
        if (!_statusLabel) {
            _statusLabel = [[UILabel alloc] init];
            _statusLabel.backgroundColor = [UIColor clearColor];
            _statusLabel.textColor=[UIColor redColor];
            _statusLabel.font = LittleFont;
            _statusLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_statusLabel];
        }
        
        if (!_shopImgview) {
            _shopImgview = [[UIImageView alloc] init];
            _shopImgview.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:_shopImgview];
        }
        
        if (!_shopNameLabel) {
            _shopNameLabel = [[UILabel alloc] init];
            _shopNameLabel.backgroundColor = [UIColor clearColor];
            _shopNameLabel.font = kTextFont16;
            _shopNameLabel.textColor = TextCOLOR;
            _shopNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _shopNameLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_shopNameLabel];
        }
        
        if (!_orderNumLabel) {
            _orderNumLabel = [[UILabel alloc] init];
            _orderNumLabel.backgroundColor = [UIColor clearColor];
            _orderNumLabel.font = MiddleFont;
            _orderNumLabel.textColor = TextCOLOR;
            _orderNumLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _orderNumLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_orderNumLabel];
        }
    
        if (!_orderAddressLabel) {
            _orderAddressLabel = [[UILabel alloc] init];
            _orderAddressLabel.backgroundColor = [UIColor clearColor];
            _orderAddressLabel.font = MiddleFont;
            _orderAddressLabel.textColor = TextCOLOR;
            _orderAddressLabel.numberOfLines = 0;
            _orderAddressLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _orderAddressLabel.textAlignment = NSTextAlignmentLeft;
            
            _orderAddressLabel.numberOfLines = 0;
//            _orderAddressLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_orderAddressLabel];
        }
        
        if (!_receiverNameLabel) {
            _receiverNameLabel = [[UILabel alloc] init];
            _receiverNameLabel.backgroundColor = [UIColor clearColor];
            _receiverNameLabel.font = MiddleFont;
            _receiverNameLabel.textColor = TextCOLOR;
            _receiverNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _receiverNameLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_receiverNameLabel];
        }
        
        if (!_phoneBtn) {
            _phoneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_phoneBtn];
        }
        
        _timeLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(self,15)
        .heightIs(20);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        //WithFrame:CGRectMake(20, 45, 20, 20)
        _shopImgview.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_timeLabel,5)
        .widthIs(20)
        .heightIs(20);
        
        _shopNameLabel.sd_layout.leftSpaceToView(_shopImgview,10)
        .topSpaceToView(_timeLabel,5)
        .heightIs(20);
        [_shopNameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _statusLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_shopImgview,10)
        .heightIs(20);
        [_statusLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _orderNumLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_statusLabel,10)
        .heightIs(20);
        [_orderNumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _orderAddressLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_orderNumLabel,10)
        .heightIs(40)
        .widthIs(SCREEN_WIDTH-40);
        [_orderAddressLabel sizeToFit];
        _orderAddressLabel.numberOfLines = 0;
        
        _receiverNameLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_orderAddressLabel,5)
        .heightIs(20);
        [_receiverNameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-40];
        
        _phoneBtn.sd_layout.rightSpaceToView(self,20)
        .topSpaceToView (_orderAddressLabel,5)
        .heightIs(25)
        .widthIs(95);
    }
    return self;
}

- (void)setModel:(Out_sendGoodsBody*)model
{
    if([model.order_status integerValue]== 3){
        [self.statusLabel setHidden:NO];

        self.timeLabel.text =[NSString stringWithFormat:@"%@", model.linghuo_time];//领货时间
     
        self.statusLabel.text = [NSString stringWithFormat:@"异常原因：%@", model.expt_msg];
        NSString *shop=[NSString stringWithFormat:@"%@",model.dssnname];;//商家名称
        if ([shop isEqualToString:@""]||shop.length<=0||!model.dssnname) {
             self.shopNameLabel.text =@"未知";
        }else{
        self.shopNameLabel.text = [NSString stringWithFormat:@"%@",model.dssnname];;//商家名称
        }
        self.orderNumLabel.text =[NSString stringWithFormat:@"订单号:%@",model.order_original_id];
        _orderAddressLabel.text = [NSString stringWithFormat:@"收件地址:%@",model.consignee_address];
        _receiverNameLabel.text = [NSString stringWithFormat:@"收件人姓名:%@",model.consignee_name];//收件人姓名
        _shopImgview.image = [UIImage imageNamed:@"商家图标"];
        _phoneBtn.tag = [model.consignee_mobile integerValue];
        
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"btn_call"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        _orderNumLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_statusLabel,10)
        .heightIs(20);
        [_orderNumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

    }else {
        
        [self.statusLabel setHidden:YES];
        self.timeLabel.text =[NSString stringWithFormat:@"%@", model.linghuo_time];//领货时间
        NSString *shop=[NSString stringWithFormat:@"%@",model.dssnname];;//商家名称

        if ([shop isEqualToString:@""]||shop.length<=0||!model.dssnname) {
            self.shopNameLabel.text = @"未知";
        }else{
            self.shopNameLabel.text = [NSString stringWithFormat:@"%@",model.dssnname];;//商家名称
        }
        self.orderNumLabel.text =[NSString stringWithFormat:@"订单号:%@",model.order_original_id];
        _orderAddressLabel.text = [NSString stringWithFormat:@"收件地址:%@",model.consignee_address];
        _receiverNameLabel.text = [NSString stringWithFormat:@"收件人姓名:%@",model.consignee_name];//收件人姓名
        _shopImgview.image = [UIImage imageNamed:@"商家图标"];
        _phoneBtn.tag = [model.consignee_mobile integerValue];
        
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"btn_call.png"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        _orderNumLabel.sd_layout.leftSpaceToView(self,20)
        .topSpaceToView(_shopNameLabel,10)
        .heightIs(20);
        [_orderNumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    }
}

//电话按钮点击
- (void)onPhoneClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(callPhoneWithModel:)]) {
        
        [self.delegate callPhoneWithModel:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
