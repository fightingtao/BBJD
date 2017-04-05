//
//  MsgViewModel.h
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "publicResource.h"
@interface MsgViewModel : NSObject
//加载数据
@property(nonatomic,strong)RACCommand   *loadCommand;
@property(nonatomic,strong)NSMutableArray *dataList;
//底部按钮
@property(nonatomic,strong)RACCommand   *btnCommoand;

@end
