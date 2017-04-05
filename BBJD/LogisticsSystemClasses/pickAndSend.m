//
//  pickAndSend.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/17.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "pickAndSend.h"

@implementation pickAndSend
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    if (self) {
        if (!_btnPick){
            _btnPick = [[UIImageView alloc] init];
            _btnPick.userInteractionEnabled = YES;
          
            _btnPick.image = [UIImage imageNamed:@"bnt_fenjian.png"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPickCLick)];
            [_btnPick addGestureRecognizer:tap];

            [self addSubview:_btnPick];
            _btnPick.userInteractionEnabled = YES;
        }
        
        if (!_btnSend){
            _btnSend=[[UIImageView  alloc] init];
         
            _btnSend.userInteractionEnabled = YES;
            _btnSend.image = [UIImage imageNamed:@"btn_songhuo.png"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSendCLick)];
            [_btnSend addGestureRecognizer:tap];
            [self addSubview:_btnSend];
        }

        if (!_line) {
            _line=[[UILabel alloc]init];
            _line.backgroundColor = LineColor;
            [self addSubview:_line];
        }
        
        if (!_btnMessage){
            _btnMessage=[[UIImageView alloc] init];
            _btnMessage.userInteractionEnabled = YES;
            _btnMessage.image = [UIImage imageNamed:@"btn_sendmsg.png"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMessageCLick)];
            [_btnMessage addGestureRecognizer:tap];;
            _btnMessage.badgeFont = [UIFont boldSystemFontOfSize:9];
            _btnMessage.badgeCenterOffset = CGPointMake(70, 33);
            int nub=[[[NSUserDefaults standardUserDefaults]objectForKey:kNoRead] intValue];
            [_btnMessage showBadgeWithStyle:WBadgeStyleNumber value:nub animationType:WBadgeAnimTypeScale];
            [_btnMessage setBadgeMaximumBadgeNumber:99];
            [self addSubview:_btnMessage];
            
        }
        if (!_line2) {
            _line2=[[UILabel alloc]init];
            _line2.backgroundColor = LineColor;
            [self addSubview:_line2];
        }

        _btnPick.sd_layout.leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .heightIs(119)
        .widthIs((SCREEN_WIDTH-40)/3);
        
        _line.sd_layout.leftSpaceToView(_btnPick,0)
        .topSpaceToView(self,30)
        .bottomSpaceToView(self,30)
        .widthIs(1);
        
        _btnSend.sd_layout.leftSpaceToView(_btnPick,10)
        .topSpaceToView(self,10)
        .widthIs((SCREEN_WIDTH-40)/3)
        .heightIs(119);
        
        _line2.sd_layout.leftSpaceToView(_btnSend,10)
        .topSpaceToView(self,30)
        .bottomSpaceToView(self,30)
        .widthIs(1);

        _btnMessage.sd_layout.rightSpaceToView(self, 10)
        .topSpaceToView(self, 10)
        .widthIs((SCREEN_WIDTH-40)/3)
        .heightIs(119);
    }
    return self;

}

-(void)onPickCLick{
    
    if ([self.delegate respondsToSelector:@selector(pickupGoodsClick)]) {
         [self.delegate pickupGoodsClick];
    }
}

-(void)onSendCLick{
    if ([self.delegate respondsToSelector:@selector(sendGoodsClick)]) {
        [self.delegate sendGoodsClick];
    }
}
-(void)onMessageCLick{
    if ([self.delegate respondsToSelector:@selector(sendMessageClick)]) {
        [self.delegate sendMessageClick];
    }

}
@end
