//
//  oneMessageVC.h
//  BBJD
//
//  Created by cbwl on 16/12/23.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
@interface oneMessageVC : UIViewController
    @property (weak, nonatomic) IBOutlet UITextView *phoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UILabel *msgLength;
@property (weak, nonatomic) IBOutlet UILabel *selectNub;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *msgnub;

@property (weak, nonatomic) IBOutlet UIView *list_msgBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *list_msgheight;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bgView;
@property (nonatomic,copy) NSString *smstemplateId;

@end
