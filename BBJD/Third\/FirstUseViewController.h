//
//  FirstUseViewController.h
//  SendMessage
//
//  Created by 李志明 on 16/8/31.
//  Copyright © 2016年 李志明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol btnActionDelegate<NSObject>
-(void)goToMainView;

@end
@interface FirstUseViewController : UIViewController

@property(nonatomic,weak)id < btnActionDelegate> delegate;
@end
