//
//  ListDetail.h
//  BBJD
//
//  Created by cbwl on 17/1/5.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDetails : NSObject
@property (nonatomic,copy)NSString *phone;//收件人手机号
@property (nonatomic,copy)NSString *time;//发送时间
@property (nonatomic,copy)NSString *msgText;//内容
@property (nonatomic,copy)NSString *isRead;//是否已读 是否已读  0未读 1已读
@property (nonatomic,copy)NSString *isSend;//是否发送成功 1=成功，0=失败
@property (nonatomic,copy)NSString *recipient_mobile;//发件人手机号

@end
