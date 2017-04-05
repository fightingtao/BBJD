//
//  LOtherSignViewController.h
//  CYZhongBao
//
//  Created by xc on 16/1/26.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "iToast.h"
#import "NetModel.h"



@protocol LOtherSignDelegate <NSObject>

- (void)LOtherSignWithName:(NSString*)name;

@end

@interface LOtherSignViewController : UIViewController <UIAlertViewDelegate>

{
    
    UIAlertView *AlertViewOne;
    
}

@property (nonatomic, strong) id<LOtherSignDelegate>delegate;


@end
