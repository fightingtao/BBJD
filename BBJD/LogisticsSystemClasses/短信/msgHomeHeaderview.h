//
//  msgHomeHeaderview.h
//  BBJD
//
//  Created by cbwl on 16/12/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol allAndFailBtnDelegate <NSObject>
-(void)allBtnCLickWithBtn:(UIButton *)sender;
-(void)failBtnCLickWithBtn:(UIButton *)sender;
@end

@interface msgHomeHeaderview : UIView
@property (nonatomic,strong)UIButton *allBtn;//全部短信
@property (nonatomic,strong)UIButton *failBtn;//发送失败

@property (nonatomic,strong)UILabel *line;
@property (nonatomic,strong)UILabel *bottomLine;
@property (nonatomic,strong)UISearchBar *searchBr;//

@property (nonatomic,strong)UIView *viewBg;
@property (nonatomic,strong)id <allAndFailBtnDelegate>delegate;
@end
