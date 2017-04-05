//
//  MessageVController.h
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"

@interface MessageVController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *msgLength;
@property (weak, nonatomic) IBOutlet UILabel *select;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *msgNub;
@property (nonatomic,strong) NSMutableArray *phoneAry;//手机号数组
@property(nonatomic,strong)NSMutableArray *showArray;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic,copy)NSString *phone;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,copy)NSString *smstemplateId;//使用模板的id，没有则为0
@property(nonatomic,strong)RACSubject *msgSubject;
@property(nonatomic,strong)NSString *phoneList;
@property(nonatomic,assign)NSInteger status;

@end
