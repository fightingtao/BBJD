//
//  datePickerView.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/23.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "datePickerView.h"
#import "publicResource.h"
@implementation datePickerView


-(id)init{
    self=[super init];
    if (self) {
        
        {
            
            if (!self.pickerBG) {
                _pickerBG=[[UIView alloc]init];
                _pickerBG.backgroundColor=[UIColor whiteColor];
                _pickerBG.frame=CGRectMake(0, 100, SCREEN_WIDTH,350);
                [self addSubview:_pickerBG];
            }
            
            if (!_am) {
                _am=[[UILabel alloc]init];
                _am.text=@"上午";

                _am.textColor=kTextMainCOLOR;
                _am.font=MiddleFont;
                [_pickerBG addSubview:_am];
            }
            if (!_pm) {
                _pm=[[UILabel alloc]init];
                _pm.text=@"下午";
                
                _pm.textColor=kTextMainCOLOR;
                _pm.font=MiddleFont;
                [_pickerBG addSubview:_pm];
            }
            
            if (!self.dateStart) {
                self.dateStart = [[UIDatePicker alloc] init];
                self.dateStart.backgroundColor=[UIColor whiteColor];
                // 本地化
                //        self.dateStart.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
                [self.dateStart setTimeZone:[NSTimeZone localTimeZone]];
                
                // 设置当前显示时间
                [self.dateStart setDate:[NSDate date] animated:YES];
                //    self.dateStart.frame=CGRectMake(40, 100, (SCREEN_WIDTH-80)/2, 250);
                // 日期控件格式
                self.dateStart.datePickerMode = UIDatePickerModeCountDownTimer;
                [_pickerBG addSubview:self.dateStart];
                

            }
            if (!self.dateEnd) {
                self.dateEnd = [[UIDatePicker alloc] init];
                self.dateEnd.backgroundColor=[UIColor whiteColor];
                // 本地化
                //        self.dateStart.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
                [self.dateEnd setTimeZone:[NSTimeZone localTimeZone]];
                
                // 设置当前显示时间
                [self.dateEnd setDate:[NSDate date] animated:YES];
                self.dateEnd.frame=CGRectMake(40+(SCREEN_WIDTH-80)/2, 100, (SCREEN_WIDTH-80)/2, 250);
                // 日期控件格式
                self.dateEnd.datePickerMode = UIDatePickerModeCountDownTimer;
                [_pickerBG addSubview:self.dateEnd];
                

            }
            
            if (!_cancel) {
                _cancel=[UIButton buttonWithType:UIButtonTypeCustom];
                [_cancel setTitle:@"取消" forState:UIControlStateNormal];
                [_cancel setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
                _cancel.titleLabel.font=MiddleFont;
                
                [_cancel addTarget:self action:@selector(onCancelBtnCLick) forControlEvents:UIControlEventTouchUpInside];
                [_pickerBG addSubview:_cancel];
            }
            
            if (!_sure) {
                _sure=[UIButton buttonWithType:UIButtonTypeCustom];
                [_sure setTitle:@"确定" forState:UIControlStateNormal];
//                [_sure setBackgroundColor:[UIColor redColor]];
                [_sure setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
                _sure.titleLabel.font=MiddleFont;
                
                [_sure addTarget:self action:@selector(onPickSureBtnCLick) forControlEvents:UIControlEventTouchUpInside];
                [_pickerBG addSubview:_sure];
            }
            

            _cancel.sd_layout.rightSpaceToView(_pickerBG,40)
            .topSpaceToView(_pickerBG,10)
            .widthIs(50)
            .heightIs(30);
            
            _sure.sd_layout.leftSpaceToView(_pickerBG,40)
            .topSpaceToView(_pickerBG,10)
            .widthIs(50)
            .heightIs(30);
            
            _am.sd_layout.centerXEqualToView(self.dateStart)
            .heightIs(20)
            .widthIs(50)
            .topSpaceToView(_cancel,10);
            
            _pm.sd_layout.centerXEqualToView(self.dateEnd)
            .heightIs(20)
            .widthIs(50)
            .topSpaceToView(_sure,10);
            
            self.dateStart.sd_layout.leftSpaceToView(_pickerBG,10)
            .heightIs(250)
            .widthIs((SCREEN_WIDTH-70)/2)
            .topSpaceToView(_am,10);
            
            self.dateEnd.sd_layout.rightSpaceToView(_pickerBG,10)
            .heightIs(250)
            .widthIs((SCREEN_WIDTH-70)/2)
            .topSpaceToView(_pm,10);
            
            
        }
    }
    return self;
}
-(void)onCancelBtnCLick{
    [self.delegate ondatePickerCancelClick];
}
-(void)onPickSureBtnCLick{
    //获取日期
//    NSDate *date1 = self.dateStart.date;
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
NSString *timestamp = [formatter stringFromDate:self.dateStart.date];
 
    NSString *timestamp2 = [formatter stringFromDate:self.dateEnd.date];
 
    [self.delegate ondatePickerSureClickWith:timestamp end:timestamp2];
}
@end
