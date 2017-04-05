//
//  coreDataManger.h
//  coreData
//
//  Created by cbwl on 16/12/9.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ListDetails.h"
#import "chatDetail.h"//短信详情

@interface coreDataManger : NSObject

//管理对象上下文：相对于数据库本身
@property ( strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//xcdatamodel
@property ( strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//中转站

@property ( strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

///修改数据
-(void)changeCoreDataMsg:(NSString *)orderId kind:(NSString *)kind changeText:(NSString *)changeText isSend:(NSString *)send;
///删除   orderId  关键词
-(void)delectManager:(NSString *)orderId;
///添加到数据库
-(void)insertCoreDataObjectWithOrder:(ListDetails  *)order;
///查询
-(NSArray *)lookCoreData;

#pragma mark 短信详情
///添加到数据库
-(void)insertChatDetailCoreDataObjectWithOrder:(chatDetail  *)order;
///查询
-(NSArray *)lookChatDetailCoreData;
-(void)delectChatDetailManager:(NSString *)orderId;

+(instancetype)shareinstance;
@end
