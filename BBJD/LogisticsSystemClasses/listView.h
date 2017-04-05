//
//  listView.h
//  BBJD
//
//  Created by cbwl on 17/1/4.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  ListCloseDelegate <NSObject>

-(void)closeListBtnClick;

@end
@interface listView : UIView
@property(nonatomic,strong)UILabel *titleL;//
@property(nonatomic,strong)UILabel *detail;//
@property(nonatomic,strong)UIButton *close;
@property (nonatomic,strong)id <ListCloseDelegate>delegate;
@end
