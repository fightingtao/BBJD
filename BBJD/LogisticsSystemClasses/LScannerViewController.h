//
//  LScannerViewController.h
//  CYZhongBao
//
//  Created by xc on 16/1/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicResource.h"
#import "iToast.h"
#import <AVFoundation/AVFoundation.h>
@interface LScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    
}
@property(nonatomic,strong)NSString *seller_type;//1 企业商家或者是**
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property(nonatomic,strong)CALayer *layer;
@property(nonatomic,strong)NSString *requirment_id;
@end
