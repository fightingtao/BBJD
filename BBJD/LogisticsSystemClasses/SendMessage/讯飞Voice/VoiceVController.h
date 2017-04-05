//
//  VoiceVController.h
//  BBJD
//
//  Created by cbwl on 16/12/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VoiceViewCDelegate <NSObject>
-(void)cancelVoiceBtnClick;
-(void)finishReginise:(NSString *)resultString;

@end
@interface VoiceVController : UIViewController
@property(nonatomic,weak)id <VoiceViewCDelegate>delegate;

@end
