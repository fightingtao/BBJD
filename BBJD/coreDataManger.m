//
//  coreDataManger.m
//  coreData
//
//  Created by cbwl on 16/12/9.
//  Copyright © 2016年 CYT. All rights reserved.
//
#define kCoreDataClassName @"ListDetail"
#define kCoreDataName @"coreDataList"
#define kSaveCoreDataName @"coreDataList.sqlite"


#define kChatDetailCoreDataClassName @"ChatDetail"
#define kChatDetailCoreDataName @"ChatDetailcoreDataList"
#define kChatDetailSaveCoreDataName @"ChatDetailcoreDataList.sqlite"


#import "coreDataManger.h"
@implementation coreDataManger
coreDataManger *manager = nil;

///查询
-(NSArray *)lookCoreData{
    //查询数据
    NSManagedObjectContext *context = [self managedObjectContext];
    //获取表
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCoreDataClassName inManagedObjectContext:context];
    //创建请求
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    //    排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sort];//数组中可以放置多个sort，一般就用一个
    

    //发起请求
    NSArray *arr = [context executeFetchRequest:request error:nil];
    // for (NSManagedObject *object in arr) {
      //  NSString *name = [object valueForKey:@"phone"];
      //  NSNumber *msgText = [object valueForKey:@"msgText"];
       // NSString *time = [object valueForKey:@"time"];
      //   NSLog(@"lookCoreData %@ %@ %@",name,msgText,time);
        
        
  //  }
return arr;
//    NSLog(@"线程  %@",[NSRunLoop currentRunLoop]);
}

///添加到数据库
-(void)insertCoreDataObjectWithOrder:(ListDetails  *)order{
    NSManagedObjectContext *context = self.managedObjectContext;
    //NSEntityDescription实例：数据库中的表
    //NSManagedObject代表一条数据
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataClassName inManagedObjectContext:context];
    [object setValue:order.phone forKey:@"phone"];
    [object setValue:order.isRead forKey:@"isRead"];
    [object setValue:order.time forKey:@"time"];
    [object setValue:order.msgText forKey:@"msgText"];
    [object setValue:order.isSend forKey:@"isSend"];
    [object setValue:order.recipient_mobile forKey:@"recipient_mobile"];
    //NSLog(@"保存coredata %@",object.class);
    
    [self saveContext];
//    NSLog(@"线程 插入  %@",[NSRunLoop currentRunLoop]);

}


///删除   orderId  关键词
-(void)delectManager:(NSString *)orderId{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCoreDataClassName inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    //创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"phone CONTAINS '%@'",orderId]];//like
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"phone like '%@'",NULL]];//like

    //将谓词赋予请求
    request.predicate = predicate;
    
    //发送请求
    NSArray *arr = [context executeFetchRequest:request error:nil];
    //遍历数据
    for (NSManagedObject *object in arr) {
       // NSLog(@"删除一条数据 %@ %@",[object valueForKey:@"phone"],[object valueForKey:@"time"]);
        //删除一条数据
        [context deleteObject:object];
    }
//      修改一条数据
//    NSManagedObject *object = arr[0];
//   [object setValue:@"张三21" forKey:@"name"];
  
    
    [self saveContext];
//    NSLog(@"线程  删除 %@",[NSRunLoop currentRunLoop]);

}
///修改coredata 数据   关键词:orderId
-(void)changeCoreDataMsg:(NSString *)orderId kind:(NSString *)kind changeText:(NSString *)changeText isSend:(NSString *)send{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCoreDataClassName inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    //创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"phone like '%@'",orderId]];
    //将谓词赋予请求
    request.predicate = predicate;
    
    //发送请求
    NSArray *arr = [context executeFetchRequest:request error:nil];
    //遍历数据
    for (NSManagedObject *object in arr) {
    //    NSLog(@"%@ %@",[object valueForKey:@"phone"],[object valueForKey:@"age"]);
        //修改一条数据
        //NSManagedObject *object = arr[0];
        if ([kind isEqualToString:@"read"]) {
            NSManagedObject *obj=object;
            [obj  setValue:changeText forKey:@"isRead"];//已读
            
        }
        else if ([kind isEqualToString:@"msgText"]){
            
        [object setValue:changeText forKey:@"msgText"];//获取到了短信内容
        [object setValue:send forKey:@"isSend"];//发送状态  0 成功 -1 失败

         //   NSLog(@"数据库修改数据保存成功 ");
        }
        
    }
    [self saveContext];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         //   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark -  chatMsgDetail 聊天详情
///查询
-(NSArray *)lookChatDetailCoreData{
    //查询数据
    NSManagedObjectContext *context = [self managedObjectContext];
    //获取表
    NSEntityDescription *entity = [NSEntityDescription entityForName:kChatDetailCoreDataClassName inManagedObjectContext:context];
    //创建请求
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    //    排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sort];//数组中可以放置多个sort，一般就用一个

    //发起请求
    NSArray *arr = [context executeFetchRequest:request error:nil];

 /*   for (NSManagedObject *object in arr) {
        NSString *phoneID = [object valueForKey:@"phoneID"];
>>>>>>> 4ab4426828149e0ad1f773d811fbd7720a0ff84c
        NSString *name = [object valueForKey:@"moble"];
        NSNumber *age = [object valueForKey:@"msgText"];
        NSString *time = [object valueForKey:@"time"];
        NSLog(@"lookChatCoreData %@ %@ %@",name,age,time);
        
        
    }*/
    return arr;
    //    NSLog(@"线程  %@",[NSRunLoop currentRunLoop]);
}

///添加到数据库
-(void)insertChatDetailCoreDataObjectWithOrder:(chatDetail  *)order{
    NSManagedObjectContext *context = self.managedObjectContext;
    //NSEntityDescription实例：数据库中的表
    //NSManagedObject代表一条数据
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:kChatDetailCoreDataClassName inManagedObjectContext:context];
    [object setValue:order.moble forKey:@"moble"];
    //[object setValue:order.isRead forKey:@"isRead"];
    [object setValue:order.time forKey:@"time"];
    [object setValue:order.msgText forKey:@"msgText"];
    [object setValue:order.phoneID forKey:@"phoneID"];
    [object setValue:order.recipient_mobile forKey:@"recipient_mobile"];
    //NSLog(@"保存coredata %@",object.class);
    
    [self saveContext];
    //    NSLog(@"线程 插入  %@",[NSRunLoop currentRunLoop]);
    
}

///删除   orderId  关键词
-(void)delectChatDetailManager:(NSString *)orderId{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:kChatDetailCoreDataClassName inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    //创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"moble CONTAINS '%@'",orderId]];//like
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"phone like '%@'",NULL]];//like
    
    //将谓词赋予请求
    request.predicate = predicate;
    
    //发送请求
    NSArray *arr = [context executeFetchRequest:request error:nil];
    //遍历数据
    for (NSManagedObject *object in arr) {
      //  NSLog(@"删除一条数据 %@ %@",[object valueForKey:@"moble"],[object valueForKey:@"time"]);
        //删除一条数据
        [context deleteObject:object];
    }
    //      修改一条数据
    //    NSManagedObject *object = arr[0];
    //   [object setValue:@"张三21" forKey:@"name"];
    
    
    [self saveContext];
    //    NSLog(@"线程  删除 %@",[NSRunLoop currentRunLoop]);
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kCoreDataName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{

    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //记录数据库文件存放的位置
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kSaveCoreDataName];
    
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options =@{NSMigratePersistentStoresAutomaticallyOption:@true, NSInferMappingModelAutomaticallyOption:@true};

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
     }
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
+(instancetype)shareinstance{
    if (!manager) {
        static dispatch_once_t onceTaken;
        dispatch_once(&onceTaken,^{
            manager=[[self alloc]init];
        });
    }
    return manager;
}

// 防止使用alloc开辟空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if(!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [super allocWithZone:zone];
        });
    }
    return manager;
}

// 防止copy
+ (id)copyWithZone:(struct _NSZone *)zone{
    if(!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [super copyWithZone:zone];
        });
    }
    return manager;
}
// 使用同步锁保证init创建唯一单例 ( 与once效果相同 )
- (instancetype)init{
    @synchronized(self) {
        self = [super init];
    }
    return self;
}
@end
