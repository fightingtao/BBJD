//
//  UserInfoSaveModel.m
//  Shipper
//
//  Created by xc on 15/9/12.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import "UserInfoSaveModel.h"

@implementation UserInfoSaveModel
@synthesize city_name;
@synthesize driver_license;
@synthesize tag;
@synthesize vehicle;
@synthesize dominate_time;
@synthesize opposite_idcard;
@synthesize idcardno;
@synthesize level;
@synthesize emergency_contact_mobile;
@synthesize gender;
@synthesize is_payed;
@synthesize seller_id;
@synthesize key;
@synthesize apliy_account;
@synthesize intention_delivery_area;
@synthesize status;
@synthesize nickname;
@synthesize user_type;
@synthesize emergency_contact_name;
@synthesize user_status;
@synthesize positive_idcard;
@synthesize authen_status;
@synthesize header;
@synthesize point;
@synthesize primary_key;
@synthesize realname;
@synthesize hand_idcard;
@synthesize telephone;
@synthesize notify_switch;
@synthesize frozen_days;
@synthesize frozen_type;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.city_name = [coder decodeObjectForKey:@"city_name"];
        self.driver_license = [coder decodeObjectForKey:@"driver_license"];
        self.tag = [coder decodeObjectForKey:@"tag"] ;
        self.vehicle = [coder decodeObjectForKey:@"vehicle"];
        self.dominate_time = [coder decodeObjectForKey:@"dominate_time"];
        self.opposite_idcard = [coder decodeObjectForKey:@"opposite_idcard"];
        self.idcardno = [coder decodeObjectForKey:@"idcardno"];
        self.level = [coder decodeObjectForKey:@"level"];
        self.emergency_contact_mobile = [coder decodeObjectForKey:@"emergency_contact_mobile"] ;
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.is_payed = [coder decodeObjectForKey:@"is_payed"];
        self.seller_id = [coder decodeObjectForKey:@"seller_id"];
        self.key = [coder decodeObjectForKey:@"key"];
        self.apliy_account = [coder decodeObjectForKey:@"apliy_account"];
        self.intention_delivery_area = [coder decodeObjectForKey:@"intention_delivery_area"];
        self.status = [coder decodeObjectForKey:@"status"];
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.user_type = [coder decodeObjectForKey:@"user_type"];
        self.emergency_contact_name =[coder decodeObjectForKey:@"emergency_contact_name"];
        self.user_status = [coder decodeObjectForKey:@"user_status"] ;
        self.positive_idcard = [coder decodeObjectForKey:@"positive_idcard"];
        self.authen_status = [coder decodeObjectForKey:@"authen_status"] ;
        self.header = [coder decodeObjectForKey:@"header"] ;
        self.point = [coder decodeObjectForKey:@"point"];
        self.primary_key = [coder decodeObjectForKey:@"primary_key"];
        self.realname = [coder decodeObjectForKey:@"realname"] ;
        self.hand_idcard = [coder decodeObjectForKey:@"hand_idcard"];
        self.telephone = [coder decodeObjectForKey:@"telephone"];
        self.notify_switch = [coder decodeObjectForKey:@"notify_switch"];
        self.frozen_days= [coder decodeObjectForKey:@"frozen_days"];
        self.frozen_type = [coder decodeObjectForKey:@"frozen_type"];

    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.city_name forKey:@"city_name"];
    [coder encodeObject:self.driver_license forKey:@"driver_license"];
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.vehicle forKey:@"vehicle"];
    [coder encodeObject:self.dominate_time forKey:@"dominate_time"];
    [coder encodeObject:self.opposite_idcard forKey:@"opposite_idcard"];
    [coder encodeObject:self.idcardno forKey:@"idcardno"];
    [coder encodeObject:self.emergency_contact_mobile forKey:@"emergency_contact_mobile"];
    [coder encodeObject:[NSString stringWithFormat:@"%@",self.gender] forKey:@"gender"];
    [coder encodeObject:[NSString stringWithFormat:@"%@",self.is_payed] forKey:@"is_payed"];
    
       [coder encodeObject:[NSString stringWithFormat:@"%@ ",self.seller_id] forKey:@"seller_id"];
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.apliy_account forKey:@"apliy_account"];
    
    [coder encodeObject:self.intention_delivery_area forKey:@"intention_delivery_area"];
    [coder encodeObject:[NSString stringWithFormat:@"%@",self.status] forKey:@"status"];
    [coder encodeObject:self.nickname forKey:@"nickname"];

    [coder encodeObject:[NSString stringWithFormat:@"%@",self.user_type] forKey:@"user_type"];
    [coder encodeObject:self.user_status forKey:@"user_status"];
    [coder encodeObject:self.emergency_contact_name forKey:@"emergency_contact_name"];
    [coder encodeObject:self.positive_idcard forKey:@"positive_idcard"];
    [coder encodeObject:self.authen_status forKey:@"authen_status"];
    [coder encodeObject:self.header forKey:@"header"];
    [coder encodeObject:[NSString stringWithFormat:@"%@",self.point] forKey:@"point"];
    [coder encodeObject:self.primary_key forKey:@"primary_key"];
     [coder encodeObject:self.realname forKey:@"realname"];
     [coder encodeObject:self.hand_idcard forKey:@"hand_idcard"];
     [coder encodeObject:self.telephone forKey:@"telephone"];
     [coder encodeObject:self.notify_switch forKey:@"notify_switch"];
    [coder encodeObject:self.frozen_days forKey:@"frozen_days"];
    [coder encodeObject:self.frozen_type forKey:@"frozen_type"];
}
@end
