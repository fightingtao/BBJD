//
//  inputPhoneView.h
//  BBJD
//
//  Created by cbwl on 17/2/16.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  voiceDelegate <NSObject>
-(void)voiceBtnClickWithBtn:(UIButton *)btn;
@end

@interface inputPhoneView : UIView
@property (nonatomic,strong)UITextField *phone;
@property (nonatomic,strong)UIButton *voiceBtn;
@property (nonatomic,strong)id <voiceDelegate> delegate;
@end
