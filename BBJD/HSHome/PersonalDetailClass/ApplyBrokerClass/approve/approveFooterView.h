//
//  approveFooterView.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol footerDelegate <NSObject>
-(void)checkDelegateClick;
-(void)onCommitBtnClick;

@end

@interface approveFooterView : UIView
@property (nonatomic,strong)UILabel *List;
@property (nonatomic,strong)UIButton *godelegate;
@property (nonatomic,strong) UIButton *commit;
@property (nonatomic,strong) id <footerDelegate> delegat;
@end
