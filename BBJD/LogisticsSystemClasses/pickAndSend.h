//
//  pickAndSend.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/17.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@protocol pickAndSendDelegate <NSObject>
-(void)pickupGoodsClick;
-(void)sendGoodsClick;
-(void)sendMessageClick;

@end

@interface pickAndSend : UIView
@property(nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *btnPick;
@property (nonatomic,strong) UIImageView *btnSend;
@property(nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIImageView *btnMessage;
@property (nonatomic,strong) id <pickAndSendDelegate>delegate;
@end
