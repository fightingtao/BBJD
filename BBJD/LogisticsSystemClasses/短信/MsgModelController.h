//
//  MsgModelController.h
//  BBJD
//
//  Created by 李志明 on 17/2/23.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgViewModel.h"
@interface MsgModelController : UIViewController
@property(nonatomic,strong)MsgViewModel *viewModel;
@property(nonatomic,strong)RACSubject *selectSubject;
@end
