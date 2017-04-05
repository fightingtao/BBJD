//
//  phoneInPutView.h
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol voiceDelegate <NSObject>
    
-(void)voiceBtnClickWithBtn:(UIButton *)btn;
   @end

@interface phoneInPutView : UIView

    @property (nonatomic,strong)UITextField *phone;
    @property (nonatomic,strong)UIButton *voicebtn;
    @property (nonatomic,strong)id<voiceDelegate>delegate;
    
    @end
