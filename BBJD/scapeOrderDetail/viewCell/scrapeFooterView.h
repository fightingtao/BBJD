//
//  scrapeFooterView.h
//  BBJD
//
//  Created by cbwl on 16/9/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol footerDelegate <NSObject>
#pragma mark 取消按钮
-(void)onCancelClick:(UIButton *)btn;
#pragma mark 去工作按钮
-(void)onGoWorkClick:(UIButton *)btn;

#pragma mark 接单按钮
-(void)onGetOrderClick:(UIButton *)btn;


@end

@interface scrapeFooterView : UIView
@property (nonatomic,strong) UIButton *cancel;
@property (nonatomic,strong) UIButton *goWork;
@property (nonatomic,strong) UIButton *getOrder;
@property (nonatomic,strong)  id <footerDelegate> delegate;
@end
