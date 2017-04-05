//
//  datePickerView.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/23.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dateViewDelegate <NSObject>
-(void)ondatePickerCancelClick;
-(void)ondatePickerSureClickWith:(NSString *)start end:(NSString *)end;
@end
@interface datePickerView : UIView
@property (strong, nonatomic) UIDatePicker *dateStart;
@property (strong, nonatomic) UIDatePicker *dateEnd;
@property (nonatomic, strong) UIView *pickerBG;
@property (nonatomic, strong) UILabel *am;
@property (nonatomic, strong) UILabel *pm;
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UIButton *sure;
@property (nonatomic,strong) id <dateViewDelegate>delegate;
@end
