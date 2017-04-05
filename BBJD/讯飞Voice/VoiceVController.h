//
//  VoiceVController.h
//  BBZhongBao
//
//  Created by cbwl on 16/12/21.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VoiceViewCDelegate <NSObject>
-(void)cancelVoiceBtnClick;
-(void)makeSureVoiceBtnClick;
@end
@interface VoiceVController : UIViewController
@property(nonatomic,strong)id <VoiceViewCDelegate>delegate;
@end
