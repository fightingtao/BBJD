//
//  LOrderProblemListViewController.h
//  CYZhongBao
//
//  Created by xc on 16/1/27.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"

#import "UserInfoSaveModel.h"
#import "NetModel.h"


@protocol LOrderSignProblemDelegate <NSObject>



@end

@interface LOrderProblemListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

{
    
     UIAlertView *AlertViewOne;
    
   
    
}

@property (nonatomic, strong) NSString *TypeStr;

@property (nonatomic, strong) NSString *exptycode;

//@property (nonatomic, strong) Out_LOrderDetailBody *tempModel;

@property (nonatomic, strong) NSString *DateStr;

@property (nonatomic, strong) id<LOrderSignProblemDelegate>delegate;

- (void)getExptReasonWithType:(int)type;

@end
