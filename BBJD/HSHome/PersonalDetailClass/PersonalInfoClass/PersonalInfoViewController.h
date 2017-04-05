//
//  PersonalInfoViewController.h
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "HZQDatePickerView.h"
#import "UserInfoSaveModel.h"
#import "billVController.h"

#import <TAESDK/TAESDK.h>
#import <ALBBMediaService/ALBBMediaService.h>
#import <ALBBMediaService/ALBBMediaServiceProtocol.h>

@interface PersonalInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,HZQDatePickerViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIActionSheet *headSheet;
@property (nonatomic, strong) UIActionSheet *sexSheet;
//@property (nonatomic, strong) HZQDatePickerView *pikerView;

@end
